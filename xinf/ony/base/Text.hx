package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;

class Text extends ElementImpl {

	static var TRAITS:Hash<TraitDefinition>;
	static function __init__() {
		TRAITS = new Hash<TraitDefinition>();
		for( trait in [
			new FloatTrait("x",0.),
			new FloatTrait("y",0.),
			new StringTrait("text"),
		] ) { TRAITS.set( trait.name, trait ); }
	}

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Float); }
    function set_x( v:Float ) :Float { redraw(); return setTrait("x",v); }
	
    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Float); }
    function set_y( v:Float ) :Float { redraw(); return setTrait("y",v); }

    public var text(get_text,set_text):String;
    function get_text() :String { return getTrait("text",String); }
    function set_text( v:String ) :String { redraw(); return setTrait("text",v); }

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
