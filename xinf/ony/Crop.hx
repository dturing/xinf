/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;

// FIXME: not SVG.
class Crop extends GroupImpl {

	static var TRAITS = {
		width:new FloatTrait(),
		height:new FloatTrait(),
	};

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Float); }
    function set_width( v:Float ) :Float { redraw(); return setTrait("width",v); }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Float); }
    function set_height( v:Float ) :Float { redraw(); return setTrait("height",v); }

}