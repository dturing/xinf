/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.inity;

import xinf.geom.Matrix;
import xinf.geom.Types;
import xinf.geom.Transform;

import xinf.erno.Renderer;
import xinf.erno.ObjectModelRenderer;
import xinf.erno.Constants;
import xinf.erno.ImageData;
import xinf.erno.TextFormat;
import xinf.erno.TGradientStop;

import opengl.GL;
import opengl.GLU;
import openvg.VG;
import openvg.VGU;
import openvg.Path;
import openvg.Paint;
import cptr.CPtr;

//typedef Primitive = GLObject
import xinf.inity.GLRenderer;

class GLVGRenderer extends GLRenderer {
    
    private var path:Path;
	
	var fill:Paint;
	var stroke:Paint;

	function setGradientParameters( paint:Paint, _stops:Iterable<TGradientStop>, spread:Int ) {
		var stops = Lambda.array(_stops);
		var vg_stops = CPtr.float_alloc( stops.length*5 );
		var n=0;
		
		for( stop in stops ) {
			CPtr.float_set( vg_stops, n++, stop.offset );
			CPtr.float_set( vg_stops, n++, stop.r );
			CPtr.float_set( vg_stops, n++, stop.g );
			CPtr.float_set( vg_stops, n++, stop.b );
			CPtr.float_set( vg_stops, n++, stop.a );
		}
		paint.setParameterfv( VG.PAINT_COLOR_RAMP_STOPS, stops.length*5, vg_stops );

		var sprd = switch(spread) {
			case Constants.SPREAD_PAD: VG.COLOR_RAMP_SPREAD_PAD;
			case Constants.SPREAD_REFLECT: VG.COLOR_RAMP_SPREAD_REFLECT;
			case Constants.SPREAD_REPEAT: VG.COLOR_RAMP_SPREAD_REPEAT;
			default: VG.COLOR_RAMP_SPREAD_PAD;
		}
		paint.setParameteri( VG.PAINT_COLOR_RAMP_SPREAD_MODE, sprd );
	}
	
	function setFillPaintTransform( transform:Transform ) {
		VG.seti( VG.MATRIX_MODE, VG.MATRIX_FILL_PAINT_TO_USER );
		if( transform==null ) VG.loadIdentity();
		else VG.loadMatrix( matrixForVG( transform.getMatrix() ) );
	}

	function setStrokePaintTransform( transform:Transform ) {
		VG.seti( VG.MATRIX_MODE, VG.MATRIX_STROKE_PAINT_TO_USER );
		if( transform==null ) VG.loadIdentity();
		else VG.loadMatrix( matrixForVG( transform.getMatrix() ) );
	}

	function makePaint( givenPaint:xinf.erno.Paint, fill:Bool ) {
		var paint = Paint.create();
		switch( givenPaint ) {
			case None:
				var c = CPtr.float_alloc( 4 );
				CPtr.float_from_array( c, untyped [ 0,0,0,0 ].__a );
				paint.setParameterfv( VG.PAINT_COLOR, 4, c );
		
			case SolidColor(r,g,b,a):
				var c = CPtr.float_alloc( 4 );
				CPtr.float_from_array( c, untyped [ r,g,b,a ].__a );
				paint.setParameterfv( VG.PAINT_COLOR, 4, c );
				
			case PLinearGradient( _stops, x1, y1, x2, y2, transform, spread ):
				var box = CPtr.float_alloc(4);
				CPtr.float_set(box,0,x1);
				CPtr.float_set(box,1,y1);
				CPtr.float_set(box,2,x2);
				CPtr.float_set(box,3,y2);
				
				if( fill ) setFillPaintTransform( transform );
				else setStrokePaintTransform( transform );
				
				setGradientParameters( paint, _stops, spread );
				paint.setParameteri( VG.PAINT_TYPE, VG.PAINT_TYPE_LINEAR_GRADIENT );
				paint.setParameterfv( VG.PAINT_LINEAR_GRADIENT, 4, box );

			case PRadialGradient( _stops, cx, cy, r, fx, fy, transform, spread ):
				var box = CPtr.float_alloc(5);
				CPtr.float_set(box,0,cx);
				CPtr.float_set(box,1,cy);
				CPtr.float_set(box,2,fx);
				CPtr.float_set(box,3,fy);
				CPtr.float_set(box,4,r);

				if( fill ) setFillPaintTransform( transform );
				else setStrokePaintTransform( transform );

				setGradientParameters( paint, _stops, spread );
				paint.setParameteri( VG.PAINT_TYPE, VG.PAINT_TYPE_RADIAL_GRADIENT );
				paint.setParameterfv( VG.PAINT_RADIAL_GRADIENT, 5, box );

			default:
				throw("unimplemented paint: "+givenPaint );
		}
		return paint;
	}

