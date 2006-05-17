package org.xinf;

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.value.Value;
import org.xinf.value.Expression;

import org.xinf.style.StyleChain;
import org.xinf.style.Style;
import org.xinf.style.Color;

class ValueTest {
    static function main() {
        trace("Hello");
        
        var chain = new Array<PropertySet>();
        
        var basic = new Style();
        basic.alpha = .5;
        basic.backgroundColor = Color.rgb(10,20,30);
        basic.paddingLeft = 10;
        chain.push( basic );
        
        var s = new StyleChain(null);
        s.setChain( chain );
        
        trace( "alpha: "+s.alpha );
        trace( "bg:    "+s.backgroundColor );
        

        var two = new Style();
        two.alpha = .9;
        chain.push( two );
        s.setChain( chain );

        trace( "alpha: "+s.alpha );

        trace( "padding-left: "+s.paddingLeft );
        
        #if neko
//            org.xinf.ony.Root.getRoot();
//            org.xinf.inity.Root.root.run();
        #end
    }
}
