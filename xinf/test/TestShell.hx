
package xinf.test;

/*
    TODO: base on ony.Model, not ony.erno.Application
          model.quit() instead of neko.Sys.exit
*/

class TestShell extends xinf.ony.erno.Application {
    public static var serverUrl = "http://localhost:2000/testserver.n";
    
    var cnx:haxe.remoting.AsyncConnection;
    var cases:Array<TestCase>;
    var caseIterator:Iterator<TestCase>;
    
    var iteration:Int;
    
    public function new() {
        super();
        cnx = haxe.remoting.AsyncConnection.urlConnect( serverUrl );
        cnx.onError = function(err) { throw( err ); };
        cases = new Array<TestCase>();
        iteration = 0;
    }
    
    public function add( t:TestCase ) {
        cases.push(t);
    }

    function runNextCase() {
        if( caseIterator==null || !caseIterator.hasNext() ) {
            trace("no more tests\n");
            // FIXME. app.quit()
            #if neko
                neko.Sys.exit(0);
            #end
            return;
        }
        
        var testCase = caseIterator.next();
        trace("run test "+testCase );
        testCase.run( this, runNextCase );
    }
    
    public function runAtNextFrame( f:Void->Void ) {
        var handler:Dynamic;
        handler = xinf.erno.Runtime.addEventListener( xinf.event.FrameEvent.ENTER_FRAME, function(e) {
                xinf.erno.Runtime.removeEventListener( xinf.event.FrameEvent.ENTER_FRAME, handler );
                f();
            });
    }
    
    public function assertDisplay( testName:String, result:Bool->Void, ?targetEquality:Float ) {
        var platform = 
        #if neko
            "neko";
        #else flash9
            "flash9";
        #else js
            "js";
        #end
        
        if( targetEquality==null ) targetEquality=1.;
        
        var self=this;
        var handler:Dynamic;
        handler = xinf.erno.Runtime.addEventListener( xinf.event.FrameEvent.ENTER_FRAME, function(e) {
            xinf.erno.Runtime.removeEventListener( xinf.event.FrameEvent.ENTER_FRAME, handler );
            
            try {
                self.cnx.test.shoot.call([ self.iteration++, testName, platform, targetEquality ], function( r:Dynamic ) {
                        result( r>=targetEquality );
                    } );
            } catch(e:Dynamic) {
                trace("Cannot make screenshot: "+Std.string(e) );
            }
                
        } );
    }
    
    public function result( testName:String, pass:Bool, message:String ) :Void {
        var platform = 
        #if neko
            "neko";
        #else flash9
            "flash9";
        #else js
            "js";
        #end
        cnx.test.result.call( [iteration++, testName, platform, pass, message],
            function(r) { } );
    }

    public function info( testName:String, message:String ) :Void {
        var platform = 
        #if neko
            "neko";
        #else flash9
            "flash9";
        #else js
            "js";
        #end
        cnx.test.info.call( [ testName, platform, message],
            function(r) { } );
    }

    public function mouseMove( x:Int, y:Int ) {
        cnx.test.mouseMove.call( [x,y], function(r) { });
    }
    public function mouseButton( b:Int, press:Bool ) {
        cnx.test.mouseButton.call( [b, press], function(r) { });
    }
    
    override public function run() {
        try {
            cnx.test.freshRun.call([],function(r){ });
        } catch(e:Dynamic) {
            trace("No connection to server: "+Std.string(e));
        }
        caseIterator = cases.iterator();

        runNextCase();
        super.run();
    }
}
