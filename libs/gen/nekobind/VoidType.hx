package nekobind;

class VoidType extends PrimitiveType {
    public function new() {
        super( "void", "Void" );
    }
    
    public function cCacheReturn( call:String ) : String {
        return("\t"+call+";\n" );
    }
    
    public function cReturn() : String {
        return("\treturn val_true;\n");
    }
    
    public function cLocal( name:String ) : String {
        return("");
    }
    
    public function cArg( name:String ) : String {
        return("");
    }
    
    public function cCallArg( name:String ) : String {
        return("");
    }
}
