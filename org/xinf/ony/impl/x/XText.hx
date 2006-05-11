package org.xinf.ony.impl.x;

import org.xinf.ony.impl.ITextPrimitive;
import org.xinf.geom.Point;

class XText implements ITextPrimitive, extends XPrimitive  {
    private var _t:org.xinf.inity.Text;
    
    public function new() :Void {
        _t = new org.xinf.inity.Text();
        super( _t );
        _e.changed();
    }
    
    public function setText( text:String ) :Void {
        _t.text = text;
        _e.changed();
    }

    public function getTextExtends() :Point {
        return( _t.getTextExtends() );
    }
}
