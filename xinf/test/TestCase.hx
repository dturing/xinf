
package xinf.test;

import xinf.event.EventDispatcher;
import xinf.event.EventKind;
import xinf.event.FrameEvent;

class TestCase {
    public var next:Void->Void;
    public var shell:TestShell;
    
    public function new() {
    }
    
    public function run( shell:TestShell, next:Void->Void ) {
        this.next = next;
        this.shell = shell;
        test();
    }
    
    public function test() {
        // empty test
        finish();
    }

    public function finish( ?passed:Bool ) {
        shell.runAtNextFrame( next );
    }

    public function assertDisplay( result:Bool->Void, ?targetEquality:Float ) {
        shell.assertDisplay(""+this,result,targetEquality);
    }
    
    public function assertEvent<T>( obj:EventDispatcher, type :EventKind<T>, assert :T->Bool, result:Bool->Void, ?timeout:Int ) {
        var self=this;
        var t:Dynamic;
        var h:Dynamic;
        t = xinf.erno.Runtime.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
                timeout-=1;
                if( timeout <= 0 ) {
                    trace("assert event timeout");
                    self.shell.result( ""+self, false, "Event timed out" );
                    xinf.erno.Runtime.removeEventListener( FrameEvent.ENTER_FRAME, t );
                    obj.removeEventListener( type, h );
                    result( false );
                }
            });
        
        h = obj.addEventListener( type, function(e:T) {
                if( assert(e) ) {
                    xinf.erno.Runtime.removeEventListener( FrameEvent.ENTER_FRAME, t );
                    obj.removeEventListener( type, h );
                    self.shell.result( ""+self, true, "Got expected event: "+e );
                    result( true );
                } else {
                    self.shell.info( ""+self, "unexpected event: "+e );
                }
            });
    }
    
    public function cleanFinish( ?passed:Bool ) {
        var r = X.root();
        for( c in r.children() ) {
            r.detach(c);
        }
    
        finish(passed);
    }
    
    public function toString() :String {
        return Type.getClassName( Type.getClass(this) ).split(".").pop().split("::").pop();
    }
}
