package nekobind;

class CWrapper extends Generator {
    var _defines:String;
    var kinds:Hash<String>;

    public function new( module:String ) {
        super(module+"_wrap.c",module);
        
        _defines = neko.File.getContent("../gen/C.runtime");
        _defines += neko.File.getContent(module+".runtime");
        
        kinds = new Hash<String>();
        // these kinds are defined in the cptr library
        for( kind in [ "k_float_p", "k_double_p", "k_int_p", "k_unsigned_int_p", "k_short_p", "k_unsigned_short_p", "k_char_p", "k_unsigned_char_p", "k_void_p", "k_void_p_p" ] ) {
            kinds.set( kind, "" );
        }
    }

    override public function _constant( name:String, type:String, value:String ) : Void {
    }

    override public function _func( name:String, type:String, args:Array<Array<String>> ) : Void {
        var t:IType = map.get(type);
        
        _defines += t.defines( kinds );
   //     trace( "CWrapper::_func "+args );
        _defines += argList( args, argDefines );
        
        print( t.cFunc("neko_"+name) + "( " + argList( args, argFuncDecl ) + ") {\n");
        
            print( argList( args, argCheck ) );
            print( argList( args, argLocal ) );
            print( t.cCacheReturn( name+"("+argList( args, argCall )+")" ) );
            print( t.cReturn() );
            
        print("}\n");

        var n:Int=args.length;
        print( "DEFINE_PRIM(neko_"+name+","+n+");\n\n");
    }
    
    public function argFuncDecl( type:IType, name:String, last:Bool ) : String {
        var s:String = type.cArg(name);
        if( !last ) s += ",";
        s += " ";
        return s;
    }

    public function argLocal( type:IType, name:String, last:Bool ) : String {
        return( type.cLocal(name) );
    }

    public function argCheck( type:IType, name:String, last:Bool ) : String {
        return( type.check(name) );
    }

    public function argCall( type:IType, name:String, last:Bool ) : String {
        var s:String = type.cCallArg(name);
        if( !last ) s += ",";
        return s;
    }

    public function argDefines( type:IType, name:String, last:Bool ) : String {
        return( type.defines(kinds) );
    }

    override public function defines() : String {
        return(_defines+"\n\n");
    }
    
    override public function _classDefinition( name:String, members:Array<Array<String>> ) : Void {
        var p:IType = WrappedType.make(name.split("."),map);
        map.addType( name, p );
        
        var t:IType = new WrappedType(false,p,1);
        map.addType( name+"_p", t );
        _defines += t.defines( kinds );
        
        for( member in members ) {
            memberAccessors( t, name, member[0], member[1] );
        }
    }
    
    private function memberAccessors( classType:IType, className:String, name:String, type:String ) {
        var t:IType = map.get(type);
        var c:IType = classType;

        _defines += t.defines( kinds );
 
        // setter       
        print( t.cFunc("_"+className+"_"+name+"_set") + "( " + c.cArg("o") +", "+ t.cArg("v") + " ) {\n");
            print( c.check("o") );
            print( c.cLocal("o") );
            print( t.check("v") );
            
            print( t.setMember( "c_o", name, "v_v" ) );
                        
            print("\treturn v_v;\n");
        print( "}\n");
        print( "DEFINE_PRIM(_"+className+"_"+name+"_set,2)\n\n");

        // getter       
        print( t.cFunc("_"+className+"_"+name+"_get") + "( " + c.cArg("o") + " ) {\n");
            print( c.check("o") );
            print( c.cLocal("o") );
            
            print( t.returnMember( "c_o", name ) );
                        
        print( "}\n");
        print( "DEFINE_PRIM(_"+className+"_"+name+"_get,1)\n\n");
    }
    
}
