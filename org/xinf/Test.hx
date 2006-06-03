package org.xinf;

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

class Foo extends org.xinf.ony.Text {
    public function new( name:String, parent:org.xinf.ony.Element ) {
        super( name, parent );
        text = "Hello, World.";
        
        for( event in [ Event.MOUSE_DOWN, Event.MOUSE_UP,
                        Event.MOUSE_OVER, Event.MOUSE_OUT ] ) {
            addEventListener( event, handleEvent );
        }
    }
    
    public function handleEvent( e:Event ) : Void {
//        trace("Event on "+this+": "+e.type );
        
        var t:String = name+"\n"+e.type+"\n";
        text = t;
    }
    
}

/**
    Informal xinf Test (used during development).
**/
class Test {
    static var container:org.xinf.ony.Element;
    static var x:Int;
    
    static function main() {
        x=0;

        var root = org.xinf.ony.Root.getRoot();

        var cont = new org.xinf.ony.Pane("container", root);
        cont.bounds.setPosition( 50, 50 );
        cont.bounds.setSize( 20, 20 );
        container = cont;
        
            for( i in 0...3 ) {
                var box = new Foo("box"+i, cont);
                box.bounds.setPosition( 10, i*50 ); //last.bounds.y+last.bounds.height+2 );
//                box.bounds.setSize( 100, 10 );
            }

        org.xinf.ony.Root.getRoot().run();
    }
}
