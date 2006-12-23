
package xinf.support;

class DLLLoader {
    public static var loaded:Hash<Bool>;
    
    public static function addLibToPath( lib:String ) :Void {
        try {
            if( loaded==null ) loaded = new Hash<Bool>();
            if( loaded.get(lib) ) return;
            
            switch( neko.Sys.systemName() ) {
                case "Windows":
                    var libPath = neko.Sys.getEnv("HAXEPATH")+"\\lib\\"+lib;
                    var version = neko.io.File.getContent( libPath+"\\.current" );
                    version = version.split(".").join(",");
                    libPath += "\\"+version+"\\ndll\\Windows";
                    neko.Sys.putEnv( "PATH", neko.Sys.getEnv("PATH")+";"+libPath );
                
                default:
            }
            
            trace("Added haxelib '"+lib+"' to DLL PATH: "+neko.Sys.getEnv("PATH") );
            
            loaded.set( lib, true );
        } catch( e:Dynamic ) {
            trace("Trying to load dependency DLLs for '"+lib+"' failed: "+e );
        }
    }
}
