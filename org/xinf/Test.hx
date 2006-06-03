package org.xinf;

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.ony.Pane;

class Foo extends org.xinf.ony.Text {
    public function new( name:String ) {
        super( name );
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

        var cont = new Pane("container");
        cont.bounds.setPosition( 50, 50 );
        cont.bounds.setSize( 20, 20 );
        container = cont;
        root.addChild(cont);
/*
    var pane = new org.xinf.ony.Pane("pane");
    cont.addChild(pane);
    pane.bounds.setSize( 200, 200 );
*/   

        var first = new Foo("box_");
        cont.addChild( first );
        
        var last = first;
        
        first.bounds.setPosition( 10, 10 );
//        first.bounds.setSize( 100, 100 );    
/*            
            for( i in 0...5 ) {
                var box = new Foo("box"+i);
                box.bounds.setPosition( 10, i*50 ); //last.bounds.y+last.bounds.height+2 );
                box.bounds.setSize( 100, 100 );
                
                cont.addChild(box);
                last = box;
            }
*/                
        org.xinf.ony.Root.getRoot().run();
    }
}
