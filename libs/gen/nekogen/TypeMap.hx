package nekogen;

class TypeMap {
    public var buf:String;
    public var typedefs:Hash<String>;
    public var typemaps:Hash<String>;
    public var kinds:Hash<Bool>;
    
    public function new( kindsFile:String ) {
        typedefs = new Hash<String>();
        typemaps = new Hash<String>();
        kinds = new Hash<Bool>();
        
        setMaps( "
float,double : Float
int,unsigned int,short,unsigned short,char,unsigned char,signed char : Int
unsigned char*,const unsigned char* : String
void : Void
");
        try {
            setKinds( neko.File.getContent( kindsFile ).split("\n") );
        } catch(e:Dynamic) {
        }
    }
    
    public function setKinds( k:Array<String> ) {
        for( kind in k ) {
            if( kind != null && kind.length>0 ) {
                kinds.set( kind, true );
            }
        }
    }
    public function getKinds():Iterator<String> {
        return( kinds.keys() );
    }
    
    public function setMaps( maps:String ) {
        var file = maps.split("\n");
        for( line in file ) {
            if( line.length > 0 ) {
                var l = line.split(" : ");
                for( type in l[0].split(",") ) {
                    typemaps.set( type, l[1] );
                }
            }
        }
        
        
    }
   
    public function addTypedef( t:String, final:String ) : Void {
        trace("typedef "+t+" "+getFinalType(final) );
        typedefs.set( t, getFinalType(final) );
    }
    
    public function getFinalType( t:String ) : String {
        var u:String = typedefs.get(t);
        if( u != null ) return u;
        
        // unmangle pointers
        var ts:Array<String> = t.split(".");
        if( ts.length > 1 ) {
            var const=false;
            var ptr=false;
            var name="";
            for( item in ts ) {
                if( item == "p" ) ptr=true;
                else if( item == "q(const)" ) ptr=const=true;
                else name=item;
            }
            
            var t = "";
            if( const ) t+="const ";
            t += getFinalType(name);
            if( ptr ) t+="*";
            return t;
        }
        
        return t;
    }
    
    public function map( t:String ) : String {
        var final = getFinalType(t);
        var mapped = typemaps.get(final);
        if( mapped != null ) return mapped;
        else {
            trace("no type for "+final+" - use dynamic");
            return("Dynamic_"+t);
        }
    }
    
    public function kind( k:String ) : String {
        /* remove struct and * */
            if( k.charAt(k.length-1) == "*" ) {
                k = k.substr(0,k.length-1)+"_p";
            }
            if( k.substr(0,6) == "struct" ) {
                k = k.substr(7,k.length);
            }
        trace("KIND? "+k+" "+kinds.get(k) );
        if(kinds.get(k)) return k;
        return null;
    }
}
