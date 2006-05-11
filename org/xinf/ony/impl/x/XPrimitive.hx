package org.xinf.ony.impl.x;

import org.xinf.inity.Object;

class XPrimitive implements org.xinf.ony.impl.IPrimitive {
    private var _e : Object;

    public function new( e:Object ) :Void {
        _e = e;
        org.xinf.inity.Root.root.addChild( _e );
    }
    
    public function setOwner( owner:org.xinf.event.EventDispatcher ) :Void {
        _e.owner = owner;
    }

    public function applyStyle( style:org.xinf.style.Style ) :Void {
        _e.style = style;
        _e.changed();
    }

    public function eventRegistered( type:String ) :Void {
    }
}
