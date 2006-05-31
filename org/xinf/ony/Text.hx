package org.xinf.ony;

import org.xinf.geom.Point;
import org.xinf.ony.impl.ITextPrimitive;
import org.xinf.ony.impl.IPrimitive;
import org.xinf.ony.impl.Primitives;

import org.xinf.event.Event;

class Text extends Pane {
    public property text( getText, setText ) :String;
    private var _text:String;
    
    public property autoSize( default, default ) :Bool;
    private var width:Int;
    private var height:Int;
    
    private var _t:ITextPrimitive;
    
    public function new( name:String ) {
        super(name);
        autoSize = true;
    }
    
    private function createPrimitive() :IPrimitive {
        _t = Primitives.createText();
        return( _t );
    }
    
    private function setText( t:String ) :String {
        _text = t;
        _t.setText( text );
        if( autoSize ) calcSize();
        return _text;
    }
    private function getText() :String {
        return _text;
    }
    
    private function calcSize() :Void {
        var s:Point = _t.getTextExtends();
        width = Math.round(s.x);
        height = Math.round(s.y);
    }
}
