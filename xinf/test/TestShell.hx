/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test;

import Xinf;

class TestShell {
    public static var serverUrl = "http://localhost:2000/testserver.n";
    
    var cnx:haxe.remoting.AsyncConnection;
    var cases:Array<TestCase>;
    var caseIterator:Iterator<TestCase>;
	var current:TestCase;
	var suite:String;
    
    public function new( suite:String ) {
		this.suite=suite;
        cnx = haxe.remoting.AsyncConnection.urlConnect( serverUrl );
        cnx.onError = function(err) { throw( err ); };
        cases = new Array<TestCase>();
		Root.addEventListener( FrameEvent.ENTER_FRAME, onEnterFrame );
    }
    
    public function add( t:TestCase ) {
        cases.push(t);
    }
	
	function onEnterFrame( e:FrameEvent ) {
		if( current!=null && current.finished ) {
			runNextCase();
		}
	}

    function runNextCase() {
        if( caseIterator==null || !caseIterator.hasNext() ) {
            cnx.test.endRun.call([],function(r){ 
				// FIXME. app.quit()
				#if neko
					neko.Sys.exit(0);
				#end
			});
            return;
        }

		current = caseIterator.next();
        current.run( cnx, function() { }, suite );
    }
    

    override public function run() {
        var platform = 
                #if neko
                    "inity";
                #else flash9
                    "flash9";
                #else js
                    "js";
                #end    
        try {
            cnx.test.startRun.call([suite,platform],function(r){ });
        } catch(e:Dynamic) {
            trace("No connection to server: "+Std.string(e));
        }
        caseIterator = cases.iterator();

        
        // register trace-to-server
        /*
        var self=this;
        haxe.Log.trace = function( v:Dynamic, ?pos:haxe.PosInfos ) {
            self.cnx.test.info.call(["trace", platform, Std.string(v)],function(r){ } );
        }
		*/

		runNextCase();
		
		while( true ) {
			try {
				Root.main();
			} catch(e:Dynamic) {
				if( current!=null ) {
					var cur=current;
				//	trace("EXC: "+e );
					current.result( false, "Exception: "+e,	function() { cur.cleanFinish(); } );
				} else throw(e);
			}
		}
    }
}
