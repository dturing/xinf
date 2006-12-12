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

import xinf.erno.Keys;

class Flash9EventSource {
	private var runtime:Flash9Runtime;
	private var frame:Int;
	
	public function new( r:Flash9Runtime ) :Void {
		runtime = r;
		frame = 0;
		
		var stage = flash.Lib.current.stage;
        stage.addEventListener( flash.events.MouseEvent.MOUSE_DOWN, mouseDown, false );
        stage.addEventListener( flash.events.MouseEvent.MOUSE_UP, mouseUp, false );
        stage.addEventListener( flash.events.MouseEvent.MOUSE_MOVE, mouseMove, false );

        stage.addEventListener( flash.events.KeyboardEvent.KEY_DOWN, keyDown, false );
        stage.addEventListener( flash.events.KeyboardEvent.KEY_UP, keyUp, false );

		// FIXME: maybe setup the stage in the renderer, or runtime, is a better place?
        stage.addEventListener( flash.events.Event.RESIZE, rootResized );
		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.align = flash.display.StageAlign.TOP_LEFT;

        flash.Lib.current.addEventListener( flash.events.Event.ENTER_FRAME, enterFrame );
	}

	private function findTarget( e:flash.events.Event ) :Int {
		var s:Dynamic = e.target;
		while( !Std.is(s,XinfSprite) ) {
			s = s.parent;
			if( s==null ) return 0;
		}
		var t:XinfSprite = cast(s,XinfSprite);
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

	private function mouseDown( e:flash.events.MouseEvent ) :Void {
        return postMouseEvent( e, MouseEvent.MOUSE_DOWN );
    }
    private function mouseUp( e:flash.events.MouseEvent ) :Void {
        return postMouseEvent( e, MouseEvent.MOUSE_UP );
    }
    private function mouseMove( e:flash.events.MouseEvent ) :Void {
        return postMouseEvent( e, MouseEvent.MOUSE_MOVE );
    }

    private function postKeyboardEvent( e:flash.events.KeyboardEvent, type:EventKind<KeyboardEvent> ) :Void {
		var key:String = Keys.get(e.keyCode);
		if( e.keyCode != 0 ) {
			if( key == null ) {
				trace("unhandled key code "+e.keyCode );
				return;
			}
			runtime.postEvent( new KeyboardEvent( 
				type, e.keyCode, key,
				untyped e.shiftKey, untyped e.altKey, untyped e.ctrlKey ) );
			// prevent browser from handling it
			e.stopPropagation();
		}
    }
	private function keyDown( e:flash.events.KeyboardEvent ) :Void {
        return postKeyboardEvent( e, KeyboardEvent.KEY_DOWN );
    }
	private function keyUp( e:flash.events.KeyboardEvent ) :Void {
        return postKeyboardEvent( e, KeyboardEvent.KEY_UP );
    }

	private function enterFrame( e:flash.events.Event ) :Void {
		runtime.postEvent( new FrameEvent( FrameEvent.ENTER_FRAME, frame++ ) );
	}
	

	public function rootResized( ?e:Dynamic ) :Void {
		var w = flash.Lib.current.stage.stageWidth;
		var h = flash.Lib.current.stage.stageHeight;
		runtime.postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, w, h ) );
	}
}