	override function applyFill() :Bool {
		if( pen.fill==null || pen.fill==xinf.erno.Paint.None ) return false;
		fill = makePaint( pen.fill, true );
		fill.set( VG.FILL_PATH );
		return true;
	}

	override function applyStroke() :Bool {
		if( pen.stroke==null || pen.stroke==xinf.erno.Paint.None ) return false;
		stroke = makePaint( pen.stroke, false );
		stroke.set( VG.STROKE_PATH );
	
		VG.setf( VG.STROKE_LINE_WIDTH, pen.width );
		
		var join = switch( pen.join ) {
				case Constants.JOIN_MITER: VG.JOIN_MITER;
				case Constants.JOIN_ROUND: VG.JOIN_ROUND;
				case Constants.JOIN_BEVEL: VG.JOIN_BEVEL;
				default: VG.JOIN_BEVEL;
			}
		VG.seti( VG.STROKE_JOIN_STYLE, join );
		
		var caps = switch( pen.caps ) {
				case Constants.CAPS_BUTT: VG.CAP_BUTT;
				case Constants.CAPS_ROUND: VG.CAP_ROUND;
				case Constants.CAPS_SQUARE: VG.CAP_SQUARE;
				default: VG.CAP_BUTT;
			}
		VG.seti( VG.STROKE_CAP_STYLE, caps );

		if( pen.miterLimit!=null )
			VG.setf( VG.STROKE_MITER_LIMIT, pen.miterLimit );
			
		if( pen.dashArray!=null ) {
			var l=0; for( i in pen.dashArray ) l++;
			var dash = CPtr.float_alloc(l);
			CPtr.float_from_array( dash, neko.Lib.haxeToNeko(pen.dashArray) );
			
			VG.setfv( VG.STROKE_DASH_PATTERN, l, dash );
			VG.seti( VG.STROKE_DASH_PHASE_RESET, 1 );
			VG.setf( VG.STROKE_DASH_PHASE, pen.dashOffset );
		} else {
			VG.setfv( VG.STROKE_DASH_PATTERN, 0, neko.Lib.haxeToNeko("") );
		}
			
		return true;
	}

	function drawPath( f:Path->Void ) {
		var path = Path.create( VG.PATH_FORMAT_STANDARD, VG.PATH_DATATYPE_F,
			1,0,0,0, VG.PATH_CAPABILITY_ALL );
			
		f(path);
        
		if( applyFill() )   path.draw( VG.FILL_PATH );
		if( applyStroke() ) path.draw( VG.STROKE_PATH );
	}

   // erno.Renderer API
    
    override public function startShape() {
	    if( path != null ) throw("Can only define one path at a time");
		path = Path.create( VG.PATH_FORMAT_STANDARD, VG.PATH_DATATYPE_F,
			1,0,0,0, VG.PATH_CAPABILITY_ALL );
	}
    
    override public function endShape() {
	    if( path==null ) throw("no current Polygon");

		if( applyFill() ) path.draw( VG.FILL_PATH );
		if( applyStroke() ) path.draw( VG.STROKE_PATH );
		
        path = null;
    }

	function append( type:Int, data:Array<Float> ) {
		if( path==null ) throw("no current Polygon");
		
        var t = CPtr.uchar_alloc(1);
		CPtr.uchar_set(t,0,type);
		
		var d=null;
		if( data.length!=null ) {
			d= CPtr.float_alloc( data.length );
			CPtr.float_from_array( d, untyped data.__a );
		}
		
		path.appendData( 1, t, d );
	}

    override public function startPath( x:Float, y:Float) {
		append( VG.MOVE_TO_ABS, [x,y] );
    }
	
