/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.flash9;

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
    private var currentOver:Null<Int>;
    
    public function new( r:Flash9Runtime ) :Void {
        runtime = r;
        frame = 0;
        currentOver = 0;
        
        var stage = flash.Lib.current.stage;
        stage.addEventListener( flash.events.MouseEvent.MOUSE_DOWN, mouseDown, false );
        stage.addEventListener( flash.events.MouseEvent.MOUSE_UP, mouseUp, false );
        stage.addEventListener( flash.events.MouseEvent.MOUSE_MOVE, mouseMove, false );
        stage.addEventListener( flash.events.MouseEvent.MOUSE_WHEEL, mouseWheel, false );

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
  //  trace("post Mouse "+type+", to "+targetId );
        runtime.postEvent( new MouseEvent( type, Math.round(e.stageX), Math.round(e.stageY), if(e.buttonDown) 1 else 0, targetId, e.shiftKey, e.altKey, e.ctrlKey ) );
        e.stopPropagation();
    }

    private function mouseDown( e:flash.events.MouseEvent ) :Void {
        return postMouseEvent( e, MouseEvent.MOUSE_DOWN );
    }
    
    private function mouseUp( e:flash.events.MouseEvent ) :Void {
        return postMouseEvent( e, MouseEvent.MOUSE_UP );
    }
    
    private function mouseMove( e:flash.events.MouseEvent ) :Void {
        var targetId:Int = findTarget(e);
        if( targetId != currentOver ) {
            if( currentOver!=null ) {
                postMouseEventTo( e, MouseEvent.MOUSE_OUT, currentOver );
            }
            postMouseEventTo( e, MouseEvent.MOUSE_OVER, targetId );
            currentOver = targetId;
        } else {
            postMouseEventTo( e, MouseEvent.MOUSE_MOVE, targetId );
        }
    }
    
    public function mouseWheel( e:flash.events.MouseEvent ) :Void {
        var targetId:Int = findTarget(e);
        runtime.postEvent( new ScrollEvent( ScrollEvent.SCROLL_STEP, -e.delta, targetId ) );
        e.stopPropagation();
    }

    private function postKeyboardEvent( e:flash.events.KeyboardEvent, type:EventKind<KeyboardEvent> ) :Void {
        var key:String = Keys.get(e.keyCode);
        if( e.keyCode != 0 ) {
            if( key == null ) {
				key = String.fromCharCode(e.charCode);
//                trace("unhandled key code "+e.keyCode );
//                return;
            }
            runtime.postEvent( new KeyboardEvent( 
                type, e.charCode, key,
                e.shiftKey, e.altKey, e.ctrlKey ) );
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
