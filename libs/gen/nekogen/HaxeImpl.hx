package nekogen;

class HaxeImpl extends Generator {
    public function new( mod:String ) {
        super(mod+"__.hx",mod);
        
        print("class "+module+"__ extends "+module+" {\n");
    }

    public function finish() {
        print("
    public static function __init__() : Void {
        untyped {
            untyped __dollar__exports."+module+"__ = "+module+"__;
        }
    }\n");
            
        print("}\n");
        super.finish();
    }
    
    public function _constant( name:String, type:String, value:String ) : Void {
        print("\tpublic static var "+stripSymbol(name)+":"+map.map(type)+" = "+value+";\n");
    }

    public function _func( name:String, type:String, args:Array<Array<String>> ) : Void {
        if( args.length <= 5 ) {
            print("\tpublic static var "+stripSymbol(name) );
            print(" = neko.Lib.load(\""+module+"\",\"_"+name+"\","+args.length+");\n");
        } else {
            print("\t// "+name+" not wrapped because it has > 5 arguments :/\n");
        }
    }
}
