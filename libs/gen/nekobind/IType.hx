package nekobind;

interface IType {
    public function cCacheReturn( call:String ) : String;
    public function cReturn() : String;
    public function cLocal( name:String ) : String;
    public function cArg( name:String ) : String;
    public function cCallArg( name:String ) : String;
    public function cFunc( name:String ) : String;
    public function check( name:String ) : String;
    public function cPrimitive() : String;
    public function defines( kinds:Hash<String> ):String;
    
    public function hxType() : String;
}

