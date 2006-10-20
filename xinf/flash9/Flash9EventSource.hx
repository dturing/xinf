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

import xinf.event.EventKind;
import xinf.event.MouseEvent;
import xinf.event.ScrollEvent;
import xinf.event.KeyboardEvent;
import xinf.event.GeometryEvent;
import xinf.event.FrameEvent;

class Flash9EventSource {
	private var runtime:Flash9Runtime;
	private var frame:Int;
	
	public function new( r:Flash9Runtime ) :Void {
		runtime = r;
		frame = 0;
		
		var stage = flash.Lib.current.stage;
        stage.addEventListener( flash.events.MouseEvent.MOUSE_DOWN, mouseDown );
        stage.addEventListener( flash.events.MouseEvent.MOUSE_UP, mouseUp );
        stage.addEventListener( flash.events.MouseEvent.MOUSE_MOVE, mouseMove );
		
        flash.Lib.current.addEventListener( flash.events.Event.ENTER_FRAME, enterFrame );
	}

    private function mouseDown( e:flash.events.MouseEvent ) :Void {
        return postMouseEvent( e, MouseEvent.MOUSE_DOWN );
    }
    private function mouseUp( e:flash.events.MouseEvent ) :Void {
        return postMouseEvent( e, MouseEvent.MOUSE_UP );
    }
    private function mouseMove( e:flash.events.MouseEvent ) :Void {
        return postMouseEvent( e, MouseEvent.MOUSE_MOVE );
    }
	
	private function enterFrame( e:flash.events.Event ) :Void {
		runtime.postEvent( new FrameEvent( FrameEvent.ENTER_FRAME, frame++ ) );
	}
	
	private function findTarget( e:flash.events.Event ) :Int {
		var s:Dynamic = e.target;
		var t:XinfSprite = cast s;
		while( t==null ) {
			s = s.parent;
			if( s==null ) return 0;
			t = cast s;
		}
		return t.xinfId;
	}
	
    private function postMouseEvent( e:flash.events.MouseEvent, type:EventKind<MouseEvent> ) :Void {
        var targetId:Int = findTarget(e);
		postMouseEventTo( e, type, targetId );
	}
	
    private function postMouseEventTo( e:flash.events.MouseEvent, type:EventKind<MouseEvent>, targetId:Int ) :Void {
		runtime.postEvent( new MouseEvent( type, Math.round(e.stageX), Math.round(e.stageY), 0, targetId ) );
		e.stopPropagation();
    }

	public function rootResized() :Void {
		var w = flash.Lib.current.stage.stageWidth;
		var h = flash.Lib.current.stage.stageHeight;
		runtime.postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, w, h ) );
		trace("root resize "+w+"/"+h);
	}
}
