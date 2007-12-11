package xinf.ony.base;
import xinf.ony.base.Implementation;

class Text extends ElementImpl {

    public var text(default,set_text):String;
    public var x(default,set_x):Float;
    public var y(default,set_y):Float;

    function set_x(v:Float) {
        x=v; redraw(); return x;
    }
    function set_y(v:Float) {
        y=v; redraw(); return y;
    }
    function set_text( t:String ) :String {
        text=t; redraw(); return text;
    }

	public function new() :Void {
		super();
		x=y=0;
	}

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties(to);
		to.x=x; to.y=y; 
		to.text=text;
	}

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x = getFloatProperty(xml,"x");
        y = getFloatProperty(xml,"y");
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
