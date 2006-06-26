package nekobind;

class NativeType extends PrimitiveType {
    public function new( type:String ) {
        super( "value", "Dynamic" );
    }
    
    override public function check( name:String ) : String {
        return("");
    }
    
    override public function toC( name:String ) : String {
        return( name );
    }

    override public function toHx( name:String ) : String {
        return( name );
    }
}
