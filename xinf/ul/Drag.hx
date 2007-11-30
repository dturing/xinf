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

package xinf.ul;

import Xinf;

class Drag<T> {
    
    private var _mouseMove:Dynamic;
    private var _mouseUp:Dynamic;
    
    private var end:Void->Void;
    private var move:Float->Float->T->Void;
    private var marker:T;
    
    private var offset:{ x:Float, y:Float };
    
    public function new( e:MouseEvent, ?move:Float->Float->T->Void, ?end:Void->Void, ?marker:T ) :Void {
        offset = { x:1.*e.x, y:1.*e.y };
        this.end=end;
        this.move=move;
        this.marker=marker;
        
        _mouseMove  = Root.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
        _mouseUp    = Root.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
    }
    
    private function onMouseMove( e:MouseEvent ) {
        if( move != null ) move( e.x-offset.x, e.y-offset.y, marker );
    }
    
    private function onMouseUp( e:MouseEvent ) {
        Root.removeEventListener( MouseEvent.MOUSE_MOVE, _mouseMove );
        Root.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
        if( end != null ) end();
    }
    
}
