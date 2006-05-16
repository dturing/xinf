package org.xinf.style;

import org.xinf.style.Style;
import org.xinf.value.Value;

class CachedStyle extends Style {
    private var cache :PropertySet;
    
    public function new() :Void {
        super();
        cache = new PropertySet();
    }

    public function _lookup( name:String ) :ValueBase {
        return null;
    }
    
    public function get( name:String ) :ValueBase {
        var p:ValueBase = cache.get(name);
        trace("CACHE: "+name+" in cache: "+p );
        if( p != null ) return p;
        
        p = getNoCache(name);

        if( p != null ) {
            // add Identity link to cache...
            p = p.identity();
         //   trace("CACHE: cacheing "+name+": "+p );
            cache.set( name, p );
        }
        return p;
    }
    public function getNoCache( name:String ) :ValueBase {
        var p:ValueBase = super.get(name);
        //trace("CACHE: "+name+" in self: "+p );
        
        if( p == null ) {
            p = _lookup(name);
        //    trace("CACHE: "+name+" lookup: "+p );
        }
        
        return p;
    }
    public function getLink( name:String ) :ValueBase {
        var p:ValueBase = get(name);
//        trace("CREATE cache "+name+" "+p );
        if( p == null ) {
            p = Properties.create( name, this ).identity();
            cache.set(name,p);
        }
        return p;
    }
    
    public function reCache() :Void {
        // cache consists of solely Identites (which might be monitored), we update those.
        var p:ValueBase;
        for( name in cache.keys() ) {
            var i:Dynamic = cache.get(name);
            p = getNoCache( name );
            if( p == null ) throw("Could not find Property '"+name+"' to re-cache.");
//            trace("reCache "+name+": "+p );
            untyped i.setLink( p );
        }
    }
    
    public function toString() :String {
        return( "CachedStyle" );
    }
}

class StyleChain extends CachedStyle {
    private var chain:Array<PropertySet>;
    private var object:StyledObject;
    
    public function new( o:StyledObject ) {
        super();
        object = o;
        chain = new Array<PropertySet>();
    }

    public function _lookup( name:String ) :ValueBase {
        var p:ValueBase;
        for( style in chain ) {
            p = style.get( name );
            if( p != null ) return p;
        }
        return p;
    }

    public function setChain( l:Array<PropertySet> ) :Void {
        chain = l;
        reCache();
    }
    
    public function toString() :String {
        return( "StyleChain of "+object );
    }
}
