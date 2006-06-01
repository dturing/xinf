package org.xinf;

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.ony.Pane;

class Foo extends org.xinf.ony.Text {
    private var postfix:String;

    public function new( name:String ) {
        super( name );
        text = "Hello, World.";
        postfix = "";
        
        addEventListener( Event.MOUSE_OVER, onMouseOver );
        addEventListener( Event.MOUSE_OUT, onMouseOut );
        addEventListener( Event.MOUSE_DOWN, onMouseDown );
        addEventListener( Event.MOUSE_UP, onMouseUp );
        
        for( event in [ Event.MOUSE_DOWN, Event.MOUSE_UP,
                        Event.MOUSE_OVER, Event.MOUSE_OUT ] ) {
            addEventListener( event, handleEvent );
        }
    }

    public function onMouseOver( e:Event ) :Void {
//        addStyleClass("hover");
    }
    public function onMouseOut( e:Event ) :Void {
//        removeStyleClass("hover");
    }
    public function onMouseDown( e:Event ) :Void {
//        addStyleClass("push");
        postfix = "\nPUSH HARDER!";
    }
    public function onMouseUp( e:Event ) :Void {
//        removeStyleClass("push");
        postfix = "";
    }
    
    public function handleEvent( e:Event ) : Void {
        //trace("Event on "+this+": "+e.type );
        
        var t:String = name+"\n"+e.type+"\n";
/*        for( cl in this.getStyleClasses() ) {
            t += cl+" ";
        }
 */       text = t+postfix;
        
    }
    
}

/**
    Informal xinf Test (used during development).
**/
class Test {
    static var container:org.xinf.ony.Element;
    static var x:Int;
    
    static function main() {
        trace("Hello");
        x=0;

        var root = org.xinf.ony.Root.getRoot();

        var cont = new Pane("container");
        container = cont;
        root.addChild(cont);

        var first = new Foo("box_");
        cont.addChild( first );
        var last = first;
            first.bounds.setPosition( 10, 10 );
            first.bounds.setSize( 100, 100 );    
            
            for( i in 0...5 ) {
                var box = new Foo("box"+i);
                box.bounds.setPosition( 10, last.bounds.y+last.bounds.height+2 );
                box.bounds.setSize( 100, 100 );
                
                cont.addChild(box);
                last = box;
            }
        
        trace("T: "+untyped first._p._width );    
        
        org.xinf.ony.Root.getRoot().run();
    }
}
