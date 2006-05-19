package org.xinf.value;

import org.xinf.event.Event;
import org.xinf.value.Value;

// for setting o.p whenever v changes.
class ValueMonitor {
    var v:ValueBase; // value
    var f:Dynamic;    // function to call on value (or null)
    var o:Dynamic;   // object
    var p:String;    // property
    
    public function new( _v:ValueBase, _f:Dynamic, _o:Dynamic, _p:String ) {
        v=_v; f=_f; o=_o; p=_p;
        v.addEventListener( Event.CHANGED, changed );
    }
    
    public function changed( e:Event ) {
        var _v:Dynamic = v.get();
        if( f!=null ) _v = Reflect.callMethod( _v, f, [] );
        Reflect.setField( o, p, _v );
    }
}
