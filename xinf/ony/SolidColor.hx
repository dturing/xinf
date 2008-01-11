/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.ony.type.Paint;
import xinf.traits.BoundedFloatTrait;
import xinf.ony.traits.PaintTrait;

class SolidColor extends ElementImpl {

	static var TRAITS = {
		solid_opacity:		new BoundedFloatTrait(0,1,1),
		solid_color:		new PaintTrait(Paint.None),
	}

    public var solidOpacity(get_solid_opacity,set_solid_opacity):Null<Float>;
    function get_solid_opacity() :Null<Float> { return getStyleTrait("solid-opacity",Float); }
    function set_solid_opacity( v:Null<Float> ) :Null<Float> { return setStyleTrait("solid-opacity",v); }

    public var solidColor(get_solid_color,set_solid_color):Paint;
    function get_solid_color() :Paint { return getStyleTrait("solid-color",Paint); }
    function set_solid_color( v:Paint ) :Paint{ return setStyleTrait("solid-color",v); }
	
}