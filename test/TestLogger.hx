
interface TestLogger {
    public function screenshot( testObject:Dynamic, targetEquality:Float, next:Dynamic ) :Void;
    public function emptiness( testObject:Dynamic ) :Void;
    public function finished( next:Dynamic ) :Void;
}

class TestServerConnection implements TestLogger {
    public static var runtime:String =
        #if neko
            "neko"
        #else js
            "js"
        #else flash
            "fp"
        #end
        ;
        
    private var testNumber:Int;
    private var cnx:haxe.remoting.AsyncConnection;
    private var nextFunction:Dynamic;

    public function new() :Void {
        var URL = "http://localhost:2000/collect/Collector.n";
        cnx = haxe.remoting.AsyncConnection.urlConnect(URL);
        cnx.onError = function(err) { trace("Error : "+Std.string(err)); };        
        testNumber = 0;
    }    
    
    public function screenshot( testObject:Dynamic, targetEquality:Float, next:Dynamic ) :Void {
        var testName = Reflect.getClass( testObject ).__name__.join(".");
        nextFunction = next;
        try {
            cnx.Collector.result.call([ testName, testNumber++, true, targetEquality, runtime ], replyReceived );
        } catch( e:Dynamic ) {
            trace("couldnt call server: "+e );
        }
    }

    public function emptiness( testObject:Dynamic ) :Void {
        var testName = Reflect.getClass( testObject ).__name__.join(".");
        try {
            cnx.Collector.result.call([ testName, testNumber++, true, 1.0, runtime ], replyReceived );
        } catch( e:Dynamic ) {
            trace("couldnt call server: "+e );
        }
    }
    
    public function finished( next:Dynamic ) :Void {
        nextFunction = next;
        trace("Finished...");
        try {
            cnx.Collector.finished.call( [], replyReceived );
        } catch( e:Dynamic ) {
            trace("couldnt call server: "+e );
        }
    }
    
    private function replyReceived(d:Dynamic) :Void {
        var s = "{ ";
        for( field in Reflect.fields(d) ) {
            s+=field+":"+Reflect.field(d,field)+" ";
        }
        s+="}";
        if( nextFunction != null ) nextFunction();
    }
}
