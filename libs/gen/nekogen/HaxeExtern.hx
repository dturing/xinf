package nekogen;

class HaxeExtern extends Generator {
    public var module:String;

    public function new( mod:String ) {
        super(mod+".hx",mod);
        
        print("extern class "+module+" {\n");
    }

    public function finish() {
        print("
    public static function __init__() : Void {
        untyped {
        	var loader = untyped __dollar__loader;
            "+module+" = loader.loadmodule(\""+module+"__\".__s,loader)."+module+"__;
        }
    }\n");
            
        print("}\n");
        super.finish();
    }
    
    public function _constant( name:String, type:String, value:String ) : Void {
        print("\tpublic static var "+stripSymbol(name)+":"+map.map(type)+";\n");
    }

    public function _func( name:String, type:String, args:Array<Array<String>> ) : Void {
        print("\tpublic static function "+stripSymbol(name)+"( ");
        argList( args, argFuncDecl );
        print("):"+map.map(type)+";\n");
    }
    
    public function argFuncDecl( type:String, name:String, last:Bool ) {
        print( "_"+name+":"+map.map(type) );
        if( !last ) print(",");
        print(" ");
    }
}
