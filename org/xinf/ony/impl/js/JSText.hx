package org.xinf.ony.impl.js;

import js.HtmlDom;
import org.xinf.ony.impl.ITextPrimitive;
import org.xinf.geom.Point;
import org.xinf.event.Event;

class JSText extends JSPane, implements ITextPrimitive  {
    private var _t:HtmlDom;
    
    public function new() :Void {
        super();
        
        _t = js.Lib.document.createElement("span");
        untyped _t.className = "_text";
    //    _t.style.position="absolute";
        _t.style.cursor="default";
        _t.style.overflow="hidden";
        _t.style.whiteSpace="nowrap";
        _e.appendChild( _t );
    }
    
    public function setText( text:String ) :Void {
        untyped _t.innerHTML = text.split("\n").join("<br/>");
    }

    public function getTextExtends() :Point {
        trace("JSText::getTextExtends "+untyped _t.offsetWidth+"/"+untyped _t.offsetHeight );
        return( new Point(untyped _t.offsetWidth, untyped _t.offsetHeight) ); // FIXME
    }

}
