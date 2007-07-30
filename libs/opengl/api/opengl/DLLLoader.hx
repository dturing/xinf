
package opengl;

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
/*    
    public static function addToEnvironment( name:String, separator:String, value:String ) {
        var cur = neko.Sys.getEnv(name);
        if( cur==null || cur.length==0 )
            cur = value;
        else
            cur = value+separator+cur;
            
        neko.Sys.putEnv( name, cur );
        trace("prefixed "+name+" with: "+value+", now: "+neko.Sys.getEnv( name ) );
    }
*/
    public static function checkEnvironment( name:String, separator:String, value:String ) {
        var value = StringTools.replace( StringTools.replace( value, "//", "/" ), "\\\\", "\\" );
    
        var cur = neko.Sys.getEnv(name);
        if( cur!=null ) {
            var a = cur.split(separator);
            for( i in a ) {
                if( i==value ) return;
            }
        }
        
        trace("If things fail, please add '"+value+"' to your environment variable '"+name+"' and try again.");
    }

    public static function addLibToPath( lib:String ) :Void {
        if( loaded==null ) loaded = new Hash<Bool>();
        if( loaded.get(lib) ) return;

        var libPath = getXinfLibPath();

        switch( neko.Sys.systemName() ) {
            case "Windows":
                checkEnvironment("PATH",";",libPath);
            case "Mac":
                checkEnvironment("DYLD_LIBRARY_PATH",";",libPath);
            default:
        }
        
        loaded.set( lib, true );
    }
}



/*
package opengl;

class DLLLoader {
    public static var loaded:Hash<Bool>;
    
    public static function addLibToPath( lib:String ) :Void {
        try {
            if( loaded==null ) loaded = new Hash<Bool>();
            if( loaded.get(lib) ) return;
            
            switch( neko.Sys.systemName() ) {
                case "Windows":
                    var libPath = neko.Sys.getEnv("HAXEPATH")+"\\lib\\xinf";
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
*/