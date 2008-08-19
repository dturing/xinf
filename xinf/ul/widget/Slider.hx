/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.ul.Drag;
import xinf.ul.Popup;
import xinf.ul.FocusManager;
import xinf.ul.Container;
import xinf.ul.layout.Helper;
import xinf.ul.ValueEvent;

/**
	Slider (numeric entry) element.
**/

class Slider extends ValueWidget<Float> {
	
	private var slideBar:Container;
	private var slideThumb:Container;
	private var textElement:Text;
	private var button:Rectangle;
	private var popup:Popup;
	
	public var precision:Float;
	public var min:Float;
	public var max:Float;
	public var increment:Float;
	
	override function set_value( _v:Float ) :Float {
		var v = super.set_value( Math.max(min,Math.min(max, 
				_v - (_v-(Math.round(_v/increment)*increment))
			)));
		textElement.text = ""+Math.floor( precision*v )/precision;
		return v;
	}
	
	public function get_normalized() :Float {
		return (_value-min)/(max-min);
	}
	
	public function set_normalized( v:Float ) :Float {
		if( v<.0 ) v=.0; else if( v>1. ) v=1.;
		value = min + (v*(max-min));
		return v;
	}
	
	public function new( ?min:Float, ?max:Float, ?increment:Float, ?initial:Float ) :Void {
		textElement = new Text();
		super();
		precision=1000; this.min=0; this.max=1; this.increment=.1;
		if( min!=null ) this.min = min;
		if( max!=null ) this.max = max;
		if( increment!=null ) this.increment = increment;
		else increment=(this.max-this.min)/100;

		if( initial==0 || initial==null ) initial=0.;
		value = initial;
	
		group.appendChild( textElement );
	
		button = new Rectangle();
		group.appendChild( button );
		
		slideBar = new Container();
		slideBar.addStyleClass("SliderBar");

		slideThumb = new Container();
		slideThumb.addStyleClass("SliderThumb");
		slideThumb.position = { x:0., y:1. };
		slideBar.appendChild( slideThumb );

		group.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		group.addEventListener( ScrollEvent.SCROLL_STEP, scrollStep );
		
		styleChanged();
	}

	override public function set_size( s:TPoint ) :TPoint {
		textElement.y = Helper.topOffsetAligned( this, s.y, .5 )+textElement.fontSize;
		textElement.x = Helper.leftOffsetAligned( this, s.x, horizontalAlign );
		
		button.x = s.x-s.y;
		button.width = button.height = s.y;

		slideBar.size = { x:s.y, y:100+s.y };
		slideThumb.size = { x:s.y, y:s.y };

		return super.set_size(s);
	}

	override public function styleChanged( ?attr:String ) {
		super.styleChanged(attr);
		
		if( textElement.text!=null ) {
			var s = Helper.addPadding( getTextFormat().textSize(textElement.text), this );
			s.x += s.y; // add button.width==height
			setPrefSize( s );
		}
	}

	private function onMouseDown( e:MouseEvent ) {
//		FocusManager.setFocus(this);
		
		var y = -(100-(get_normalized()*100));
		var p = group.localToGlobal( {x:button.x, y:0. } );
		var effectiveH = slideBar.size.y - slideThumb.size.y;
		var t = (effectiveH-(get_normalized()*100));
		slideThumb.position = { x:0., y:t };
		slideBar.position = { x:p.x, y:(p.y-(t)) };
		
		popup = new Popup(this,slideBar,Move);
		
		new Drag<Float>( e, sliderMoved, sliderEnd, get_normalized() );
	}

	private function scrollStep( e:ScrollEvent ) :Void {
		value -= e.value*increment;
	}

	public function sliderMoved( x:Float, y:Float, marker:Float ) :Void {
		set_normalized( (marker + ((y)/-100)) );
		var effectiveH = slideBar.size.y - slideThumb.size.y;
		slideThumb.position = { x:0., y:(effectiveH-(get_normalized()*100)) };
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
				f(untyped e.value); // FIXME
			});
		return s;
	}
	
}
