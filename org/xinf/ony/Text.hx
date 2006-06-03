package org.xinf.ony;

import org.xinf.geom.Point;
import org.xinf.event.Event;

class Text extends Pane {
    public property text( getText, setText ) :String;
    
    public property autoSize( default, default ) :Bool;

    private var _t
        #if neko
            :org.xinf.inity.Text
        #else js
            :js.HtmlDom
        #else flash
            :flash.TextField
        #end
        ;
    
    public function new( name:String, parent:Element ) {
        super(name,parent);
        autoSize = true;

        #if js
            _p.style.background = "#f00";
        #end
    }
    
    private function createPrimitive() :Dynamic {
        _t =
            #if neko
                new org.xinf.inity.Text()
            #else js
                js.Lib.document.createElement("div")
            #else true
                null
            #end
            ;

        #if js
            _t.style.cursor = "default";
            _t.style.overflow = "hidden";
            _t.style.whiteSpace = "nowrap";
            _t.style.background="#f00";
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            var e = parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
            
            e.createTextField("_"+name, e.getNextHighestDepth(), 0, 0, 0, 0 );
            _t = Reflect.field( e, "_"+name );
            
            _t.autoSize = true;
            
            var format:flash.TextFormat = new flash.TextFormat();
            format.size = 12;
            format.font = "Bitstream Vera Sans";
            _t.setNewTextFormat( format );
            
            return e;         
        #end
        
        return _t;
    }
    
    private function setText( t:String ) :String {
        #if neko
            _t.text = t;
        #else js
            while( _t.firstChild != null ) _t.removeChild( _t.firstChild );
            var ta = t.split("\n");
            _t.appendChild( untyped js.Lib.document.createTextNode( ta.shift() ) );
            var ct = ta.shift();
            while( ct != null ) {
                _t.appendChild( js.Lib.document.createElement("br") );
                _t.appendChild( untyped js.Lib.document.createTextNode( ct ) );
                ct = ta.shift();
            }
        #else flash
            _t.text = t;
        #end
        
        if( autoSize ) calcSize();
        return getText();
    }
    private function getText() :String {
        #if neko
            return _t.text;
        #else js
            return untyped _t.innerHTML.split("<br/>").join("\n");
        #else flash
            return _t.text;
        #end
    }
    
    private function calcSize() :Void {
        var s:Point;
        #if neko
            s = _t.getTextExtends();
        #else js
            s = new Point(untyped _t.offsetWidth, untyped _t.offsetHeight);
        #else flash
            s = new Point( _t._width, _t._height );
        #end
        
        trace("text size: "+s );
        #if js
        #else true
            bounds.setSize( Math.round(s.x), Math.round(s.y) );
        #end
    }
}
