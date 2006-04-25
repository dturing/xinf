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
        
        return( new WrappedType( const, cprimitive, ptr ) );
    }
    
    public static function _cPrimitive( const:Bool, primitive:IType, ptr:Int ) {
    }
    
    public function new( _const:Bool, _primitive:IType, _ptr:Int ) {
        const=_const;
        primitive=_primitive;
        ptr=_ptr;
        
        var c = "";
        if( const ) c="const ";
        c+=primitive.cPrimitive();
        for( i in 0...ptr ) c+="*";
        
        kind = "k_";
        kind += primitive.cPrimitive().split(" ").join("_");
        for( i in 0...ptr ) kind+="_p";

        super( c, "Dynamic" );
    }
    
        
    public function cReturn() : String {
        return("\treturn ALLOC_KIND( c_result, "+kind+" );\n");
    }
    
    public function check( name:String ) : String {
        return("\tCHECK_KIND( v_"+name+", "+kind+" );\n");
    }

    public function defines( kinds:Hash<String> ):String {
        var k = kinds.get( kind );
        if( k==null ) {
            kinds.set( kind, "" );
            return("DEFINE_KIND("+kind+");\n");
        }
        return("");
    }

    public function toC( name:String ) : String {
        return( "VAL_KIND( "+name+", "+kind+" )" );
    }
}
