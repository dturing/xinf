package org.xinf.style;

class StyleChain extends Style {
    private var chain:List<Style>;
    private var element:StyledObject;
    private var cache :Hash<Dynamic>;

    public function new( e:StyledObject ) :Void {
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
        clearCache();
    }
    
    public function _lookup( attr:String ) :Dynamic {
        
        var r:Dynamic = cache.get(attr);
        if( r == null ) {
            r = super._lookup(attr);
        
            var i = chain.iterator();
            while( r == null && i.hasNext() ) {
                var style = i.next();
                r = style._lookup(attr);
            }
            if( r == null && Style.DEFAULT != null ) {
                r = Style.DEFAULT._lookup(attr);
            }
            if( r == null ) {
                throw("Style attribute '"+attr+"' not found.");
            }
//            cache.set(attr, r.identity());   
        }
        return r;
    }
    
    public function clearCache() :Void {
        cache = new Hash<Dynamic>();
    }

}
