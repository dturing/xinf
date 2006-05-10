package org.xinf.style;

import org.xinf.ony.StyledElement;

class StyleChain extends Style {
    private var chain:List<Style>;
    private var element:StyledElement;

    public function new( e:StyledElement ) {
        chain = new List<Style>();
        element = e;
        super();
    }
        
    public function pushStyle( style:Style ) :Void {
        chain.push( style );
    }

    public function popStyle() :Style {
        return( chain.pop() );
    }
    
    public function setChain( l:List<Style> ) :Void {
        chain = l;
    }
    
    public function _lookup( attr:String ) : Dynamic {
        
        var r:Dynamic = super._lookup(attr);
        if( r != null ) return(r);
        
        for( style in chain ) {
            r = style._lookup(attr);
            if( r != null ) return(r);
        }
        
        if( Style.DEFAULT != null ) {
            r = Style.DEFAULT._lookup(attr);
            if( r != null ) return(r);
        }
        
        throw("Style attribute '"+attr+"' not found.");
    }
}
