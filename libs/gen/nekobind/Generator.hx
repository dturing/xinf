package nekobind;

class Generator {
    public var module:String;
    public var map:TypeMap;
    public var file:neko.File;
    
    public var buf:String;
    
    public function new( filename:String, mod:String ) {
        module = mod.toUpperCase();
        buf = new String("");
        map = new TypeMap( module+".kinds" );
        
        file = neko.File.write( filename, false );
    }

    public function finish() {
        file.write( defines() );
        file.write( buf );
        file.flush();
        file.close();
    }

    public function print( str:String ) {
        buf += str;
    }
    
    public function argList( args:Array<Array<String>>, f ) {
        var i:Iterator<Array<String>> = args.iterator();
        var s:String = "";
        for( arg in i ) {
            s += f( map.get(arg[1]), arg[0], !i.hasNext() );
        }
        return s;
    }

    private function stripPrefix( s:String, prefix:String ) {
        if( s.substr(0,prefix.length).toUpperCase() == prefix ) {
            s = s.substr(prefix.length,s.length);
            var c = s.charCodeAt(0);
            if( c > 47 && c < 58 ) {
                s = "_"+s;
            }
        }
        return s;
    }
    
    private function stripSymbol( s:String ) {
        s = stripPrefix( s, module+"_" );
        s = stripPrefix( s, module );
        return s;
    }


    /* usage: override _*, call the plain versions (typemapping is done in between) */

    public function constant( name:String, type:String, value:String ) : Void {
        _constant( name, type, value );
    }
    public function _constant( name:String, type:String, value:String ) : Void {
    }

    public function func( name:String, type:String, args:Array<Array<String>> ) : Void {
        _func( name, type, args );
    }
    public function _func( name:String, type:String, args:Array<Array<String>> ) : Void {
    }

    public function typedef( newType:String, primary:String ) : Void {
        map.addTypedef(newType,primary);
    }
    
    public function defines() : String {
        return("");
    }
}
