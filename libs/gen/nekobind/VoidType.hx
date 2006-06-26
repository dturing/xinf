package nekobind;

class VoidType extends PrimitiveType {
    public function new() {
        super( "void", "Void" );
    }
    
    override public function cCacheReturn( call:String ) : String {
        return("\t"+call+";\n" );
    }
    
    override public function cReturn() : String {
        return("\treturn val_true;\n");
    }
    
    override public function cLocal( name:String ) : String {
        return("");
    }
    
    override public function cArg( name:String ) : String {
        return("");
    }
    
    override public function cCallArg( name:String ) : String {
        return("");
    }
}
