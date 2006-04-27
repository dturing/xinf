package org.xinf.demo;

import org.xinf.display.Sprite;
import org.xinf.event.Event;
import org.xinf.event.MouseEvent;

class Square extends Sprite {

    private var size:Float;
    private var angle:Float;
    private var speed:Float;
    private var pressed:Bool;

    public function new( _name:String, _x:Float, _y:Float, _angle:Float ) {
        super();
        name = _name;
        x = _x;
        y = _y;
        angle=_angle;
        size=.8;
        
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, false );
        addEventListener( MouseEvent.MOUSE_UP, onMouseUp, false, 0, false );

        addEventListener( MouseEvent.MOUSE_OVER, onMouseOver, false, 0, false );
        addEventListener( MouseEvent.MOUSE_OUT, onMouseOut, false, 0, false );
        
        addEventListener( Event.ENTER_FRAME, onEnterFrame, false, 0, false );
        
        speed=0.0;
        pressed=false;
        
        draw( 0xffffff, .3 );
    }

    private function draw( c:Int, a:Float ) : Void {
        graphics.clear();
        graphics.beginFill( c, a );
        graphics.drawRect( -size/2, -size/2, size, size );
        graphics.endFill();
    }
    
    public function onEnterFrame( e:Event ) {
        rotation = (angle+=speed);

        if( pressed ) {
            speed += .5;
        } else speed *= 0.93;
        if( speed > 5 ) speed = 5;
        if( speed < 0.1 ) speed = 0.1;
    }
    
    public function onMouseDown( e:Event ) {
        trace( "MouseDown on "+this );
        pressed=true;
    }

    public function onMouseUp( e:Event ) {
        trace( "MouseUp on "+this );
        pressed=false;
    }

    public function onMouseOver( e:Event ) {
        draw( 0xffffff, .6 );
    }

    public function onMouseOut( e:Event ) {
        draw( 0xffffff, .3 );
    }

}
