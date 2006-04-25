package nekobind;

class PrimitiveType implements IType {
    private var ctype:String;
    private var hxtype:String;
    
    public function new( _ctype:String, _hxtype:String ) {
        ctype = _ctype;
        hxtype = _hxtype;
    }
    
    public function cCacheReturn( call:String ) : String {
        return("\t"+ctype+" c_result = "+call+";\n" );
    }
    
    public function cReturn() : String {
        return("\treturn "+toHx("c_result")+";\n");
    }
    
    public function cLocal( name:String ) : String {
        return("\t"+ctype+" c_"+name+" = "+toC("v_"+name)+";\n" );
    }
    
    public function cArg( name:String ) : String {
        return("value v_"+name);
    }
    
    public function cCallArg( name:String ) : String {
        return("c_"+name);
    }
    
    public function cFunc( name:String ) : String {
        return("value "+name );
    }

    public function check( name:String ) : String {
        return("\tCHECK_"+hxtype+"( v_"+name+" );\n");
    }
    
    public function cPrimitive() : String {
        return( ctype );
    }

    public function defines( kinds:Hash<String> ):String {
        return("");
    }

    public function hxType() : String {
        return( hxtype );
    }
    
    public function toC( name:String ) : String {
        return( "VAL_"+hxtype+"( "+name+" )" );
    }

    public function toHx( name:String ) : String {
        return( "ALLOC_"+hxtype+"( "+name+" )" );
    }
    
    public function toString() : String {
        return( "["+Reflect.getClass(this).__name__.pop()+" '"+ctype+"']" );
    }
}