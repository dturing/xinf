/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;

class Drag<T> {
	
	private var _mouseMove:Dynamic;
	private var _mouseUp:Dynamic;
	private var _frame:Dynamic;
	
	private var end:Void->Void;
	private var move:Float->Float->T->Void;
	private var marker:T;
	private var moved:MouseEvent;
	private var last:MouseEvent;
	
	private var offset:{ x:Float, y:Float };
	
	public function new( e:MouseEvent, ?move:Float->Float->T->Void, ?end:Void->Void, ?marker:T ) :Void {
		offset = { x:1.*e.x, y:1.*e.y };
		this.end=end;
		this.move=move;
		this.marker=marker;
		this.moved=null;
		this.last=null;
		
		_mouseMove  = Root.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		_mouseUp	= Root.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		_frame		= Root.addEventListener( FrameEvent.ENTER_FRAME, onEnterFrame );
	}
	
	private function onMouseMove( e:MouseEvent ) {
		if( last!=null && last.x==e.x && last.y==e.y ) return;
		moved = e;
	}

	private function onEnterFrame( e:FrameEvent ) {
		if( move != null && moved != null )
			move( moved.x-offset.x, moved.y-offset.y, marker );
		last=moved;
	}
	
	private function onMouseUp( e:MouseEvent ) {
		Root.removeEventListener( MouseEvent.MOUSE_MOVE, _mouseMove );
		Root.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
		Root.removeEventListener( FrameEvent.ENTER_FRAME, _frame );
		if( end != null ) end();
	}
	
}

class HighFrequencyDrag<T> {
	
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
		_mouseUp	= Root.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
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
