/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischerenderer.
 
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
import xinf.geom.Matrix;
import xinf.erno.TextFormat;
import xinf.erno.ImageData;
import xinf.inity.GLRenderer;

import opengl.GL;
import opengl.GLU;

/**
    GL Debugging renderer. Checks for GLErrors after every xinferno instruction.
**/
class GLDebugRenderer implements Renderer {
    
    var renderer:GLRenderer;
    
    public function new() :Void {
        renderer = new GLRenderer();
    }

    function checkErrors( inst:String, ?args:Array<Dynamic> ) :Void {
        trace(""+inst+" "+args );
        var e:Int = GL.getError();
        if( e > 0 ) {
            throw( "OpenGL Error on "+inst+" "+args+": "+GLU.errorString(e) );
        }
    }
    
    // erno Instruction protocol
    
    public function startNative( o:NativeContainer ) :Void {
        renderer.startNative(o);
        checkErrors("startNative",[o]);
    }
    
    public function endNative() :Void {
        renderer.endNative();
        checkErrors("endNative");
    }
    
    public function startObject( id:Int ) {
        renderer.startObject(id);
        checkErrors("startObject",[id]);
    }
    
    public function endObject() {
        renderer.endObject();
        checkErrors("endObject");
    }
    
    public function showObject( id:Int ) {
        renderer.showObject(id);
        checkErrors("showObject",[id]);
    }

    public function setTransform( id:Int, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
        renderer.setTransform(id,x,y,a,b,c,d);
        checkErrors("setTransform",[id,x,y,a,b,c,d]);
    }
    
    public function setTranslation( id:Int, x:Float, y:Float ) :Void {
        renderer.setTranslation(id,x,y);
        checkErrors("setTranslation",[id,x,y]);
    }
    
    public function clipRect( w:Float, h:Float ) {
        renderer.clipRect(w,h);
        checkErrors("clipRect",[w,h]);
    }

    public function setFill( r:Float, g:Float, b:Float, a:Float ) {
        renderer.setFill(r,g,b,a);
        checkErrors("setFill",[r,g,b,a]);
    }
    
    public function setStroke( r:Float, g:Float, b:Float, a:Float, width:Float ) {
        renderer.setStroke(r,g,b,a,width);
        checkErrors("setStroke",[r,g,b,a,width]);
    }
    
    public function setFont( face:String, italic:Bool, bold:Bool, size:Float ) {
        renderer.setFont(face,italic,bold,size);
        checkErrors("setFont",[face,italic,bold,size]);
    }

    public function startShape() {
        renderer.startShape();
        checkErrors("startShape");
    }
    
    public function endShape() {
        renderer.endShape();
        checkErrors("endShape");
    }
    
    public function startPath( x:Float, y:Float) {
        renderer.startPath(x,y);
        checkErrors("startPath",[x,y]);
    }
    
    public function endPath() {
        renderer.endPath();
        checkErrors("endPath");
    }
    
    public function close() {
        renderer.close();
        checkErrors("close");
    }
    
    public function lineTo( x:Float, y:Float ) {
        renderer.lineTo(x,y);
        checkErrors("lineTo",[x,y]);
    }
    
    public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) {
        renderer.quadraticTo(x1,y1,x,y);
        checkErrors("quadraticTo",[x1,y1,x,y]);
    }
    
    public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) {
        renderer.cubicTo(x1,y1,x2,y2,x,y);
        checkErrors("cubicTo",[x1,y1,x2,y2,x,y]);
    }

    public function rect( x:Float, y:Float, w:Float, h:Float ) {
        renderer.rect(x,y,w,h);
        checkErrors("rect",[x,y,w,h]);
    }
    
    public function circle( x:Float, y:Float, r:Float ) {
        renderer.circle(x,y,r);
        checkErrors("circle",[x,y,r]);
    }
    
    public function text( x:Float, y:Float, text:String, format:TextFormat ) {
        renderer.text(x,y,text,format);
        checkErrors("text",[x,y,text,format]);
    }
    
    public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) {
        renderer.image(img,inRegion,outRegion);
        checkErrors("image",[inRegion,outRegion]);
    }
    
    public function native( o:NativeObject ) {
        renderer.native(o);
        checkErrors("native",[o]);
    }
    
}
