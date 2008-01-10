/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.traits.TraitDefinition;
import xinf.traits.StringTrait;
import xinf.traits.EnumTrait;
import xinf.ony.traits.LengthTrait;
import xinf.ony.traits.LineIncrementTrait;
import xinf.ony.type.Length;
import xinf.ony.type.Editability;

class TextArea extends ElementImpl {

	static var tagName = "textArea";

	static var TRAITS = {
		x:new LengthTrait(),
		y:new LengthTrait(),
		width:new LengthTrait(),
		height:new LengthTrait(),
		text:new StringTrait(), // FIXME uDOM: "#text"?
		editable:new EnumTrait<Editability>( Editability, "", Editability.None ),
		line_increment:new LineIncrementTrait(),
	}

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

    public var text(get_text,set_text):String;
    function get_text() :String { return getTrait("text",String); }
    function set_text( v:String ) :String { redraw(); return setTrait("text",v); }

    public var editable(get_editable,set_editable):Editability;
    function get_editable() :Editability { return getTrait("editable",Editability); }
    function set_editable( v:Editability ) :Editability { return setTrait("editable",v); }

    public var lineIncrement(get_line_increment,set_line_increment):Float;
    function get_line_increment() :Float { 
		var r:Float = getTrait("line-increment",Float);
		if( r==-1 ) // auto
			r = fontSize*1.1;
		return r; 
	}
    function set_line_increment( v:Float ) :Float { setTrait("line-increment",v); redraw(); return v; }

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties(to);
		to.x=x; to.y=y; 
		to.text=text;
	}

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        text = textContent(xml);
    }
	
	public function focus( ?focus:Bool ) :Void {
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
