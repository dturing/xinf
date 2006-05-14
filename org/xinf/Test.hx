package org.xinf;

import org.xinf.style.Style;
import org.xinf.style.StyleSheet;
import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.ony.layout.BoxLayout;

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
                background: #f00;
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
                border: none;
                background: #ddd;
                padding: 0;
            }
            
            #row1 {
                text-align: right;
            }            
            #row2 {
                text-align: center;
            }            

            #box2/2 {
                background: #0f0;
                vertical-align: bottom;
            }
        ");
//        trace("StyleSheet: " + style );
        
        org.xinf.style.StyledObject.globalStyle.append( style );

//        EventDispatcher.addGlobalEventListener( Event.ENTER_FRAME, Test.onEnterFrame );

/*
        var i = new org.xinf.ony.Image("test.png");
        i.style.x = i.style.y = 10;
*/

        var cont = new BoxLayout("container",VERTICAL);
        container = cont;
        org.xinf.ony.Root.getRoot().addChild(cont);

        for( j in 0...5 ) {
            var c = new BoxLayout("row"+j,HORIZONTAL);
            cont.addChild(c);

            for( i in 0...5 ) {
                var box = new Foo("box"+j+"/"+i);
    //            box.style.x = box.style.y = 20;
                box.style.width = box.style.height = 100;
        //        box.styleChanged();
                c.addChild(box);
            }
        }
        
        #if neko
             org.xinf.inity.Root.root.run();
        #end
    }
}
