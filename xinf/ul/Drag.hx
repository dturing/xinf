/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
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
