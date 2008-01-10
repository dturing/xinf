/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.ony.type.Length;
import xinf.ony.type.PreserveAspectRatio;

import xinf.traits.TraitDefinition;
import xinf.traits.StringTrait;
import xinf.ony.traits.LengthTrait;
import xinf.ony.traits.PreserveAspectRatioTrait;

class Image extends ElementImpl {

	static var tagName = "image";

	static var TRAITS = {
		x:new LengthTrait(),
		y:new LengthTrait(),
		width:new LengthTrait(),
		height:new LengthTrait(),
		href:new StringTrait(), // FIXME proper namespaces
		
		preserveAspectRatio: new PreserveAspectRatioTrait( PreserveAspectRatio.None ),
	};

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Length).value; }
    function set_x( v:Float ) :Float { setTrait("x",new Length(v)); redraw(); return v; }

    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Length).value; }
    function set_y( v:Float ) :Float { setTrait("y",new Length(v)); redraw(); return v; }

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Length).value; }
    function set_width( v:Float ) :Float { setTrait("width",new Length(v)); redraw(); return v; }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Length).value; }
    function set_height( v:Float ) :Float { setTrait("height",new Length(v)); redraw(); return v; }
	
    public var href(get_href,set_href):String; // TODO xlink namespace
    function get_href() :String { return getTrait("href",String); }
    function set_href( v:String ) :String { return setTrait("href",v); }

    public var preserveAspectRatio(get_preserveAspectRatio,set_preserveAspectRatio):PreserveAspectRatio;
    function get_preserveAspectRatio() :PreserveAspectRatio { return getStyleTrait("preserveAspectRatio",PreserveAspectRatio); }
    function set_preserveAspectRatio( v:PreserveAspectRatio ) :PreserveAspectRatio { return setStyleTrait("preserveAspectRatio",v); }

}
