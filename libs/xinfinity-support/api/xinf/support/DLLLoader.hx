
package xinf.support;

class DLLLoader {
    public static var loaded:Hash<Bool>;

    public static function getHaxelibPath() :String {
        switch( neko.Sys.systemName() ) {
            case "Windows":
                var haxepath = neko.Sys.getEnv("HAXEPATH");
                if( haxepath==null ) {
                    throw "HAXEPATH environment variable not defined, please install haXe";
                }
                return haxepath+"\\lib\\";
                
            default:
                var config = neko.Sys.getEnv("HOME")+"/.haxelib";
                try {
                    return neko.io.File.getContent(config);
                } catch( e : Dynamic ) {
                    try {
                        return neko.io.File.getContent("/etc/.haxelib");
                    } catch( e : Dynamic )
                        throw "haxelib seems not to be correctly installed. run 'haxelib setup'";
                }
        }
        return null;
    }

    public static function getXinfLibPath() :String {
        var pathSep = "/";
        if( neko.Sys.systemName()=="Windows" ) pathSep = "\\";
        var libPath = getHaxelibPath()+pathSep+"xinf";
        var version = neko.io.File.getContent( libPath+pathSep+".current" );
        version = version.split(".").join(",");
        libPath += pathSep+version+pathSep+"ndll"+pathSep+neko.Sys.systemName();
        return libPath;
    }
    
    public static function addToEnvironment( name:String, separator:String, value:String ) {
        var cur = neko.Sys.getEnv(name);
        if( cur==null || cur.length==0 )
            cur = value;
        else
            cur = cur+separator+value;
            
        neko.Sys.putEnv( name, cur );
        //trace("added to "+name+": "+value );
    }
    
    public static function addLibToPath( lib:String ) :Void {
        try {
            if( loaded==null ) loaded = new Hash<Bool>();
            if( loaded.get(lib) ) return;

            var libPath = getXinfLibPath();

            switch( neko.Sys.systemName() ) {
                case "Windows":
                    addToEnvironment("PATH",";",libPath);
                    
                default:
                    addToEnvironment("LD_LIBRARY_PATH",":",libPath);
            }
            
            loaded.set( lib, true );
        } catch( e:Dynamic ) {
            trace("Trying to load dependency DLLs for '"+lib+"' failed: "+e );
        }
    }
}
