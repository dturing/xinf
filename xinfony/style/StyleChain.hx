package xinfony.style;

class StyleChain extends Style {
    private var chain:List<Style>;

    public function new( str:String ) {
        chain = new List<Style>();
        super("");
        pushStyle( Style.DEFAULT );
        pushStyle( new Style(str) );
    }
    
    public function clone() :Dynamic {
        var s:StyleChain = new StyleChain( this.toString() );
        for( style in chain ) {
            s.pushStyle( style );
        }
        return s;
    }
    
    public function pushStyle( style:Style ) :Void {
        chain.push( style );
    }

    public function popStyle() :Style {
        return( chain.pop() );
    }
    
    public function _lookup( attr:String ) : Dynamic {
        
        var r:Dynamic = super._lookup(attr);
        if( r != null ) {
            return r;
        }
        
        for( style in chain ) {
            r = style._lookup(attr);
            if( r != null ) {
                return r;
            }
        }
        
        throw("Style attribute '"+attr+"' not found in chain.");
    }

    public static var DEFAULT = new StyleChain("background: #faa;");
}
