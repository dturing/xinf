package nekobind;

class UnknownType extends PrimitiveType {
    public function new( type:String ) {
        super( type, "Dynamic" );
    }
}
