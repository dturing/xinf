/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.inity;

import xinf.geom.Matrix;
import xinf.erno.Renderer;
import xinf.erno.ObjectModelRenderer;
import xinf.erno.ImageData;
import xinf.erno.TextFormat;
import xinf.erno.Paint;

import opengl.GL;
import opengl.GLU;
import cptr.CPtr;


typedef Primitive = GLObject

class GLRenderer extends ObjectModelRenderer<Primitive> {
    
    private var circle_fill:Int;
    private var circle_stroke:Int;

    public function new() :Void {
        super();
    }

    // helper functions for ellipse and arcTo,
    // might move somewhere else (might be needed for flash too!)

    static var ELLIPSE_SEGMENTS:Int = 4;
    static var ELLIPSE_ANGLE:Float = ( Math.PI*2 ) / ELLIPSE_SEGMENTS;
    
    function rotatePoint( p:{x:Float,y:Float}, phi:Float ) :{x:Float,y:Float} {
        return { x: (Math.cos(phi)*p.x) + (-Math.sin(phi)*p.y),
                 y: (Math.sin(phi)*p.x) + (Math.cos(phi)*p.y) };
    }

    function ellipseSegment( cx:Float, cy:Float, rx:Float, ry:Float, phi:Float, theta:Float, dTheta:Float ) {
        var a1 = theta + dTheta/2;
        var a2 = theta + dTheta;
        var f = Math.cos( dTheta/2 );
        
        var p1 = { x: Math.cos(a1)*rx / f, y: Math.sin(a1)*ry / f };
        var p2 = { x: Math.cos(a2)*rx, y: Math.sin(a2)*ry };
        p1 = rotatePoint(p1,phi);
        p2 = rotatePoint(p2,phi);
        
      //  quadraticTo( cx+p1.x, cy+p1.y, cx+p2.x, cy+p2.y );
        lineTo( cx+p2.x, cy+p2.y );
    }

	function applyFill() :Bool {
		return applyFillGL();
	}
	
	function applyFillGL() :Bool {
		if( pen.fill==null ) return false;
		switch( pen.fill ) {
			case SolidColor(r,g,b,a):
				GL.color4(r,g,b,a);
			default:
				GL.color4(0,0,0,1);
		}
		return true;
	}

	function applyStroke() :Bool {
		if( pen.stroke==null ) return false;
		switch( pen.stroke ) {
			case SolidColor(r,g,b,a):
				GL.color4(r,g,b,a);
			default:
				GL.color4(0,0,0,1);
		}
		GL.lineWidth( pen.width );
		return true;
	}

    // erno.ObjectModelRenderer API
    
    override public function createPrimitive(id:Int) :Primitive {
        return new GLObject(id);
    }

    override public function destroyPrimitive( p:Primitive ) :Void {
		p.destroy();
    }

    override public function attachPrimitive( parent:Primitive, child:Primitive ) :Void {
        if( parent==null ) return;
        parent.addChild(child);
    }
    
    override public function clearPrimitive( p:Primitive ) :Void {
        p.clear();
    }
    
    override public function setPrimitiveTransform( p:Primitive, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
        var m:Matrix = new Matrix();
        m.a=a; m.b=b; m.tx=x;
        m.c=c; m.d=d; m.ty=y;
        p.setTransform( m );
    }

    override public function setPrimitiveTranslation( p:Primitive, x:Float, y:Float ) :Void {
        var m:Matrix = new Matrix().setIdentity().setTranslation(x,y);
        p.setTransform( m );
    }


   // erno.Renderer API

    override public function startNative( o:NativeContainer ) :Void {
        super.startNative(o);
        o.start();
    }
    
    override public function endNative() :Void {
        current.end();
        super.endNative();
    }

    override public function native( o:NativeObject ) {
        GL.callList( o );
    }
    
    override public function startObject( id:Int ) {
        super.startObject(id);
        current.start();
    }
    
    override public function endObject() {
        current.end();
        super.endObject();
    }
    
    override public function showObject( id:Int ) {
        super.showObject(id);
        GL.callList( id );
    }

    override public function clipRect( w:Float, h:Float ) {
    /*
        uh, man..
        this is another attempt at using scissors.
        the whole transformChanged() shebang in xinf.ul is *primarily* for this reason
        (might be useful for others too though... tap)
        
        var p0 = current.localToGlobal( {x:0.,y:0.} );
        var p1 = current.localToGlobal( {x:w,y:h} );
        var viewport = opengl.Helper.getFloats( GL.VIEWPORT, 4 );
        
        p0.y -= viewport[3];
        trace("cliprect "+w+","+h+", viewport h "+viewport[3]+" -> global "+p0+", "+p1 );
        GL.scissor( , Math.round(p0.y), 
                    Math.round(p1.x-p0.x), Math.round(p1.y-p0.y) );
        GL.enable( GL.SCISSOR_TEST );
    */
        var eq:Dynamic = CPtr.double_alloc(4);
        CPtr.double_set(eq,0,1.);
        CPtr.double_set(eq,1,0.);
        CPtr.double_set(eq,2,0.);
        CPtr.double_set(eq,3,0.);
        GL.clipPlane( GL.CLIP_PLANE0, eq );
        GL.enable( GL.CLIP_PLANE0 );

        CPtr.double_set(eq,0,0.);
        CPtr.double_set(eq,1,1.);
        GL.clipPlane( GL.CLIP_PLANE1, eq );
        GL.enable( GL.CLIP_PLANE1 );

        CPtr.double_set(eq,0,-1.);
        CPtr.double_set(eq,1,0.);
        CPtr.double_set(eq,3,w);
        GL.clipPlane( GL.CLIP_PLANE2, eq );
        GL.enable( GL.CLIP_PLANE2 );

        CPtr.double_set(eq,0,0.);
        CPtr.double_set(eq,1,-1.);
        CPtr.double_set(eq,3,h);
        GL.clipPlane( GL.CLIP_PLANE3, eq );
        GL.enable( GL.CLIP_PLANE3 );
    }
    
