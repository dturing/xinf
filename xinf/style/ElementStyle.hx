
package xinf.style;

import xinf.erno.Color;
import xinf.style.StylePropertyDefinition;

class ElementStyle extends InheritedStyle {
    public var xmlBase(get_xmlBase,set_xmlBase):String;
    function get_xmlBase() :String { return getInheritedProperty("xml:base",String); }
    function set_xmlBase( v:String ) :String { return setProperty("xml:base",v); }

    public var visibility(get_visibility,set_visibility):Visibility;
    function get_visibility() :Visibility { 
        var v = getProperty("visibility",Visibility); 
        if( v==Visibility.Inherit ) {
            return getInheritedProperty("visibility",Visibility);
        }
        return v;
    }
    function set_visibility( v:Visibility ) :Visibility { return setProperty("visibility",v); }

    public var opacity(get_opacity,set_opacity):Null<Float>;
    function get_opacity() :Null<Float> { return getInheritedProperty("opacity",Float); }
    function set_opacity( v:Null<Float> ) :Null<Float> { return setProperty("opacity",v); }

    public var fill(get_fill,set_fill):Color;
    function get_fill() :Color { return getInheritedProperty("fill",Color); }
    function set_fill( v:Color ) :Color { return setProperty("fill",v); }

    public var fillOpacity(get_fill_opacity,set_fill_opacity):Null<Float>;
    function get_fill_opacity() :Null<Float> { return getInheritedProperty("fill-opacity",Float); }
    function set_fill_opacity( v:Null<Float> ) :Null<Float> { return setProperty("fill-opacity",v); }

    public var stroke(get_stroke,set_stroke):Color;
    function get_stroke() :Color { return getInheritedProperty("stroke",Color); }
    function set_stroke( v:Color ) :Color { return setProperty("stroke",v); }

    public var strokeWidth(get_stroke_width,set_stroke_width):Null<Float>;
    function get_stroke_width() :Null<Float> { return getInheritedProperty("stroke-width",Float); }
    function set_stroke_width( v:Float ) :Null<Float> { return setProperty("stroke-width",v); }

    public var fontFamily(get_font_family,set_font_family):StringList;
    function get_font_family() :StringList { return getInheritedProperty("font-family",StringList); }
    function set_font_family( v:StringList ) :StringList { return setProperty("font-family",v); }

    public var fontSize(get_font_size,set_font_size):Float;
    function get_font_size() :Float { return getInheritedProperty("font-size",Float); }
    function set_font_size( v:Float ) :Float { return setProperty("font-size",v); }

	// TODO fontWeight
	
    override public function fromXml( xml:Xml ) :Void {
        StyleParser.parseXmlAttributes( xml, this, propertyDefinitions );
    }

    override public function parse( values:String ) :Void {
        StyleParser.parse( values, this, propertyDefinitions );
    }

    static var propertyDefinitions:Hash<StylePropertyDefinition>;
    static function __init__() {
        propertyDefinitions = new Hash<StylePropertyDefinition>();
        for( def in [
            new BoundedFloatProperty("opacity",0,1,1),
            new ColorProperty("fill"),
            new BoundedFloatProperty("fill-opacity",0,1,1),
            new ColorProperty("stroke"),
            new UnitFloatProperty("stroke-width"),
            
            new StringListProperty("font-family"),
            new UnitFloatProperty("font-size"),
            new StringChoiceProperty("font-weight", ["normal","bold"] ),
            
            new EnumProperty<Visibility>("visibility", Visibility ),
            ] ) {
            
            propertyDefinitions.set( def.name, def );
        }
    }
}
