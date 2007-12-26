/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.traits.TraitDefinition;
import xinf.traits.StringTrait;
import xinf.ony.traits.LengthTrait;
import xinf.ony.type.Length;

class Text extends ElementImpl {

	static var tagName = "text";

	static var TRAITS = {
		x:new LengthTrait(),
		y:new LengthTrait(),
		text:new StringTrait(), // FIXME uDOM: "#text"?
	}

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Length).value; }
    function set_x( v:Float ) :Float { setTrait("x",new Length(v)); redraw(); return v; }

    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Length).value; }
    function set_y( v:Float ) :Float { setTrait("y",new Length(v)); redraw(); return v; }

    public var text(get_text,set_text):String;
    function get_text() :String { return getTrait("text",String); }
    function set_text( v:String ) :String { redraw(); return setTrait("text",v); }

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties(to);
		to.x=x; to.y=y; 
		to.text=text;
	}

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        text = textContent(xml);
    }

/* helpers *******************/

    function textContent( xml:Xml ) :String {
        var text = "";
        for( child in xml ) {
            switch( child.nodeType ) {
                case Xml.PCData:
                    text+=child.nodeValue;
                case Xml.Element:
                    text+=textContent(child)+"\n";
                default:
            }
        }
        return xmlUnescape(StringTools.trim( text ));
    }
    
	/**
		Unescape XML special characters of the string.
	**/
	public static function xmlUnescape( s : String ) : String {
		return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&").split("&quot;").join("\"");
	}

}
