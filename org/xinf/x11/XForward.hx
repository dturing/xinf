package org.xinf.x11;

import org.xinf.event.Event;

class XForward extends XScreen {
    public function new( server:String, _screen:Int, parent:org.xinf.ony.Element ) {
        super( server, _screen, parent );

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
        var root:org.xinf.inity.Root = untyped org.xinf.ony.Root.getRoot()._p;
        trace("FakeMotion: "+display+"."+screen+" - "+Math.round(root.mouseX-bounds.x));
        X.TestFakeMotionEvent( display, screen, 
                Math.round(root.mouseX-bounds.x), 
                Math.round(root.mouseY-bounds.y), X.CurrentTime );
    }
    
    static function main() {
        var root = org.xinf.ony.Root.getRoot();

        var i = new XForward(":1",0,root);
        i.bounds.setPosition( 10, 10 );
        i.bounds.setSize( 320, 240 );

        var j = new XForward(":1",1,root);
        i.bounds.setPosition( 340, 10 );
        i.bounds.setSize( 320, 240 );
        
        org.xinf.ony.Root.getRoot().run();
    }
}
