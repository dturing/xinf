package org.xinf.ony;

import org.xinf.geom.Point;
import org.xinf.event.Event;

class Text extends Element {
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
    
    public function new( name:String ) {
        super(name);
        autoSize = true;
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
            var e = flash.Lib._root.createEmptyMovieClip("FIXME",flash.Lib._root.getNextHighestDepth());
            
            e.createTextField("_xinfonyText",flash.Lib._root.getNextHighestDepth(), 0, 0, 100, 100 );
            _t = e._xinfonyText;
            
            _t.autoSize = true;
            
            var format:flash.TextFormat = new flash.TextFormat();
            format.size = 12;
            format.font = "Bitstream Vera Sans";
            _t.setNewTextFormat( format );

            _t.background = true;
            _t.backgroundColor = 0xff0000;            
        #end
        
        return _t;
    }
    
    private function setText( t:String ) :String {
        #if neko
            _t.text = t;
        #else js
            untyped _t.innerHTML = t.split("\n").join("<br/>");
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
//        bounds.width = Math.round(s.x);
//        bounds.height = Math.round(s.y);
    }
}
