/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

import xinf.style.StyledElement;


import xinf.traits.FloatTrait;
import xinf.traits.BoundedFloatTrait;
import xinf.ony.type.Paint;
import xinf.ony.type.Length;
import xinf.ony.traits.PaintTrait;
import xinf.ony.traits.LengthTrait;

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

	public var r :Float;
	public var g :Float;
	public var b :Float;
	public var a :Float;
	public var offset :Float;

	public function new( ?traits:Dynamic ) :Void {
		super(traits);
		r=g=b=a=0; offset=0;
	}

	override public function fromXml( xml:Xml ) :Void {
		super.fromXml(xml);
		
		offset = getTrait("offset", Length ).value;
		var o = stopOpacity;
		if( o==null ) o=1;
		
		if( stopColor!=null ) {
			switch( stopColor ) {
				case RGBColor(r,g,b):
					this.r=r; this.g=g; this.b=b; this.a=o;
				case None:
					this.r=this.g=this.b=this.a=0;
				default:
					// FIXME: could reference a SolidColor PaintServer...
					throw("GradientStop stop-color must be a SolidColor (is: "+stopColor+")");
			}
		}
		
	}
	
	override public function toString() :String {
		return("GradientStop("+r+","+g+","+b+","+a+")");
	}
	
}
