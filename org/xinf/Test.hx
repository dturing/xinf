package org.xinf;

import org.xinf.style.Style;
import org.xinf.style.StyleSheet;
import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.ony.Pane;
import org.xinf.ony.layout.BoxLayout;
import org.xinf.value.Value;
import org.xinf.value.Expression;

class Foo extends org.xinf.ony.Text {

    public function new( name:String ) {
        super( name );
        text = "Hello, World.";
        
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
        
        trace( this.style );
    }
    public function onMouseUp( e:Event ) :Void {
        removeStyleClass("push");
    }
    
    public function handleEvent( e:Event ) : Void {
        //trace("Event on "+this+": "+e.type );
        
        var t:String = name+"\n"+e.type+"\n";
        for( cl in this.getStyleClasses() ) {
            t += cl+" ";
        }
        text = t;
    }
    
}

class Test {
    static var container:org.xinf.ony.Element;
    static var x:Int;
    
    static function onEnterFrame( e:Event ) : Void {
        container.style.x = x = (x+2)%204;
        container.styleChanged();
    }
    static function main() {
        trace("Hello");
        x=0;

        var style = StyleSheet.newFromString("
            .Foo {
                background: #aaa;
                padding: 5px;
            }

            .hover {
                background: #faa; 
            }
            
            .push {
                background: #fcc;
                color: black;
            }
            
            .Image {
                width: 320px;
                height: 240px;
            }
            
            .Pane {
                background: #aaa;
            }
            
            #root {
                width: 320px;
                height: 240px;
                border: none;
            }
            
            .BoxLayout {
                x: 50;
                y: 50;
                border: 1px solid #00f;
                background: #ddd;
                padding: 0;
                margin: 2px;
            }

            .Foo {
                margin: 2px;
                border: 1px solid #000;
            }
        ");
//        trace("StyleSheet: " + style );
        
        org.xinf.style.StyledObject.globalStyle.append( style );

//        EventDispatcher.addGlobalEventListener( Event.ENTER_FRAME, Test.onEnterFrame );

/*
        var i = new org.xinf.ony.Image("test.png");
        i.style.x = i.style.y = 10;
*/

        var cont = new Pane("container");
        container = cont;
        org.xinf.ony.Root.getRoot().addChild(cont);

        var first = new Foo("box-1");
        var last = first;
            first.style.x = new Identity( new Value<Float>(1) );
        
            for( i in 0...5 ) {
                var box = new Foo("box"+i);
                box.style.x = new Add( 
                        last.style.x, last.style.width
                        );
                        
                box.style.y = new Value<Float>( i*20 );
                cont.addChild(box);
                last = box;
            }
            
            trace("--------------_");

/*
        for( j in 0...5 ) {
            var c = new BoxLayout("row"+j,HORIZONTAL);
            cont.addChild(c);

            for( i in 0...5 ) {
                var box = new Foo("box"+j+"/"+i);
                box.style.width = box.style.height = 100;
                c.addChild(box);
            }
        }
*/
        
        #if neko
             org.xinf.inity.Root.root.run();
        #end
    }
}
