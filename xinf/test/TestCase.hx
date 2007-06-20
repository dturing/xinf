
package xinf.test;

import xinf.event.EventDispatcher;
import xinf.event.EventKind;
import xinf.event.FrameEvent;

class TestCase {
    var next:Void->Void;
    var cnx:haxe.remoting.AsyncConnection;
    var iteration:Int;
    var platform:String;
    var name:String;
    var expectFail:Bool;
    
    public function new() {
        iteration = 0;
        platform = 
                #if neko
                    "inity";
                #else flash9
                    "flash9";
                #else js
                    "js";
                #end
        name = ""+this;
        expectFail = false;
    }
    
    public function run( cnx:haxe.remoting.AsyncConnection, next:Void->Void ) {
        this.next = next;
        this.cnx = cnx;
        test();
    }
    
    public function test() {
        // empty test
        finish();
    }

    public function expectFailure( platform:String ) :Void {
        if( platform==this.platform ) expectFail=true;
    }

    public function runAtNextFrame( f:Void->Void ) {
        var handler:Dynamic;
        handler = xinf.erno.Runtime.addEventListener( xinf.event.FrameEvent.ENTER_FRAME, function(e) {
                xinf.erno.Runtime.removeEventListener( xinf.event.FrameEvent.ENTER_FRAME, handler );
                f();
            });
    }

    public function mouseMove( x:Int, y:Int ) {
        cnx.test.mouseMove.call( [x,y], function(r) { });
    }
    public function mouseButton( b:Int, press:Bool ) {
        cnx.test.mouseButton.call( [b, press], function(r) { });
    }

    public function result( pass:Bool, message:String, ?expectFail:Bool ) :Void {
        if( expectFail==null ) expectFail=this.expectFail;
        cnx.test.result.call( [iteration++, name, platform, pass, message, expectFail, null ],
            function(r) { } );
    }

    public function info( message:String ) :Void {
        cnx.test.info.call( [ name, platform, message],
            function(r) { } );
    }


    public function assertDisplay( result:Bool->Void, width:Float, height:Float, ?targetEquality:Float, ?expectFail:Bool ) {
        if( expectFail==null ) expectFail=this.expectFail;
        if( targetEquality==null ) targetEquality=1.0;
        
        var self=this;
        var handler:Dynamic;
        handler = xinf.erno.Runtime.addEventListener( xinf.event.FrameEvent.ENTER_FRAME, function(e) {
            xinf.erno.Runtime.removeEventListener( xinf.event.FrameEvent.ENTER_FRAME, handler );
            
            try {
                self.cnx.test.shoot.call([ self.iteration++, self.name, self.platform, width, height, targetEquality, expectFail ], function( r:Dynamic ) {
                        result( r>=targetEquality );
                    } );
            } catch(e:Dynamic) {
                trace("Cannot make screenshot: "+Std.string(e) );
            }
                
        } );
    }


    public function assertEvent<T>( obj:EventDispatcher, type :EventKind<T>, assert :T->Bool, result:Bool->Void, ?timeout:Int ) {
        var self=this;
        var t:Dynamic;
        var h:Dynamic;
        timeout=15;
        t = xinf.erno.Runtime.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
                timeout-=1;
                if( timeout <= 0 ) {
                    trace("assert event timeout");
                    self.result( false, "Event timed out" );
                    xinf.erno.Runtime.removeEventListener( FrameEvent.ENTER_FRAME, t );
                    obj.removeEventListener( type, h );
                    result( false );
                }
            });
        
        h = obj.addEventListener( type, function(e:T) {
                if( assert(e) ) {
                    xinf.erno.Runtime.removeEventListener( FrameEvent.ENTER_FRAME, t );
                    obj.removeEventListener( type, h );
                    self.result( true, "Got expected event: "+e );
                    result( true );
                } else {
                    self.info( "unexpected event: "+e );
                }
            });
    }
    
    public function cleanFinish( ?passed:Bool ) {
        var r = X.root();
        for( c in r.children() ) {
            r.detach(c);
        }

        mouseMove( 0, 0 );
        mouseButton( 1, false );
        mouseButton( 2, false );

        var self=this;
        runAtNextFrame( function() {
            self.finish(passed);
        });
    }

    public function finish( ?passed:Bool ) {
        runAtNextFrame( next );
    }


    public function toString() :String {
        return Type.getClassName( Type.getClass(this) ).split(".").pop().split("::").pop();
    }
}
