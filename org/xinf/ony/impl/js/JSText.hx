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

    public function applyStyle( _style:org.xinf.style.Style ) :Void {
        super.applyStyle(_style);
//        if( autoSize ) { // FIXME
            _e.style.width = null;
            _e.style.height = null;
//        }
    }
    
    public function setText( text:String ) :Void {
        untyped _e.innerHTML = text.split("\n").join("<br/>");
    }

    public function getTextExtends() :Point {
        return( new Point(50,50) ); // FIXME
    }
}
