package org.xinf.demo;

import org.xinf.display.Sprite;
import org.xinf.event.Event;
import org.xinf.event.MouseEvent;

class Square extends Sprite {

    private var angle:Float;
    private var speed:Float;
    private var pressed:Bool;

    public function new( _name:String, _x:Float, _y:Float ) {
        super();
        name = _name;
        x = _x;
        y = _y;
        
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, false );
        addEventListener( MouseEvent.MOUSE_UP, onMouseUp, false, 0, false );
        addEventListener( Event.ENTER_FRAME, onEnterFrame, false, 0, false );
        
        angle=0.0;
        speed=0.0;
        pressed=false;
    }
    
    public function onEnterFrame( e:Event ) {
        rotation = Math.round(angle+=speed);
        
        if( pressed ) {
            speed += 1;
        } else speed *= 0.93;

    }
    
    public function onMouseDown( e:Event ) {
        trace( "MouseDown on "+this );
        pressed=true;
    }

    public function onMouseUp( e:Event ) {
        trace( "MouseUp on "+this );
        pressed=false;
    }

}
