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
import xinf.ony.Native;
import xinf.erno.Renderer;
import xinf.erno.Runtime;

#if neko
import opengl.GL;
import opengl.GLU;
import opengl.GLUT;
#end

class App extends Application {
    private static var block:Native;

    public function new() :Void {
        super();
        
        var p:NativeObject = null;
        
        #if flash
            var s = new flash.display.Sprite();
            s.graphics.beginFill( 0xff0000, 1 );
            s.graphics.moveTo( 10, 10 );
            s.graphics.lineTo( 100, 10 );
            s.graphics.lineTo( 10, 100 );
            s.graphics.endFill();
            p=s;
        #else js
            var div = js.Lib.document.createElement("div");
            div.innerHTML="this is <b onmousedown=\"this.innerHTML = 'clicked'\">native</b> html";
            p=div;
        #else neko
            p=Runtime.runtime.getNextId();
            
            GL.newList( p, GL.COMPILE );
            GL.rotate( 12., 1., 2., 3. );
            GL.rect( 0, 0, 20, 20 );
            GL.endList();
        #end

        block = new Native(p);
        block.moveTo( 100, 100 );
        root.attach( block );
    }

    public static function main() :Void {
        new App().run();
    }
}
