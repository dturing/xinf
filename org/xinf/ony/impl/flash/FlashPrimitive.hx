package org.xinf.ony.impl.flash;

import flash.MovieClip;
import org.xinf.style.Style;
import org.xinf.event.Event;
import org.xinf.ony.impl.IPrimitive;

class FlashPrimitive implements org.xinf.ony.impl.IPrimitive {
    private var _e : MovieClip;
    private var style : Style;
    
    public var width:Int;
    public var height:Int;

    private static var eventNames:Hash<String> = registerEventNames();
    private static function registerEventNames() : Hash<String> {
        var h:Hash<String> = new Hash<String>();
        h.set( Event.MOUSE_DOWN,"onPress");
        h.set( Event.MOUSE_UP,  "onRelease");
        h.set( Event.MOUSE_OVER,"onRollOver,onDragOver");
        h.set( Event.MOUSE_OUT, "onRollOut,onDragOut");
        return h;
    }

    // event wrappers: "this" is the runtime primitive.
    public function _mouseDown() {
        untyped this.owner.postEvent( Event.MOUSE_DOWN );
    }
    public function _mouseUp() {
        untyped this.owner.postEvent( Event.MOUSE_UP );
    }
    public function _mouseOver() {
        untyped this.owner.postEvent( Event.MOUSE_OVER );
    }
    public function _mouseOut() {
        untyped this.owner.postEvent( Event.MOUSE_OUT );
    }

    public function new() :Void {
        _e = flash.Lib._root.createEmptyMovieClip("FIXME",flash.Lib._root.getNextHighestDepth());
    }
    
    public function setOwner( owner:org.xinf.event.EventDispatcher ) :Void {
        untyped _e.owner = owner;
    }

    public function addChild( child:IPrimitive ) :Void {
        var p:FlashPrimitive = cast(child,FlashPrimitive);
            // FIXME
    }
    
    public function removeChild( child:IPrimitive ) :Void {
        var p:FlashPrimitive = cast(child,FlashPrimitive);
            // FIXME
    }

    public function setBounds( bounds:org.xinf.ony.Bounds ) :Void {
        bounds.addEventListener( "positionChanged", onPositionChanged );
        bounds.addEventListener( "sizeChanged", onSizeChanged );
    }
    
    public function onPositionChanged( e:Event ) {
        _e._x = e.data.x;
        _e._y = e.data.y;
    }
    
    public function onSizeChanged( e:Event ) {
        width = Math.round( e.data.width );
        height = Math.round( e.data.height );
        scheduleRedraw();
    }

    public function setStyle( _style:org.xinf.style.Style ) :Void {
        style = _style;
     //   scheduleRedraw();
    }

    public function eventRegistered( type:String ) :Void {
        var eventName:String = eventNames.get(type);
        if( eventName != null ) {
            for( name in eventName.split(",") ) {
                Reflect.setField( _e, name, Reflect.field( this, "_"+type ) );
            }
        }
    }
    
    public function scheduleRedraw() :Void {
        // FIXME: for now, just redraw. can save a lot to buffer these and process after events!
        redraw();
    }
    
    public function redraw() :Void {
    }
}
