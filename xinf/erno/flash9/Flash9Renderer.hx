/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.flash9;

import xinf.erno.Renderer;
import xinf.erno.ObjectModelRenderer;
import xinf.erno.Constants;
import xinf.erno.ImageData;
import xinf.erno.TextFormat;
import xinf.erno.Paint;
import xinf.erno.TGradientStop;

import xinf.geom.Transform;
import xinf.geom.Types;

import flash.display.Sprite;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;

typedef Primitive = Dynamic // FIXME XinfSprite

class Flash9Renderer extends ObjectModelRenderer<Primitive> {

	var last		: { x:Float, y:Float };
	var first		: { x:Float, y:Float };

    override public function createPrimitive(id:Int) :Primitive {
        // create new object
        var o = new XinfSprite(); // FIXME Primitive();
        o.xinfId = id;
        return o;
    }
    
    override public function clearPrimitive( p:Primitive ) {
        p.graphics.clear();
        for( i in 0...p.numChildren ) {
            p.removeChildAt(0);
        }
    }
    
    override public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
		if( child.parent!=null && child.parent!=parent ) {
			//parent.addChild( child.duplicateMovieClip() );
			child.parent.removeChild(child);
		} //else
		parent.addChild( child );
    }

    /* our part of the drawing protocol */
    
    override public function setPrimitiveTransform( p:Primitive, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
        p.x=0; p.y=0;
        p.transform.matrix = new flash.geom.Matrix( a,b,c,d,x,y );
    }

    override public function setPrimitiveTranslation( p:Primitive, x:Float, y:Float ) :Void {
        p.x = x;
        p.y = y;
    }

    override public function clipRect( w:Float, h:Float ) {
        var crop = new Sprite();
        var g = crop.graphics;
        g.beginFill( 0xff0000, 1 );
        g.drawRect(0,0,w+1,h+1);
        g.endFill();
        current.addChild(crop);
        current.mask = crop;
    }

	function flashGradient( stops:Iterable<TGradientStop>, spread:Int ) {
		var colors = new Array();
		var alphas = new Array();
		var ratios = new Array();
		var lR=0.;
		for( stop in stops ) {
			colors.push( colorToRGBInt( stop.r, stop.g, stop.b ) );
			alphas.push( stop.a );
			if( stop.offset < lR ) throw("LinearGradient offset out of sequence");
			lR = Math.max(0,Math.min(1,stop.offset));
			ratios.push(lR*255);
		}
		var sprd = switch(spread) {
			case Constants.SPREAD_PAD: SpreadMethod.PAD;
			case Constants.SPREAD_REFLECT: SpreadMethod.REFLECT;
			case Constants.SPREAD_REPEAT: SpreadMethod.REPEAT;
			default: SpreadMethod.PAD;
		}
		
		return {
			colors:colors, alphas:alphas, ratios:ratios,
			spread:sprd };
	}

	function flashLinearGradient( x1:Float, y1:Float, x2:Float, y2:Float ) {
		var w = x2-x1; var h=y2-y1;
		var a = Math.atan2(h,w);
		var vl = Math.sqrt( Math.pow(w,2) + Math.pow(h,2) );
		
		var matr = new flash.geom.Matrix();
		matr.createGradientBox( 1, 1, 0, 0., 0. );

		matr.rotate( a );
		matr.scale( vl, vl );
		matr.translate( x1, y1 );
		
		return matr;
	}

	function flashRadialGradient( cx:Float, cy:Float, r:Float, fx:Float, fy:Float ) {
		var d = r*2;
		var matr = new flash.geom.Matrix();
		matr.createGradientBox( d, d, 0, 0., 0. );
/*
		var a = Math.atan2(fy-cy,fx-cx);
		matr.translate( -cx, -cy );
		matr.rotate( a );
		matr.translate( cx, cy );
*/		
		matr.translate( cx-r, cy-r );
		return matr;
	}

	function applyFill() {
		switch( pen.fill ) {
			case None:
				// do nothing
		
			case SolidColor(r,g,b,a):
				if( a>0 ) {
					current.graphics.beginFill( colorToRGBInt(r,g,b), a );
				}
				
			case PLinearGradient( stops, x1, y1, x2, y2, transform, spread ):
				var gr = flashGradient( stops, spread );
				var matrix = flashLinearGradient( x1,y1,x2,y2 );
				if( transform != null ) {
					var m = transform.getMatrix();
					matrix.concat( new flash.geom.Matrix( m.a,m.b,m.c,m.d,m.tx,m.ty ) );
				}
				current.graphics.beginGradientFill( GradientType.LINEAR, gr.colors, gr.alphas, gr.ratios, matrix, gr.spread, InterpolationMethod.RGB );
				
			case PRadialGradient( stops, cx, cy, r, fx, fy, transform, spread ):
				var gr = flashGradient( stops, spread );
				var matrix = flashRadialGradient( cx,cy,r,fx,fy );
				if( transform != null ) {
					var m = transform.getMatrix();
					matrix.concat( new flash.geom.Matrix( m.a,m.b,m.c,m.d,m.tx,m.ty ) );
				}
				var f = { x:fx-cx, y:fy-cy };
				var focalRatio = Math.sqrt( (f.x*f.x)+(f.y*f.y) )/r;
				current.graphics.beginGradientFill( GradientType.RADIAL, gr.colors, gr.alphas, gr.ratios, matrix, gr.spread, InterpolationMethod.RGB, focalRatio );
				
			default:
				throw("fill "+pen.fill+" not implemented");
		}
	}

	function applyStroke() {
		var caps:CapsStyle = switch( pen.caps ) {
			case Constants.CAPS_BUTT: CapsStyle.NONE;
			case Constants.CAPS_ROUND: CapsStyle.ROUND;
			case Constants.CAPS_SQUARE: CapsStyle.SQUARE;
			default: CapsStyle.NONE;
		}
		var join:JointStyle = switch( pen.join ) {
			case Constants.JOIN_MITER: JointStyle.MITER;
			case Constants.JOIN_ROUND: JointStyle.ROUND;
			case Constants.JOIN_BEVEL: JointStyle.BEVEL;
			default: JointStyle.MITER;
		}
		switch( pen.stroke ) {
			case None:
				current.graphics.lineStyle( pen.width, 0xff0000, 0, false );
			case SolidColor(r,g,b,a):
				current.graphics.lineStyle( pen.width, colorToRGBInt(r,g,b), a, false, LineScaleMode.NORMAL, caps, join, pen.miterLimit );
			case PLinearGradient( stops, x1, y1, x2, y2, transform, spread ):
				var gr = flashGradient( stops, spread );
				var matrix = flashLinearGradient( x1,y1,x2,y2 );
				if( transform != null ) {
					var m = transform.getMatrix();
					matrix.concat( new flash.geom.Matrix( m.a,m.b,m.c,m.d,m.tx,m.ty ) );
				}
				current.graphics.lineStyle( pen.width, 0, 1., false, LineScaleMode.NORMAL, caps, join, pen.miterLimit );
				current.graphics.lineGradientStyle( GradientType.LINEAR, gr.colors, gr.alphas, gr.ratios, matrix, gr.spread, InterpolationMethod.RGB );
			case PRadialGradient( stops, cx, cy, r, fx, fy, transform, spread ):
				var gr = flashGradient( stops, spread );
				var matrix = flashRadialGradient( cx,cy,r,fx,fy );
				if( transform != null ) {
					var m = transform.getMatrix();
					matrix.concat( new flash.geom.Matrix( m.a,m.b,m.c,m.d,m.tx,m.ty ) );
				}
				var f = { x:fx-cx, y:fy-cy };
				var focalRatio = Math.sqrt( (f.x*f.x)+(f.y*f.y) )/r;
				current.graphics.lineGradientStyle( GradientType.RADIAL, gr.colors, gr.alphas, gr.ratios, matrix, gr.spread, InterpolationMethod.RGB, focalRatio );
			default:
				throw("stroke "+pen.stroke+" not implemented");
		}
	}

    override public function startShape() {
		applyFill();
    }
    
    override public function endShape() {
		current.graphics.endFill();
    }
    
    override public function startPath( x:Float, y:Float) {
		applyStroke();
        current.graphics.moveTo(x,y);
        last = { x:x, y:y };
        first = { x:x, y:y };
    }
    
    override public function endPath() {
        current.graphics.lineStyle( 0, 0, 0 );
    }
    
    override public function close() {
        // FIXME
    }
    
    override public function lineTo( x:Float, y:Float ) {
        current.graphics.lineTo(x,y);
		last = { x:x, y:y };
	}
    
    override public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
        current.graphics.curveTo( x1,y1,x,y );
		last = { x:x, y:y };
    }
    
    override public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
		var s = xinf.geom.Lib.cubicBezierFM(last, {x:x1,y:y1}, {x:x2,y:y2}, {x:x,y:y});
		current.graphics.curveTo(s.control[0].x, s.control[0].y, s.anchor[0].x, s.anchor[0].y);
		current.graphics.curveTo(s.control[1].x, s.control[1].y, s.anchor[1].x, s.anchor[1].y);
		current.graphics.curveTo(s.control[2].x, s.control[2].y, s.anchor[2].x, s.anchor[2].y);
		current.graphics.curveTo(s.control[3].x, s.control[3].y, s.anchor[3].x, s.anchor[3].y);
		last = { x:x, y:y };
    }
        
    override public function rect( x:Float, y:Float, w:Float, h:Float ) {
        var g = current.graphics;
		applyStroke();
		applyFill();
        g.drawRect( x,y,w,h );
        g.endFill();
    }

    override public function roundedRect( x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float ) {
        var g = current.graphics;
		applyStroke();
		applyFill();
        g.drawRoundRect( x,y,w,h, 2*rx, 2*ry );
        g.endFill();
    }
    
    override public function ellipse( x:Float, y:Float, rx:Float, ry:Float ) {
        var g = current.graphics;
        applyStroke();
		applyFill();
        g.drawEllipse( x-rx,y-ry,rx*2,ry*2 );
        g.endFill();
    }
    
    override public function text( x:Float, y:Float, text:String, format:TextFormat ) {
        format.assureLoaded();
        
        // FIXME: textStyles
		if( pen.fill != null ) {
            var tf = new flash.text.TextField();
			switch( pen.fill ) {
				case SolidColor(r,g,b,a):
					format.format.color = colorToRGBInt(r,g,b);
					current.alpha = a;
				case None:
					format.format.color = 0;
					current.alpha = 1;
				default:
					format.format.color = 0;
					current.alpha = 1;
					trace("Fill "+pen.fill+" not supported for text");
			}
			
// FIXME			tf.embedFonts = true;
	
            tf.defaultTextFormat = format.format;
            tf.selectable = false;
            tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
            tf.y=y-1;
            tf.x=x;
            tf.text = text;
			
            current.addChild(tf);
		}
    }
    
    override public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
        if( img.bitmapData == null ) {
            return;
        }
        /* this works, but i feel it's not the most efficient way.
            if you can think of a better one, please submit a patch.
            else, we should at least make an exception for the default case ("natural" image size)*/
        var bm : flash.display.Bitmap;
        if( (inRegion == null) || (inRegion.x == 0 && inRegion.y == 0 && inRegion.w == img.width && inRegion.h == img.height) ) {
            bm = new flash.display.Bitmap( img.bitmapData );
        } else {
            var bd = new flash.display.BitmapData( Math.round( inRegion.w ), Math.round( inRegion.h ) );
            bd.copyPixels( img.bitmapData, new flash.geom.Rectangle( inRegion.x, inRegion.y, inRegion.w, inRegion.h ), new flash.geom.Point( 0, 0 ) );
            bm = new flash.display.Bitmap( bd );
        }

        if( pen.fill!=null ) {
			switch( pen.fill ) {
				case SolidColor(r,g,b,a):
					current.alpha = a;
				default:
			}
		}
			
     	current.addChild( bm );
     	
     	if( (outRegion != null)  && (outRegion != inRegion) ) {
	     	bm.width = outRegion.w;
    	 	bm.height = outRegion.h;
     		bm.x = outRegion.x;
     		bm.y = outRegion.y;
     	}
    }

    override public function native( o:NativeObject ) {
        current.addChild(o);
    }
    
    public static function colorToRGBInt(r:Float,g:Float,b:Float) : Int {
        return ( Math.round(r*0xff) << 16 ) | ( Math.round(g*0xff) << 8 ) | Math.round(b*0xff);
    }
}