    override public function endPath() {
    }
    
    override public function close() {
		append( VG.CLOSE_PATH, [] );
    }
    
    override public function lineTo( x:Float, y:Float ) {
		append( VG.LINE_TO_ABS, [x,y] );
    }
    
    override public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
		append( VG.QUAD_TO_ABS, [x1,y1,x,y] );
    }
    
    override public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
		append( VG.CUBIC_TO_ABS, [x1,y1,x2,y2,x,y] );
    }

    override public function arcTo( x1:Float, y1:Float, rx:Float, ry:Float, rotation:Float, largeArcFlag:Bool, sweepFlag:Bool, x:Float, y:Float ) {
		if( x1==x && y1==y ) return;
		if( rx==0 || ry==0 ) { lineTo( x,y ); return; }
		
        var a = (rotation/180)*Math.PI;
        var A = { x:x1, y:y1 };
        var B = { x:x, y:y };
        var P = { x:(A.x-B.x)/2, y:(A.y-B.y)/2 };
        P = rotatePoint( P, -a );

        var lambda = (Math.pow(P.x,2)/Math.pow(rx,2)) + (Math.pow(P.y,2)/Math.pow(rx,2));
        if( lambda>1 ) {
            rx *= Math.sqrt(lambda);
            ry *= Math.sqrt(lambda);
        }
        
        var f = ( (Math.pow(rx,2)*Math.pow(ry,2))-(Math.pow(rx,2)*Math.pow(P.y,2))-Math.pow(ry,2)*Math.pow(P.x,2))
            / ( (Math.pow(rx,2)*Math.pow(P.y,2)) + (Math.pow(ry,2)*Math.pow(P.x,2)) );
        if( f<0 ) f=0 else f=Math.sqrt(f);
        if( largeArcFlag==sweepFlag ) f*=-1;
        
        var C_ =  { x: rx/ry*P.y, y: -ry/rx*P.x };
        C_.x*=f; C_.y*=f;
        var C = C_;
        
        C = rotatePoint(C,a);
        C = { x: C.x + ((A.x+B.x)/2),
              y: C.y + ((A.y+B.y)/2) };
        
        var theta = Math.atan2( (P.y-C_.y)/ry, (P.x-C_.x)/rx );
        var dTheta = Math.atan2( (-P.y-C_.y)/ry, (-P.x-C_.x)/rx)-theta;
        
        if( !sweepFlag && dTheta<0 ) dTheta += 2*Math.PI;
        if( sweepFlag && dTheta>0 ) dTheta -= 2*Math.PI;

		VGU.arc( path,
			C.x, C.y, rx*2, ry*2, (theta/Math.PI)*180, (dTheta/Math.PI)*180, VGU.ARC_OPEN );
	}
	
    override public function rect( x:Float, y:Float, w:Float, h:Float ) {
        current.mergeBBox( {l:x,t:y,r:x+w,b:y+h} );
		drawPath( function(path) {
			VGU.rect(path,x,y,w,h);
		});
	}
	
    override public function roundedRect( x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float ) {
        current.mergeBBox( {l:x,t:y,r:x+w,b:y+h} );
		drawPath( function(path) {
			VGU.roundRect(path,x,y,w,h,rx*2,ry*2);
		});
	}

    override public function ellipse( x:Float, y:Float, rx:Float, ry:Float ) {
        current.mergeBBox( {l:x-rx,t:y-ry,r:x+rx,b:y+ry} );
		drawPath( function(path) {
			VGU.ellipse(path,x,y,rx*2,ry*2);
		});
	}

    /* helper functions */
        
    public static function matrixForVG( m:TMatrix ) :Dynamic {
        var v = CPtr.float_alloc(9);
        
        CPtr.float_set(v,0,m.a);
        CPtr.float_set(v,1,m.b);
        CPtr.float_set(v,2,.0);

        CPtr.float_set(v,3,m.c);
        CPtr.float_set(v,4,m.d);
        CPtr.float_set(v,5,.0);

        CPtr.float_set(v,6,m.tx);
        CPtr.float_set(v,7,m.ty);
        CPtr.float_set(v,8,1.);
        
        return v;
    }
}
