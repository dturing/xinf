package nekobind;

class NativeType extends PrimitiveType {
    public function new( type:String ) {
        super( "value", "Dynamic" );
    }
    
    public function check( name:String ) : String {
        return("");
    }
    
    public function toC( name:String ) : String {
        return( name );
    }

    public function toHx( name:String ) : String {
        return( name );
    }
}
