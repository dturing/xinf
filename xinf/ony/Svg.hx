/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.ony.traits.LengthTrait;

import xinf.style.StyleSheet;
import xinf.ony.type.Length;

class Svg extends GroupImpl {

	static var TRAITS = {
		x:new FloatTrait(),
		y:new FloatTrait(),
		width:new LengthTrait(),
		height:new LengthTrait(),
	}

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Float); }
    function set_x( v:Float ) :Float { retransform(); return setTrait("x",v); }
	
    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Float); }
    function set_y( v:Float ) :Float { retransform(); return setTrait("y",v); }

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Length).value; }
    function set_width( v:Float ) :Float { setTrait("width",new Length(v)); return v; }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Length).value; }
    function set_height( v:Float ) :Float { setTrait("height",new Length(v)); return v; }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);

		// for now...
        if( xml.exists("viewBox") ) {
            var vb = xml.get("viewBox").split(" ");
            if( vb.length != 4 ) {
                throw("illegal/unsupported viewBox: "+vb );
            }
            width = Std.parseInt( vb[2] );
            height = Std.parseInt( vb[3] );
        }
    }

}