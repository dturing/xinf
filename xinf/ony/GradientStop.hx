/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

import xinf.style.StyledElement;

import xinf.type.Paint;
import xinf.type.Color;

import xinf.traits.FloatTrait;
import xinf.traits.BoundedFloatTrait;
import xinf.traits.PaintTrait;
import xinf.traits.LengthTrait;
import xinf.type.Length;

class GradientStop extends StyledElement {
	static var TRAITS = {
		offset:new LengthTrait(),
		stop_opacity:new BoundedFloatTrait(0,1,1),
		stop_color:new PaintTrait(),
	};

    public var stopOpacity(get_stop_opacity,set_stop_opacity):Null<Float>;
    function get_stop_opacity() :Null<Float> { return getStyleTrait("stop-opacity",Float,false); }
    function set_stop_opacity( v:Null<Float> ) :Null<Float> { return setStyleTrait("stop-opacity",v); }

    public var stopColor(get_stop_color,set_stop_color):Paint;
    function get_stop_color() :Paint { return getStyleTrait("stop-color",Paint,false); }
    function set_stop_color( v:Paint ) :Paint { return setStyleTrait("stop-color",v); }

	public var offset :Float;
	public var color :Color;

	public function new( ?traits:Dynamic ) :Void {
		super(traits);
		color = Color.rgba(0,0,0,0);
	}

	override public function fromXml( xml:Xml ) :Void {
		super.fromXml(xml);
		
		offset = getTrait("offset", Length ).value;
		
		if( stopColor!=null ) {
			switch( stopColor ) {
				case SolidColor(r,g,b,a):
					color = Color.rgba(r,g,b,a);
					color.a = stopOpacity;
				default:
					throw("GradientStop stop-color must be a SolidColor");
			}
		}
		
	}
	
}
