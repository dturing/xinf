package org.xinf;

import org.xinf.style.Style;
import org.xinf.style.StyleSheet;
import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.ony.Pane;
import org.xinf.value.Value;
import org.xinf.value.Expression;

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
        addStyleClass("hover");
    }
    public function onMouseOut( e:Event ) :Void {
        removeStyleClass("hover");
    }
    public function onMouseDown( e:Event ) :Void {
        addStyleClass("push");
        postfix = "\nfoo";
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
    //    text = t+postfix;
        
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

        var style = StyleSheet.newFromString("
            #root {
                backgroundColor: #ddd;
            }

            .Foo {
                color: #f00;
                background-color: #aaa;
                alpha: .5;
                padding-left: 5;
                padding-top: 5;
                padding-right: 5;
                padding-bottom: 5;
                padding: 10;
            }
            
            .hover {
                background-color: #aaf;
                color: #000;
                padding-left: 50;
            }
            
            .push {
                background-color: #faa;
                color: #000;
                padding-right: 50;
                padding-left: 5;
            }
        ");
//        trace("StyleSheet: " + style );
        
        org.xinf.style.StyledObject.globalStyle.append( style );

//        EventDispatcher.addGlobalEventListener( Event.ENTER_FRAME, Test.onEnterFrame );


        var cont = new Pane("container");
        container = cont;
        org.xinf.ony.Root.getRoot().addChild(cont);

        var first = new Foo("box_");
        cont.addChild( first );
        var last = first;
            first.bounds.y = 10;
            first.bounds.x = 10;
            
            for( i in 0...10 ) {
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
            
        #if neko
             org.xinf.inity.Root.root.run();
        #end
    }
}
