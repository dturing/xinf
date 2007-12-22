/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test;

import xinf.event.EventDispatcher;
import xinf.event.EventKind;
import Xinf;

class TestCase {
    var next:Void->Void;
    var cnx:haxe.remoting.AsyncConnection;
	var suite:String;
    var platform:String;
    var name:String;
    
    public function new() {
        platform = 
                #if neko
                    "inity";
                #else flash9
                    "flash9";
                #else js
                    "js";
                #end
        name = ""+this;
    }
    
    public function run( cnx:haxe.remoting.AsyncConnection, next:Void->Void, suite:String ) {
        this.next = next;
        this.cnx = cnx;
		this.suite = suite;
		
		var self=this;
        cnx.test.startTest.call( [ name ], function(r) {
			self.test();
		} );
    }
    
    public function test() {
        // empty test
		next();
    }

    public function runAtNextFrame( f:Void->Void ) {
        var handler:Dynamic;
        handler = xinf.erno.Runtime.addEventListener( xinf.event.FrameEvent.ENTER_FRAME, function(e) {
                xinf.erno.Runtime.removeEventListener( xinf.event.FrameEvent.ENTER_FRAME, handler );
                f();
            });
    }
/*
    public function mouseMove( x:Int, y:Int ) {
        cnx.test.mouseMove.call( [x,y], function(r) { });
    }
    public function mouseButton( b:Int, press:Bool ) {
        cnx.test.mouseButton.call( [b, press], function(r) { });
    }
*/
    public function result( pass:Bool, message:String, next:Void->Void ) :Void {
        cnx.test.result.call( [ pass, message ],
            function(r) { next(); } );
    }

    public function info( message:String ) :Void {
        cnx.test.info.call( [message],
            function(r) { } );
    }


    public function assertDisplay( width:Float, height:Float, result:Float->Void ) {
        var self=this;
		runAtNextFrame( function() {
            try {
                self.cnx.test.shoot.call([ self.name, self.suite, self.platform, width, height ], result);
            } catch(e:Dynamic) {
                trace("Cannot make screenshot: "+Std.string(e) );
            }
                
        } );
    }

/*
    public function assertEvent<T>( obj:EventDispatcher, type :EventKind<T>, assert :T->Bool, result:Bool->Void, ?timeout:Int ) {
        var self=this;
        var t:Dynamic;
        var h:Dynamic;
        timeout=15;
        t = xinf.erno.Runtime.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
                timeout-=1;
                if( timeout <= 0 ) {
                    trace("assert event timeout");
                    self.result( false, "Event timed out", function() {
						xinf.erno.Runtime.removeEventListener( FrameEvent.ENTER_FRAME, t );
						obj.removeEventListener( type, h );
						result( false );
					});
                }
            });
        
        h = obj.addEventListener( type, function(e:T) {
                if( assert(e) ) {
                    xinf.erno.Runtime.removeEventListener( FrameEvent.ENTER_FRAME, t );
                    obj.removeEventListener( type, h );
                    self.result( true, "Got expected event: "+e, function() {
						result( true );
					});
                } else {
                    self.info( "unexpected event: "+e );
                }
            });
    }
*/

    public function cleanFinish() {
        var r = Root;
        for( c in r.getRootSvg().childNodes ) {
            r.removeChild(c);
        }

    //    mouseMove( 0, 0 );
    //    mouseButton( 1, false );
    //    mouseButton( 2, false );

        runAtNextFrame( next );
    }


    public function toString() :String {
        return Type.getClassName( Type.getClass(this) ).split(".").pop().split("::").pop();
    }
}
