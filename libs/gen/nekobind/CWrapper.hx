package nekobind;

class CWrapper extends Generator {
    var _defines:String;
    var kinds:Hash<String>;

    public function new( module:String ) {
        super(module+"_wrap.c",module);
        
        _defines = neko.File.getContent("gen/C.runtime");
        kinds = new Hash<String>();
    }

    public function _constant( name:String, type:String, value:String ) : Void {
    }

    public function _func( name:String, type:String, args:Array<Array<String>> ) : Void {
        var t:IType = map.get(type);
        
        _defines += t.defines( kinds );
        _defines += argList( args, argDefines );
        
        print( t.cFunc("_"+name) + "( " + argList( args, argFuncDecl ) + ") {\n");
        
            print( argList( args, argCheck ) );
            print( argList( args, argLocal ) );
            print( t.cCacheReturn( name+"("+argList( args, argCall )+")" ) );
            print( t.cReturn() );
            
        print("}\n");

        var n:Int=args.length;
        print( "DEFINE_PRIM(_"+name+","+n+");\n\n");
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

    public function defines() : String {
        return(_defines+"\n\n");
    }
}
