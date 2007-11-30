
package xinf.test;

import x11.Display;

class TestMouse {
    public static function main() {
    
        var cnx = haxe.remoting.AsyncConnection.urlConnect("http://localhost:2000/testserver.n");
        cnx.onError = function(err) { throw( "CNX: "+err ); };
        cnx.test.mouseMove.call( [100,100], function(r) {
                trace("mouse moved");
            });
            
            /*
        var dpy = Display.openDisplay( ":10.0" );
        if( !dpy.hasTestFakeExtension() ) throw("need XTest extension to fake input events");
        else trace("XTest enabled");
        
        dpy.testFakeMotionEvent( 0, 10, 10, 0 );
        */
    }
}