    override public function rect( x:Float, y:Float, w:Float, h:Float ) {
        current.mergeBBox( {l:x,t:y,r:x+w,b:y+h} );
        
        if( pen.fill != null ) {
			applyFill();
            GL.rect( x, y, x+w, y+h );
        }
        if( pen.stroke != null && pen.width > 0 ) {
			applyStroke();
            GL.begin( GL.LINE_STRIP );
                GL.vertex3( x, y, 0. );
                GL.vertex3( x+w, y, 0. );
                GL.vertex3( x+w, y+h, 0. );
                GL.vertex3( x, y+h, 0. );
                GL.vertex3( x, y, 0. );
            GL.end();
        }
    }

    override public function roundedRect( x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float ) {
        current.mergeBBox( {l:x,t:y,r:x+w,b:y+h} );
		
        startShape();
        
        if( rx==0 || ry==0 ) {
            throw("rounded rectangle needs radii > 0");
        }
        
        startPath( x+rx, y );
        for( i in 0...ELLIPSE_SEGMENTS ) {
            lineTo(x + w - rx, y);
            arcTo(x+w-rx,y,rx, ry, 0, false, true, x + w, y + ry);
            lineTo(x + w, y + h - ry);
            arcTo(x+w,y+h-ry,rx, ry, 0, false, true, x + w - rx, y + h);
            lineTo(x + rx, y + h);
            arcTo(x+rx,y+h,rx, ry, 0, false, true, x, y + h - ry);
            lineTo(x, y + ry);
            arcTo(x,y+ry,rx, ry, 0, false, true, x + rx, y); 
        }
        endPath();
        endShape();
    }

    override public function ellipse( x:Float, y:Float, rx:Float, ry:Float ) {
        startShape();
        startPath( x+rx, y );
        for( i in 0...ELLIPSE_SEGMENTS ) {
            ellipseSegment( x, y, rx, ry, 0, ELLIPSE_ANGLE*i, ELLIPSE_ANGLE );
        }
        endPath();
        endShape();
    }
 
    override public function text( x:Float, y:Float, text:String, format:TextFormat ) {
        format.assureLoaded();
        var font = format.font;
        if( font==null ) trace("NULL font");
        if( pen.fill != null && font != null ) {
            GL.pushMatrix();
                GL.translate( Math.floor(x), Math.floor(y), 0 );
                applyFillGL();
				GL.enable(GL.BLEND);
				font.renderText( text, format.size );
				GL.disable(GL.BLEND);
                
            GL.popMatrix();
        }
    }
    
    override public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
        if( img.theight==0 || img.twidth==0 ) return;
        current.mergeBBox( {l:outRegion.x,t:outRegion.y,r:outRegion.x+outRegion.w,b:outRegion.y+outRegion.h} );
    
        var tx1:Float = (inRegion.x/img.twidth);
        var ty1:Float = (inRegion.y/img.theight);
        var tx2:Float = tx1 + (inRegion.w/img.twidth);
        var ty2:Float = ty1 + (inRegion.h/img.theight);
        var x:Float = outRegion.x;
        var y:Float = outRegion.y;
        var x2:Float = outRegion.w+x;
        var y2:Float = outRegion.h+y;

//		applyFill();
		GL.color4(1,1,1,1);

        GL.pushAttrib( GL.ENABLE_BIT );
            GL.enable( GL.TEXTURE_2D );
			GL.enable( GL.BLEND );
			
			GL.bindTexture( GL.TEXTURE_2D, img.texture );
            
            GL.begin( GL.QUADS );
                GL.texCoord2( tx1, ty1 );
                GL.vertex2  (   x,   y ); 
                GL.texCoord2( tx2, ty1 );
                GL.vertex2  (  x2,   y ); 
                GL.texCoord2( tx2, ty2 );
                GL.vertex2  (  x2,  y2 ); 
                GL.texCoord2( tx1, ty2 );
                GL.vertex2  (   x,  y2 ); 
            GL.end();
            
        GL.popAttrib();
    }
    
    /* helper functions */
        
    public static function matrixForGL( m:Matrix ) :Dynamic {
        var v = CPtr.float_alloc(16);
        
        CPtr.float_set(v,0,m.a);
        CPtr.float_set(v,1,m.b);
        CPtr.float_set(v,2,.0);
        CPtr.float_set(v,3,.0);

        CPtr.float_set(v,4,m.c);
        CPtr.float_set(v,5,m.d);
        CPtr.float_set(v,6,.0);
        CPtr.float_set(v,7,.0);

        CPtr.float_set(v,8,.0);
        CPtr.float_set(v,9,.0);
        CPtr.float_set(v,10,1.);
        CPtr.float_set(v,11,.0);

        CPtr.float_set(v,12,m.tx);
        CPtr.float_set(v,13,m.ty);
        CPtr.float_set(v,14,.0);
        CPtr.float_set(v,15,1.);
        
        return v;
    }
    
}
