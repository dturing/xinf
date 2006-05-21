package org.xinf;

import org.xinf.style.Style;
import org.xinf.style.StyleSheet;
import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.ony.Pane;
import org.xinf.value.Value;
import org.xinf.value.Expression;

class Foo extends org.xinf.ony.Pane {
    private var postfix:String;

    public function new( name:String ) {
        super( name );
       // text = "Hello, World.";
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
        addStyleClass("hover");
    }
    public function onMouseOut( e:Event ) :Void {
        removeStyleClass("hover");
    }
    public function onMouseDown( e:Event ) :Void {
        addStyleClass("push");
        postfix = "\nPUSH HARDER!";
    }
    public function onMouseUp( e:Event ) :Void {
        removeStyleClass("push");
        postfix = "";
    }
    
    public function handleEvent( e:Event ) : Void {
        //trace("Event on "+this+": "+e.type );
        
        var t:String = name+"\n"+e.type+"\n";
        for( cl in this.getStyleClasses() ) {
            t += cl+" ";
        }
     //   text = t+postfix;
        
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

        var style = StyleSheet.newFromString(Std.resource("rootCss"));
        org.xinf.style.StyledObject.globalStyle.append( style );

        org.xinf.ony.Root.getRoot();

        var cont = new Pane("container");
        container = cont;
        org.xinf.ony.Root.getRoot().addChild(cont);


        var first = new Foo("box_");
        cont.addChild( first );
        var last = first;
            first.bounds.y = 10;
            first.bounds.x = 10;
            
            for( i in 0...5 ) {
                var box = new Foo("box"+i);
                    
                box.bounds._y.setLink( new Add( 
                        last.bounds._y, last.bounds._height
                        ) );
                       
                box.bounds._x.setLink( new Add( 
                        last.bounds._x, last.bounds._width
                        ) );
                       
                cont.addChild(box);
                last = box;
            }
            
            
        org.xinf.ony.Root.getRoot().run();
    }
}
