package org.xinf.ony.impl.x;

import org.xinf.inity.Group;
import org.xinf.ony.impl.IPrimitive;
import org.xinf.event.Event;

class XPrimitive implements org.xinf.ony.impl.IPrimitive {
    private var _e : Group;

    public function new( e:Group ) :Void {
        _e = e;
//        org.xinf.inity.Root.root.addChild( _e );
        _e.changed(); // FIXME this is done too often, in XImage ctor too eg.
    }
    
    public function setOwner( owner:org.xinf.event.EventDispatcher ) :Void {
        _e.owner = owner;
    }

    public function addChild( child:IPrimitive ) :Void {
        var p:XPrimitive = cast(child,XPrimitive);
        _e.addChild( p._e );
        _e.changed();
    }
    
    public function removeChild( child:IPrimitive ) :Void {
        var p:XPrimitive = cast(child,XPrimitive);
//        _e.removeChild( p._e );
        _e.changed();
    }

    public function setBounds( bounds:org.xinf.ony.Bounds ) :Void {
        _e.bounds = bounds;
        // FIXME: if we separate painting/translation into differend displaylists, movement could be very lightweight!
        bounds.addEventListener("positionChanged", redraw );
        bounds.addEventListener("sizeChanged", redraw );
        _e.changed();
    }
    
    public function redraw( e:Event ) :Void {
        _e.changed();
    }

    public function eventRegistered( type:String ) :Void {
    }

    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + ">" );
    }
}
