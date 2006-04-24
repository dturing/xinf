package nekogen;

class Generator {
    public var module:String;
    public var buf:String;
    public var map:TypeMap;
    public var file:neko.File;
    
    public function new( filename:String, mod:String ) {
        module = mod.toUpperCase();
        buf = new String("");
        map = new TypeMap( module+".kinds" );
        
        file = neko.File.write( filename, false );
    }

    public function finish() {
        file.flush();
        file.close();
    }

    public function print( str:String ) {
        file.write( str );
    }

    public function argList( args:Array<Array<String>>, f ) {
        var i:Iterator<Array<String>> = args.iterator();
        for( arg in i ) {
            f( arg[1], arg[0], !i.hasNext() );
        }
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
        _constant( name, map.getFinalType(type), value );
    }
    public function _constant( name:String, type:String, value:String ) : Void {
    }

    public function func( name:String, type:String, args:Array<Array<String>> ) : Void {
        var a = new Array<Array<String>>();
        for( arg in args ) {
            a.push( [ arg[0], map.getFinalType( arg[1] ) ] );
//            trace("arg: "+arg+": "+a.get(arg) );
        }
        _func( name, map.getFinalType(type), a );
    }
    public function _func( name:String, type:String, args:Array<Array<String>> ) : Void {
    }

    public function typedef( newType:String, primary:String ) : Void {
        map.addTypedef(newType,primary);
    }
}
