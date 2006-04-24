package nekogen;

class CWrapper extends Generator {

    public function new( module:String ) {
        super(module+"_wrap.c",module);
        
        var r = neko.File.getContent("gen/C.runtime");
        print( r );
        
        print("/* defined kinds */\n");
        for( kind in map.getKinds() ) {
            var k:String = kind;
            if( k.charAt(k.length-1) == "*" ) {
                k = k.substr(0,k.length-1);
            }
            print("DEFINE_KIND(k_"+k+");\n");
        }
        print("\n");
    }

    public function _constant( name:String, type:String, value:String ) : Void {
    }

    public function _func( name:String, type:String, args:Array<Array<String>> ) : Void {
        print( "value _" + name + "(" );
        
        argList( args, argFuncDecl );
        
        print( " ) {\n");
        
        print("\tvalue v_result = val_null;\n");
        
        
        argList( args, argLocal );
        
        
        var kind:String = map.kind(type);
        if( kind!=null ) {
            print("\tv_result = (value)ALLOC_KIND(k_"+kind+","+name+"(");
            argList( args, argCall );
            print("));\n");
        } else {
            print("\t");
            if( type != "void" ) print( type+" c_result = " );
            print( name+"(");
            argList( args, argCall );
            print(");\n");
            print("\tv_result = (value)ALLOC_"+map.map(type)+"(c_result);\n\treturn v_result;\n");
        }
        
        print( "}\n");
        
        var n:Int=args.length;
        print( "DEFINE_PRIM(_"+name+","+n+");\n\n");
    }
    
    public function argFuncDecl( type:String, name:String, last:Bool ) {
        print( " value v_"+name );
        if( !last ) print(",");
    }

    public function argCall( type:String, name:String, last:Bool ) {
        print( " c_"+name );
        if( !last ) print(",");
    }

    public function argLocal( type:String, name:String, last:Bool ) {
        var kind:String = map.kind(type);
        if( kind!=null ) {
            print( "\tCHECK_KIND(v_"+name+",k_"+kind+",\""+name+"\");\n" );
            print( "\t"+type+" c_"+name+" = ("+type+")VAL_KIND(v_"+name+",k_"+kind+");\n" );
        } else {
            var nekotype = map.map(type);
            print( "\tCHECK_"+nekotype+"(v_"+name+",\""+name+"\");\n");
            print( "\t"+type+" c_"+name+" = VAL_" +nekotype+"(v_"+name+");\n" );
        }
    }
}
