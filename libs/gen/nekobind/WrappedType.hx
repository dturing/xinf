package nekobind;

class WrappedType extends PrimitiveType {
    private var const:Bool;
    private var primitive:IType;
    private var ptr:Int;
    
    private var kind:String;
    
    public static function make( t:Array<String>, map:TypeMap ) : IType {
        var const:Bool = false;
        var ptr:Int = 0;
        var cprimitive:IType;
        var primitive:String = "void";
        ptr=0;
        for( q in t ) {
            if( q=="p" ) {
                ptr++;
            } else if( q.substr(0,2) == "q(" ) {
                var qual = q.substr(2,q.length-3);
                if( qual == "const" ) {
                    const = true;
                } else {
                    throw("Unknown qualifier '"+qual+"' for type '"+t.join(".")+"'");
                }
            } else if( q.substr(0,2) == "a(" ) {
                ptr++;
                trace("cannot handle fixed sized arrays properly (yet): "+t.join(".") );
            } else {
                primitive = q;
            }
        }
        
        cprimitive = map.get(primitive);

        var c = "";
//        if( const ) c="const ";
        c+=cprimitive.cPrimitive();
        for( i in 0...ptr ) c+="*";
        
        if( const && map.knows("const "+c ) ) {
            return( new LinkedType( map.get("const "+c) ) );
        } else if( map.knows(c) ) {
            return( new LinkedType( map.get(c) ) );
        }
//        trace("new wrappedtype "+const+" "+primitive+" - "+cprimitive+" *"+ptr );        
        return( new WrappedType( const, cprimitive, ptr ) );
    }
    
    public static function cPrimitive( const:Bool, primitive:IType, ptr:Int ) {
        var p:String = primitive.cPrimitive();
        for( i in 0...ptr ) p+="*";
        return( p );
    }
    
    public function new( _const:Bool, _primitive:IType, _ptr:Int ) {
        const=_const;
        primitive=_primitive;
        ptr=_ptr;
        
        var c = "";
        if( const ) c="const ";
        c+=primitive.cPrimitive();
        for( i in 0...ptr ) c+="*";
        
        kind = "k_"+kPrimitive();
        if( kind == "k_" ) throw("empty kind: "+_const+" "+primitive.kPrimitive()+" "+_ptr+"*" );

        super( c, "Dynamic" );
    }
    
        
    override public function cReturn() : String {
        return("\treturn ALLOC_KIND( c_result, "+kind+" );\n");
    }
    
    override public function check( name:String ) : String {
        return("\tCHECK_KIND( v_"+name+", "+kind+" );\n");
    }

    override public function defines( kinds:Hash<String> ):String {
        var def:String = "";
    
        // if the kind (or kind_p) is not defined yet, return its DEFINE_KIND.
    
        var k = kinds.get( kind );
        if( k==null ) {
            kinds.set( kind, "" );
            def += "DEFINE_KIND("+kind+");\n";
        }

        var k = kinds.get( kind+"_p" );
        if( k==null ) {
            kinds.set( kind+"_p", "" );
            def += "DEFINE_KIND("+kind+"_p"+");\n";
        }
        
        return def;
    }

    override public function kPrimitive() : String {
        var k:String = "";
        k += primitive.kPrimitive();
        for( i in 0...ptr ) k+="_p";
        return( k );
    }

    override public function toC( name:String ) : String {
        return( "VAL_KIND( "+name+", "+kind+" )" );
    }


    override public function setMember( o:String, name:String, val:String ):String {
        return("\tmemcpy(&("+o+"->"+name+"), "+toC(val)+", "+sizeof()+" );\n" );
    }

    override public function returnMember( o:String, name:String ):String {
        return("\treturn ALLOC_KIND( &("+( o+"->"+name )+"), "+kind+"_p );\n");
    }
}
