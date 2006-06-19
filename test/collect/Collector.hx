class Collector {
    private static var testDir="results";
    static function testResult( name:String, number:Int, visual:Bool, targetEquality:Float, runtime:String ) :Dynamic {
        var exitCode:Int = 0;
    
        // assure test directory exists
        if( !neko.FileSystem.exists( testDir ) ) {
            neko.FileSystem.createDir( testDir );
        }
        if( !neko.FileSystem.isDirectory( testDir ) ) {
            throw( "test result directory '"+testDir+"' exists but is not a directory" );
        }
        
        // make screenshot
        exitCode = neko.Sys.command("xwd -display :1.0 -root | xwdtopnm > "+testDir+"/"+name+":"+number+":"+runtime+".pnm");
        if( exitCode != 0 ) throw("Could not take screenshot.");
    }

    static function result( name:String, number:Int, visual:Bool, targetEquality:Float, runtime:String ) :Dynamic {
        try {
            testResult( name, number, visual, targetEquality, runtime );
        } catch( e:Dynamic ) {
            return( { result:false, exception:e } );
        }
        return( { result:true } );
    }
    
    static function main() {
        var r = new haxe.remoting.Server();
        r.addObject("Collector",Collector);
        if( r.handleRequest() )
            return;
        
        neko.Lib.print("remoting server for xinf tests. nothing to see for humans.");
    }
}
