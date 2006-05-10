package nekobind;

class TypeMap {
    public var buf:String;
    private var types:Hash<IType>;
    
    public function new() {
        types = new Hash<IType>();
        
        setMaps( "
float,double : Float
int,unsigned int,short,unsigned short,char,unsigned char,signed char : Int
unsigned char*,const unsigned char*,char*,const char* : String
bool : Bool
void : Void
");
        addType( "value", new NativeType("value") );
    }
    

    public function setMaps( maps:String ) {
        var file = maps.split("\n");
        for( line in file ) {
            if( line.length > 0 ) {
                var l = line.split(" : ");
                for( type in l[0].split(",") ) {
                    if( type == "void" ) {
                        types.set( type, new VoidType() );
                    } else {
                        types.set( type, new PrimitiveType( type, l[1] ) );
                    }
                }
            }
        }
    }
    
    public function addType( name:String, t:IType ) : Void {
        types.set( name, t );
    }
   
    public function addTypedef( t:String, final:String ) : Void {
        types.set( t, new LinkedType( get(final) ) );
    }
    
    public function knows( type:String ) : Bool {
        return( types.get(type) != null );
    }
    
    public function get( type:String ) : IType {
        var t:IType = types.get( type );
        if( t == null ) {
            var ta = type.split(".");
            if( ta.length > 1 ) {
                t = WrappedType.make(ta,this);
            } else {
                t = new UnknownType(type);
            }
        }
        return t;
    }

}
