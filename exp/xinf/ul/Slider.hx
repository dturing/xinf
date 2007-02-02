/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ul;

import xinf.ony.Object;
import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.ScrollEvent;
import xinf.ul.Drag;
import xinf.ul.Popup;
import xinf.ul.FocusManager;

/**
    Slider (numeric entry) element.
**/

class Slider extends Widget {
    
    private var slideBar:ComponentContainer;
    private var slideThumb:Pane;
    private var label:Label;
    private var button:Component;
    private var popup:Popup;
    
    public var precision:Float;
    public var min:Float;
    public var max:Float;
    public var increment:Float;
    
    private var _value:Float;
    public var value(get_value,set_value):Float;
    
    public function get_value() :Float {
        return _value;
    }
    
    public function set_value( v:Float ) :Float {
        var old = _value;
        _value = v - (v-(Math.round(v/increment)*increment));
        if( _value > max ) _value=max;
        if( _value < min ) _value=min;
        if( _value != old ) {
            label.text = ""+Math.floor( precision*_value )/precision;
            postEvent( new ValueEvent<Float>( ValueEvent.VALUE, _value ) );
        }
        return _value;
    }
    
    public function get_normalized() :Float {
        return (_value-min)/(max-min);
    }
    
    public function set_normalized( v:Float ) :Float {
        if( v<.0 ) v=.0; else if( v>1. ) v=1.;
        value = min + (v*(max-min));
        return v;
    }
    
    public function new( ?max:Float, ?min:Float, ?increment:Float ) :Void {
        super();
        precision=1000; this.min=0; this.max=1; this.increment=.1;
        if( min!=null ) this.min = min;
        if( max!=null ) this.max = max;
        if( increment!=null ) this.increment = increment;
    
        label = new xinf.ul.Label();
        label.moveTo( 1, 1 );
        attach( label );
        // FIXME: image should be part of the style.
        button = new Pane(); //new ImageButton(name+"_btn", this, "assets/slider/icon.png" ) );
        button.addStyleClass("Thumb");
        attach( button );
        
        slideBar = new Pane();//Image(name+"_slide", this, "assets/slider/bg.png");
        slideBar.addStyleClass("SliderBar");

        slideThumb = new Pane(); //new xinf.ony.Image(name+"_thumb", this, "assets/slider/handle.png");
        slideThumb.moveTo( 6, 1 );
        slideThumb.resize( 7, 2 );
        slideThumb.addStyleClass("Thumb");
        slideBar.attach( slideThumb );

        value = .0;

        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        addEventListener( ScrollEvent.SCROLL_STEP, scrollStep );
    }
    
    public function resize( x:Float, y:Float ) :Void {
        super.resize(x,y);
        button.resize( size.y, size.y );
        button.moveTo( size.x-size.y, 0 );
        
        slideBar.resize( size.y, 112 );
    }
    
    private function onMouseDown( e:MouseEvent ) {
        FocusManager.setFocus(this);
        
        var y = -(100-(get_normalized()*100));
        var p = localToGlobal( {x:button.position.x, y:y } );
        var t = (104-(get_normalized()*100));
        trace("e: "+e.y+", p: "+p.y+", t:"+t );
        slideThumb.moveTo( 6, t );
        slideBar.moveTo( p.x, (p.y-(100-t)) ); //position.x+button.position.x, -3+position.y+y );
        
        popup = new Popup(this,slideBar,Move);
        
        new Drag<Float>( e, sliderMoved, sliderEnd, get_normalized() );
    }

    private function scrollStep( e:ScrollEvent ) :Void {
        value -= e.value*increment;
    }

    public function sliderMoved( x:Float, y:Float, marker:Float ) :Void {
        set_normalized( (marker + ((y)/-100)) );
        slideThumb.moveTo( 6, (104-(get_normalized()*100)) );
    }

    public function sliderEnd() :Void {
        popup.close();
    }
            
    private function onKeyDown( e:KeyboardEvent ) {
        switch( e.key ) {
            case "up":
                value += increment;
            case "down":
                value -= increment;
        }
    }
    
    public static function createControl( o:Dynamic, field:String, min:Float, max:Float, increment:Float ) :Slider {
        var s = new Slider( max, min, increment );
        s.addEventListener( ValueEvent.VALUE, function( e ) {
                Reflect.setField(o,field,e.value);
            });
        return s;
    }

    public static function createFunctionControl( f:Float->Void, min:Float, max:Float, increment:Float ) :Slider {
        var s = new Slider( max, min, increment );
        s.addEventListener( ValueEvent.VALUE, function( e ) {
                f(e.value);
            });
        return s;
    }
    
}
