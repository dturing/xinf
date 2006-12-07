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

package xinf.inity.x11;

import xinf.event.MouseEvent;
import xinf.erno.Runtime;

class XForward extends XScreen {
    public function new( server:String, _screen:Int ) {
        super( server, _screen );

        if( !X.HaveTestExtension(display) ) {
            throw( "No XTest extension on display :"+server+"."+_screen );
        }
        
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
        Runtime.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
        Runtime.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
    }

    public function onMouseDown( e:MouseEvent ) :Void {
        X.TestFakeButtonEvent( display, 1, 1, X.CurrentTime );
    }
    public function onMouseUp( e:MouseEvent ) :Void {
        X.TestFakeButtonEvent( display, 1, 0, X.CurrentTime );
    }
    public function onMouseMove( e:MouseEvent ) :Void {
		var p = globalToLocal( {x:e.x, y:e.y} );
        X.TestFakeMotionEvent( display, screen, 
                Math.round(p.x), Math.round(p.y), X.CurrentTime );
    }
}
