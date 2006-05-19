package org.xinf.ony.impl.js;

import org.xinf.ony.impl.ITextPrimitive;
import org.xinf.geom.Point;

class JSText extends JSPane, implements ITextPrimitive  {
    public function new() :Void {
        super();
        _e.style.cursor="default";
        _e.style.overflow="hidden";
        _e.style.whiteSpace="nowrap";
    }
    
    public function setText( text:String ) :Void {
        untyped _e.innerHTML = text.split("\n").join("<br/>");
    }

    public function getTextExtends() :Point {
        return( new Point(untyped _e.offsetWidth,untyped _e.offsetHeight) ); // FIXME
    }
}
