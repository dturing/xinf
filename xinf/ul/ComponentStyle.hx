
package xinf.ul;

import Xinf;
import xinf.style.InheritedStyle;
import xinf.style.StringList;
import xinf.style.StylePropertyDefinition;
import xinf.style.StyleParser;
import xinf.style.Stylable;
import xinf.style.Border;

class ComponentStyle extends InheritedStyle {

	public var skin(get_skin,set_skin):String;
    function get_skin() :String { return getInheritedProperty("skin",String); }
    function set_skin( v:String ) :String { return setProperty("skin",v); }

	public var fontFamily(get_font_family,set_font_family):StringList;
    function get_font_family() :StringList { return getInheritedProperty("font-family",StringList); }
    function set_font_family( v:StringList ) :StringList { return setProperty("font-family",v); }

    public var fontSize(get_font_size,set_font_size):Float;
    function get_font_size() :Float { return getInheritedProperty("font-size",Float); }
    function set_font_size( v:Float ) :Float { return setProperty("font-size",v); }

    public var textColor(get_text_color,set_text_color):Color;
    function get_text_color() :Color { return getInheritedProperty("text-color",Color); }
    function set_text_color( v:Color ) :Color { return setProperty("text-color",v); }

	// TODO fontWeight (as in ElementStyle)

    public var horizontalAlign(get_horizontal_align,set_horizontal_align):Float;
    function get_horizontal_align() :Float { return getInheritedProperty("horizontal-align",Float); }
    function set_horizontal_align( v:Float ) :Float { return setProperty("horizontal-align",v); }

    public var verticalAlign(get_vertical_align,set_vertical_align):Float;
    function get_vertical_align() :Float { return getInheritedProperty("vertical-align",Float); }
    function set_vertical_align( v:Float ) :Float { return setProperty("vertical-align",v); }

    public var border(get_border,set_border):Border;
    function get_border() :Border { return getInheritedProperty("border",Border); }
    function set_border( v:Border ) :Border { return setProperty("border",v); }

    public var padding(get_padding,set_padding):Border;
    function get_padding() :Border { return getInheritedProperty("padding",Border); }
    function set_padding( v:Border ) :Border { return setProperty("padding",v); }

    public var margin(get_margin,set_margin):Border;
    function get_margin() :Border { return getInheritedProperty("margin",Border); }
    function set_margin( v:Border ) :Border { return setProperty("margin",v); }

    public var minWidth(get_min_width,set_min_width):Float;
    function get_min_width() :Float { return getInheritedProperty("min-width",Float); }
    function set_min_width( v:Float ) :Float { return setProperty("min-width",v); }

    public var maxWidth(get_max_width,set_max_width):Float;
    function get_max_width() :Float { return getInheritedProperty("max-width",Float); }
    function set_max_width( v:Float ) :Float { return setProperty("max-width",v); }

    public var minHeight(get_min_height,set_min_height):Float;
    function get_min_height() :Float { return getInheritedProperty("min-height",Float); }
    function set_min_height( v:Float ) :Float { return setProperty("min-height",v); }

    public var maxHeight(get_max_height,set_max_height):Float;
    function get_max_height() :Float { return getInheritedProperty("max-height",Float); }
    function set_max_height( v:Float ) :Float { return setProperty("max-height",v); }

    public function new( ?e:Stylable, ?o:Dynamic ) {
        super(e);
		if( o!=null ) fromObject(o);
    }

    override public function fromXml( xml:Xml ) :Void {
        StyleParser.parseXmlAttributes( xml, this, propertyDefinitions );
    }

    override public function parse( values:String ) :Void {
        StyleParser.parse( values, this, propertyDefinitions );
    }

    override public function fromObject( obj:Dynamic ) :Void {
		StyleParser.parseObject( obj, this, propertyDefinitions );
    }

	override public function getDefault<T>( name:String ) :T {
		var d = propertyDefinitions.get(name);
		if( d==null ) return null;
		return d.getDefault();
	}

    static var propertyDefinitions:Hash<StylePropertyDefinition>;
    static function __init__() {
        propertyDefinitions = new Hash<StylePropertyDefinition>();
        for( def in [
			new StringProperty("skin"),
            new StringListProperty("font-family"),
            new UnitFloatProperty("font-size",12.),
            new StringChoiceProperty("font-weight", ["normal","bold"] ),
			new BoundedFloatProperty("horizontal-align", 0, 1 ),
			new BoundedFloatProperty("vertical-align", 0, 1 ),
			new BorderProperty("padding"),
			new BorderProperty("border"),
			new BorderProperty("margin"),
			new FloatProperty("min-width",0),
			new FloatProperty("max-width",Math.POSITIVE_INFINITY),
			new FloatProperty("min-height",0),
			new FloatProperty("max-height",Math.POSITIVE_INFINITY),
			new ColorProperty("text-color"),
            ] ) {
            
            propertyDefinitions.set( def.name, def );
        }
    }
}
