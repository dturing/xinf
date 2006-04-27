package nekobind;

interface IType {
    public function cCacheReturn( call:String ) : String;
    public function cReturn() : String;
    public function cLocal( name:String ) : String;
    public function cArg( name:String ) : String;
    public function cCallArg( name:String ) : String;
    public function cFunc( name:String ) : String;
    public function check( name:String ) : String;
    public function sizeof() : String;
    public function cPrimitive() : String;
    public function kPrimitive() : String;
    public function defines( kinds:Hash<String> ):String;
    
    public function setMember( o:String, name:String, val:String ):String;
    public function returnMember( o:String, name:String ):String;
    
    public function hxType() : String;
}

