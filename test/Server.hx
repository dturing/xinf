package test;

class Server {
    private static var testDir="results";
    static function testResult( name:String, number:Int, visual:Bool, targetEquality:Float ) :Dynamic {
        // assure test directory exists
        if( !neko.FileSystem.exists( testDir ) ) {
            neko.FileSystem.createDir( testDir );
        }
        if( !neko.FileSystem.isDirectory( testDir ) ) {
            throw( "test result directory '"+testDir+"' exists but is not a directory" );
        }
    }

    static function result( name:String, number:Int, visual:Bool, targetEquality:Float ) :Dynamic {
        try {
            testResult( name, number, visual, targetEquality );
        } catch( e:Dynamic ) {
            return( { result:false, exception:e } );
        }
        return( { result:true } );
    }

    static function checkpoint(name) { 
        return( result("checkpoint", 0, false, 0 ) );
    }
    
    static function main() {
        var r = new haxe.remoting.Server();
        r.addObject("Server",Server);
        if( r.handleRequest() )
            return;
        
        neko.Lib.print("remoting server for xinf tests. nothing to see for humans.");
    }
}