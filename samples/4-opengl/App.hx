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

import xinf.ony.Application;
import xinf.erno.Renderer;
import xinf.erno.Runtime;

#if neko
import opengl.GL;
import opengl.GLU;
import opengl.GLUT;
#else err
#end

class Cube extends xinf.ony.Object {
    var step:Int;
    
    public function new() :Void {
        super();
        
        var self=this;
        Runtime.runtime.addEventListener( xinf.event.FrameEvent.ENTER_FRAME, function(e) {
                self.step = e.frame;
                self.scheduleRedraw();
            });
    }
    
    public function drawContents( g:Renderer ) :Void {
        GL.matrixMode( GL.PROJECTION );
        GL.pushMatrix();
        GL.loadIdentity();
        GLU.perspective( 45, 1., 1., 10000. );
        GL.matrixMode( GL.MODELVIEW );
        GLU.lookAt( 0,0,5, 0,0,0, 0,1,0 );
        
        GL.shadeModel( GL.SMOOTH );
        GL.scale( 1., 1., .01 );
        GL.rotate( step*5, Math.sin(step/10), Math.cos(step/10), 1. );
        
        GL.color4( 1,1,1,1 );
        GLUT.solidCube( 150. );
        GL.color4( 0,0,0,1 );
        GLUT.wireCube( 150. );

        GL.matrixMode( GL.PROJECTION );
        GL.popMatrix();
        GL.matrixMode( GL.MODELVIEW );
    }
}

class App extends Application {
    public function new() :Void {
        super();
        
        var cube = new Cube();
        cube.moveTo( 100, 100 );
        root.attach( cube );
    }

    public static function main() :Void {
        new App().run();
    }
}
