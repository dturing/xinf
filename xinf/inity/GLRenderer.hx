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

package xinf.inity;

import xinf.erno.Renderer;
import xinf.erno.ObjectModelRenderer;
import xinf.geom.Matrix;
import xinf.erno.ImageData;
import xinf.erno.TextFormat;

import opengl.GL;
import opengl.GLU;
import cptr.CPtr;


typedef Primitive = GLObject

class GLRenderer extends ObjectModelRenderer<Primitive> {
    
    private var shape:GLPolygon;
    
    private var circle_fill:Int;
    private var circle_stroke:Int;

    public function new() :Void {
        super();
        
        // FIXME: somewhat stupid initialization of "circle primitive"
        var fy = 1; //3./4.;
        
        circle_fill = GL.genLists(1);
        GL.newList( circle_fill, GL.COMPILE );
        GL.begin( GL.POLYGON );
            var n = 50;
            var f = (Math.PI*2)/n;
            for( i in 0...(n+1) ) {
                GL.vertex3( Math.sin(f*i), Math.cos(f*i)*fy, 0. );
            }
        GL.end();
        GL.endList();

        circle_stroke = GL.genLists(1);
        GL.newList( circle_stroke, GL.COMPILE );
        GL.begin( GL.LINE_STRIP );
            var n = 50;
            var f = (Math.PI*2)/n;
            for( i in 0...(n+1) ) {
                GL.vertex3( Math.sin(f*i), Math.cos(f*i)*fy, 0. );
            }
        GL.end();
        GL.endList();

    }
    
    // erno.ObjectModelRenderer API
    override public function createPrimitive(id:Int) :Primitive {
        return new GLObject(id);
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
        pushPen();
        current.start();
    }
    
    override public function endObject() {
        current.end();
        popPen();
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
    
    override public function startShape() {
        if( shape != null ) throw("Can only define one path at a time");
        shape = new GLPolygon();
    }
    
    override public function endShape() {
        if( shape==null ) throw("no current Polygon");
        shape.draw( pen.fillColor, pen.strokeColor, pen.strokeWidth );
        shape = null;
    }
    
    override public function startPath( x:Float, y:Float) {
        if( shape==null ) throw("no current Polygon");
        shape.startPath( x, y );
    }
    
    override public function endPath() {
        shape.endPath();
    }
    
    override public function close() {
        shape.close();
    }
    
    override public function lineTo( x:Float, y:Float ) {
        shape.lineTo(x,y);
    }
    
    override public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
        shape.quadraticTo(x1,y1,x,y);
    }
    
    override public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
        shape.cubicTo(x1,y1,x2,y2,x,y);
    }
    
    override public function rect( x:Float, y:Float, w:Float, h:Float ) {
        current.mergeBBox( {l:x,t:y,r:x+w,b:y+h} );
        
        if( pen.fillColor != null ) {
            GL.color4( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
            GL.rect( x, y, x+w, y+h );
        }
        if( pen.strokeColor != null && pen.strokeWidth > 0 ) {
            GL.color4( pen.strokeColor.r, pen.strokeColor.g, pen.strokeColor.b, pen.strokeColor.a );
            GL.lineWidth( pen.strokeWidth );
            /* FIXME pixelSize issue
            x+=pen.strokeWidth/2;
            y+=pen.strokeWidth/2;
            if( pen.strokeWidth>1 ) {
                w-=pen.strokeWidth/2;
                h-=pen.strokeWidth/2;
            }
            */
            GL.begin( GL.LINE_STRIP );
                GL.vertex3( x, y, 0. );
                GL.vertex3( x+w, y, 0. );
                GL.vertex3( x+w, y+h, 0. );
                GL.vertex3( x, y+h, 0. );
                GL.vertex3( x, y, 0. );
            GL.end();
            /*
            GL.pointSize( pen.strokeWidth );
            GL.begin( GL.POINTS );
                GL.vertex3( x, y, 0. );
                GL.vertex3( x+w, y, 0. );
                GL.vertex3( x+w, y+h, 0. );
                GL.vertex3( x, y+h, 0. );
                GL.vertex3( x, y, 0. );
            GL.end();
            */
        }
    }
    
    override public function circle( x:Float, y:Float, r:Float ) {
        GL.pushMatrix();
        GL.translate( x, y, 0. );
        GL.scale( r, r, 1.);
        
        if( pen.fillColor != null ) {
            GL.color4( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
            GL.callList(circle_fill);
        }
        if( pen.strokeColor != null && pen.strokeWidth > 0 ) {
            GL.color4( pen.strokeColor.r, pen.strokeColor.g, pen.strokeColor.b, pen.strokeColor.a );
            GL.lineWidth( pen.strokeWidth );
            GL.callList(circle_stroke);
        }
        GL.popMatrix();
    }
    
    override public function text( x:Float, y:Float, text:String, format:TextFormat ) {
        format.assureLoaded();
        var font = format.font;
        if( font==null ) trace("NULL font");
        if( pen.fillColor != null && font != null ) {
            GL.pushMatrix();
                GL.translate( x, y, 0 );
                GL.color4( pen.fillColor.r, pen.fillColor.g, pen.fillColor.b, pen.fillColor.a );
                font.renderText( text, format.size, null );
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

        GL.color4( 1., 1., 1., 1. );

        GL.pushAttrib( GL.ENABLE_BIT );
            GL.enable( GL.TEXTURE_2D );
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
