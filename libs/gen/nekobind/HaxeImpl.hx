package nekobind;

class HaxeImpl extends Generator {
    public function new( mod:String ) {
        super(mod+"__.hx",mod);
        
        print("class "+module+"__ extends "+module+" {\n");
    }
    
    override public function finish() {
        print("
    public static function __init__() : Void {
        untyped {
            untyped __dollar__exports."+module+"__ = "+module+"__;
        }
    }\n");
    
        print("\tpublic static function main() :Void {\n\t\ttrace(\"this is 'implementation' class of the '"+module+"' binding.\");\n\t}\n");
            
        print("}\n");
        super.finish();
    }
    
    override public function _constant( name:String, type:String, value:String ) : Void {
        print("\tpublic static var "+stripSymbol(name)+":"+map.get(type).hxType()+" = "+stripCode(value)+";\n");
    }

    override public function _func( name:String, type:String, args:Array<Array<String>> ) : Void {
        if( args.length <= 5 ) {
            print("\tpublic static var "+stripSymbol(name) );
            print(" = neko.Lib.load(\""+module+"\",\"neko_"+name+"\","+args.length+");\n");
        } else {
            print("\t// "+name+" not wrapped because it has > 5 arguments :/\n");
        }
    }
    

    override public function _classDefinition( name:String, members:Array<Array<String>> ) : Void {
        var p:IType = WrappedType.make(name.split("."),map);
        map.addType( name, p );
        
        var t:IType = new WrappedType(false,p,1);
        map.addType( name+"_p", t );
        
        for( member in members ) {
            memberAccessors( t, name, member[0], member[1] );
        }
    }
    
    private function memberAccessors( classType:IType, className:String, name:String, type:String ) {
        print("\tpublic static var "+stripSymbol(className)+"_"+name+"_set");
        print(" = neko.Lib.load(\""+module+"\",\"_"+className+"_"+name+"_set\",2);\n");
        print("\tpublic static var "+stripSymbol(className)+"_"+name+"_get");
        print(" = neko.Lib.load(\""+module+"\",\"_"+className+"_"+name+"_get\",1);\n");
    }
}
