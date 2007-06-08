/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.flash9;

import xinf.erno.Renderer;
import xinf.erno.ObjectModelRenderer;
import xinf.erno.Color;
import xinf.erno.ImageData;
import xinf.erno.TextFormat;

import flash.display.Sprite;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

typedef Primitive = XinfSprite

class Flash9Renderer extends ObjectModelRenderer<Primitive> {
    
    override public function createPrimitive(id:Int) :Primitive {
        // create new object
        var o = new Primitive();
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
        parent.addChild( child );
    }

    /* our part of the drawing protocol */
    
    public function setPrimitiveTransform( p:Primitive, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
        p.x=0; p.y=0;
        p.transform.matrix = new flash.geom.Matrix( a,b,c,d,x,y );
    }

    public function setPrimitiveTranslation( p:Primitive, x:Float, y:Float ) :Void {
        p.x = x;
        p.y = y;
    }

    public function clipRect( w:Float, h:Float ) {
        var crop = new Sprite();
        var g = crop.graphics;
        g.beginFill( 0xff0000, 1 );
        g.drawRect(0,0,w+1,h+1);
        g.endFill();
        current.addChild(crop);
        current.mask = crop;
    }

    public function startShape() {
        if( pen.fillColor != null ) {
            current.graphics.beginFill( pen.fillColor.toRGBInt() );
        }
        if( pen.strokeColor!=null && pen.strokeWidth>0 ) {
            current.graphics.lineStyle( pen.strokeWidth, pen.strokeColor.toRGBInt(), pen.strokeColor.a );
        }
    }
    
    public function endShape() {
        if( pen.fillColor != null ) {
            current.graphics.endFill();
        }
    }
    
    public function startPath( x:Float, y:Float) {
        current.graphics.moveTo(x,y);
    }
    
    public function endPath() {
        current.graphics.moveTo(0,0);
    }
    
    public function close() {
        // FIXME
    }
    
    public function lineTo( x:Float, y:Float ) {
        current.graphics.lineTo(x,y);
    }
    
    public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
        current.graphics.curveTo( x1,y1,x,y );
    }
    
    public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
        throw("unimplemented");
    }
        
    public function rect( x:Float, y:Float, w:Float, h:Float ) {
        var g = current.graphics;
        if( pen.strokeColor!=null && pen.strokeWidth>0 ) {
            g.lineStyle( pen.strokeWidth, pen.strokeColor.toRGBInt(), pen.strokeColor.a,
                false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER );
        } else {
            g.lineStyle( 0, 0, 0 );
            pen.strokeWidth=0;
        }
        if( pen.fillColor != null ) {
            g.beginFill( pen.fillColor.toRGBInt(), pen.fillColor.a );
        } else {
            g.beginFill( 0, 0 );
        }
        g.drawRect( x+(pen.strokeWidth/2),y+(pen.strokeWidth/2),1+w-pen.strokeWidth,1+h-pen.strokeWidth );
        g.endFill();
    }
    
    public function circle( x:Float, y:Float, r:Float ) {
        var g = current.graphics;
        if( pen.strokeColor!=null && pen.strokeWidth>0 ) {
            g.lineStyle( pen.strokeWidth, pen.strokeColor.toRGBInt(), pen.strokeColor.a,
                false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER );
        } else {
            g.lineStyle( 0, 0, 0 );
        }
        if( pen.fillColor != null ) {
            g.beginFill( pen.fillColor.toRGBInt(), pen.fillColor.a );
        } else {
            g.beginFill( 0, 0 );
        }
        g.drawCircle( x,y,r );
        g.endFill();
    }
    
    public function text( x:Float, y:Float, text:String, format:TextFormat ) {
        format.assureLoaded();
        
        // FIXME: textStyles
        if( pen.fillColor != null ) {
            format.format.color = pen.fillColor.toRGBInt();
            var tf = new flash.text.TextField();
            tf.alpha = pen.fillColor.a;
            //tf.embedFonts = true;
            tf.defaultTextFormat = format.format;
            tf.selectable = false;
            tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
            tf.y=y;
            tf.x=x;
            tf.text = text;
            
            current.addChild(tf);
        }
    }
    
    public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
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
         
     	current.addChild( bm );
     	
     	if( (outRegion != null)  && (outRegion != inRegion) ) {
	     	bm.width = outRegion.w;
    	 	bm.height = outRegion.h;
     		bm.x = outRegion.x;
     		bm.y = outRegion.y;
     	}
    }

    public function native( o:NativeObject ) {
        current.addChild(o);
    }
    
}
