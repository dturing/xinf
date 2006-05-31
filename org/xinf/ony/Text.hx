package org.xinf.ony;

import org.xinf.geom.Point;
import org.xinf.ony.impl.ITextPrimitive;
import org.xinf.ony.impl.IPrimitive;
import org.xinf.ony.impl.Primitives;

import org.xinf.value.Value;
import org.xinf.value.Expression;
import org.xinf.value.ValueMonitor;

import org.xinf.event.Event;

class Text extends Pane {
    public property text( getText, setText ) :String;
    private var _text:String;
    
    private var width:Value<Float>;
    private var height:Value<Float>;
    private var wMon:ValueMonitor;
    private var hMon:ValueMonitor;
    
    public property autoSize( default, default ) :Bool;
    
    private var _t:ITextPrimitive;
    
    public function new( name:String ) {
        super(name);
        autoSize = true;
        
        // autosize stuff..
        width = new Value<Float>();
        width.value = 0;
        height = new Value<Float>();
        height.value = 0;
        
        wMon = new ValueMonitor( new Sum( [ 
                                width, 
                                style.getLink("borderWidth"),   // FIXME: multiply*2!
                                style.getLink("borderWidth"),   //
                                style.getLink("marginLeft"), 
                                style.getLink("marginRight"),
                                style.getLink("paddingLeft"), 
                                style.getLink("paddingRight") 
                            ] ), null, bounds, "width" );
        hMon = new ValueMonitor( new Sum( [ 
                                height, 
                                style.getLink("borderWidth"),   // FIXME: multiply*2!
                                style.getLink("borderWidth"),   //
                                style.getLink("marginTop"), 
                                style.getLink("marginBottom"),
                                style.getLink("paddingTop"), 
                                style.getLink("paddingBottom") 
                            ] ), null, bounds, "height" );
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
        width.value = Math.round(s.x);
        height.value = Math.round(s.y);
    }
}
