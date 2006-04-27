package nekobind;

class LinkedType implements IType {
    private var other:IType;
    
    public function new( to:IType ) {
        other = to;
    }
    
    public function cCacheReturn( call:String ) : String {
        return other.cCacheReturn(call);
    }
    
    public function cReturn() : String {
        return other.cReturn();
    }
    
    public function cLocal( name:String ) : String {
        return other.cLocal(name);
    }
    
    public function cArg( name:String ) : String {
        return other.cArg(name);
    }
    
    public function cCallArg( name:String ) : String {
        return other.cCallArg(name);
    }
    
    public function cFunc( name:String ) : String {
        return other.cFunc(name);
    }

    public function check( name:String ) : String {
        return other.check(name);
    }

    public function sizeof() : String {
        return( other.sizeof() );
    }

    public function cPrimitive() : String {
        return( other.cPrimitive() );
    }

    public function kPrimitive() : String {
        return( other.kPrimitive() );
    }

    public function defines( kinds:Hash<String> ):String {
        return( other.defines(kinds) );
    }

    public function setMember( o:String, name:String, val:String ):String {
        return( other.setMember( o, name, val ) );
    }
    
    public function returnMember( o:String, name:String ):String {
        return( other.returnMember( o, name ) );
    }
    
    public function hxType() : String {
        return( other.hxType() );
    }
        
    public function toString() : String {
        return( "[LinkedType -> "+other+"]" );
    }
}
