package nekobind;

class Generator {
    public var module:String;
    public var map:TypeMap;
    public var file:neko.File;
    
    public var buf:String;
    
    public function new( filename:String, mod:String ) {
        module = mod.toUpperCase();
        buf = new String("");
        map = new TypeMap();
        
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

    private function strip( s:String, what:String, mangleNumbers:Bool ) :String {
        // FIXME: use Ereg.
            s = s.split(what).join("");
            
            if( !mangleNumbers ) return s;
            
            // start with _ if it starts with a number.
            var c = s.charCodeAt(0);
            if( c > 47 && c < 58 ) {
                s = "_"+s;
            }
            
            return s;
            
        /*
        if( s.substr(0,prefix.length).toUpperCase() == prefix ) {
            s = s.substr(prefix.length,s.length);
            var c = s.charCodeAt(0);
            if( c > 47 && c < 58 ) {
                s = "_"+s;
            }
        }
        return s;
        */
    }
    
    private function stripSymbol( s:String ) {
        s = strip( s, module+"_", true );
        s = strip( s, module, true );
        s = strip( s, module.toLowerCase(), true );
        return s;
    }

    private function stripCode( s:String ) {
        s = strip( s, module+"_", false );
        s = strip( s, module, false );
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

    public function classDefinition( name:String, members:Array<Array<String>> ) : Void {
        _classDefinition( name, members );
    }
    public function _classDefinition( name:String, members:Array<Array<String>> ) : Void {
    }

    public function typedef( newType:String, primary:String ) : Void {
        map.addTypedef(newType,primary);
    }
    
    public function defines() : String {
        return("");
    }
}
