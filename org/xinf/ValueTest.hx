package org.xinf;

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.value.Value;
import org.xinf.value.Expression;

class ValueTest {
    static function main() {
        trace("Hello");
        
        var x = new Value<Float>(1);
        
        var a = new Identity<Float>( x );
        var b = new Value<Float>(.5);
        
        var e = new Add(a,b);
        
        
        trace(e);
        trace("---");
        x.value = 12;
        trace("---");
        x.value = .23;
        
        #if neko
//            org.xinf.ony.Root.getRoot();
//            org.xinf.inity.Root.root.run();
        #end
    }
}
