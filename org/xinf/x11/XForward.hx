package org.xinf.x11;

import org.xinf.style.Style;
import org.xinf.style.StyleSheet;
import org.xinf.event.Event;

import org.xinf.ony.Root;

class XForward extends XScreen {
    public function new( server:String, _screen:Int ) {
        super( server, _screen );

        if( !X.HaveTestExtension(display) ) {
            throw( "No XTest extension on display "+name );
        }
        
        addEventListener( Event.MOUSE_DOWN, onMouseDown );
        addEventListener( Event.MOUSE_UP, onMouseUp );
        addEventListener( Event.MOUSE_MOVE, onMouseMove );
    }

    public function onMouseDown( e:Event ) :Void {
        trace( "down" );
        X.TestFakeButtonEvent( display, 1, 1, X.CurrentTime );
    }
    public function onMouseUp( e:Event ) :Void {
        trace( "up" );
        X.TestFakeButtonEvent( display, 1, 0, X.CurrentTime );
    }
    public function onMouseMove( e:Event ) :Void {
            //FIXME: this is a very very crude globalToLocal transformation!
        X.TestFakeMotionEvent( display, screen, 
                Math.round(org.xinf.inity.Root.root.mouseX-bounds.x), 
                Math.round(org.xinf.inity.Root.root.mouseY-bounds.y), X.CurrentTime );
    }
    
    static function main() {
        trace("Hello");

        var style = StyleSheet.newFromString("
            .XForward {
                width: 320px;
                height: 240px;
                backgroundColor: #080;
            }
            
            .Pane {
                backgroundColor: #aaa;
            }
            
            #root {
                width: 320px;
                height: 240px;
                backgroundColor: #008;
            }
            
        ");
        
        org.xinf.style.StyledObject.globalStyle.append( style );

        var root = Root.getRoot();

        var i = new XForward(":1",0);
        root.addChild(i);

        var j = new XForward(":1",1);
        j.bounds.x = 320;
        root.addChild(j);
        
        #if neko
             org.xinf.inity.Root.root.run();
        #end
    }
}
