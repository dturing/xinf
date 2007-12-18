/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

import xinf.style.InheritedStyle;
import xinf.erno.Paint;
import xinf.erno.CapsStyle;
import xinf.erno.JoinStyle;
import xinf.style.StylePropertyDefinition;
import xinf.style.StringList;
import xinf.style.Stylable;
import xinf.style.StyleParser;

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

    public var fill(get_fill,set_fill):Paint;
    function get_fill() :Paint { return getInheritedProperty("fill",Paint); }
    function set_fill( v:Paint ) :Paint{ return setProperty("fill",v); }

    public var fillOpacity(get_fill_opacity,set_fill_opacity):Null<Float>;
    function get_fill_opacity() :Null<Float> { return getInheritedProperty("fill-opacity",Float); }
    function set_fill_opacity( v:Null<Float> ) :Null<Float> { return setProperty("fill-opacity",v); }

    public var stroke(get_stroke,set_stroke):Paint;
    function get_stroke() :Paint { return getInheritedProperty("stroke",Paint); }
    function set_stroke( v:Paint ) :Paint { return setProperty("stroke",v); }

    public var strokeWidth(get_stroke_width,set_stroke_width):Null<Float>;
    function get_stroke_width() :Null<Float> { return getInheritedProperty("stroke-width",Float); }
    function set_stroke_width( v:Float ) :Null<Float> { return setProperty("stroke-width",v); }

    public var strokeOpacity(get_stroke_opacity,set_stroke_opacity):Null<Float>;
    function get_stroke_opacity() :Null<Float> { return getInheritedProperty("stroke-opacity",Float); }
    function set_stroke_opacity( v:Null<Float> ) :Null<Float> { return setProperty("stroke-opacity",v); }

    public var fontFamily(get_font_family,set_font_family):StringList;
    function get_font_family() :StringList { return getInheritedProperty("font-family",StringList); }
    function set_font_family( v:StringList ) :StringList { return setProperty("font-family",v); }

    public var fontSize(get_font_size,set_font_size):Float;
    function get_font_size() :Float { return getInheritedProperty("font-size",Float); }
    function set_font_size( v:Float ) :Float { return setProperty("font-size",v); }

    public var lineJoin(get_line_join,set_line_join):JoinStyle;
    function get_line_join() :JoinStyle { return getInheritedProperty("stroke-linejoin",JoinStyle); }
    function set_line_join( v:JoinStyle ) :JoinStyle { return setProperty("stroke-linejoin",v); }

    public var lineCap(get_line_cap,set_line_cap):CapsStyle;
    function get_line_cap() :CapsStyle { return getInheritedProperty("stroke-linecap",CapsStyle); }
    function set_line_cap( v:CapsStyle ) :CapsStyle { return setProperty("stroke-linecap",v); }

    public var strokeMiterlimit(get_stroke_miterlimit,set_stroke_miterlimit):Null<Float>;
    function get_stroke_miterlimit() :Null<Float> { return getInheritedProperty("stroke-miterlimit",Float); }
    function set_stroke_miterlimit( v:Null<Float> ) :Null<Float> { return setProperty("stroke-miterlimit",v); }

	// TODO fontWeight
	
    override public function fromXml( xml:Xml ) :Void {
        StyleParser.parseXmlAttributes( xml, this, propertyDefinitions );
    }

    override public function parse( values:String ) :Void {
        StyleParser.parse( values, this, propertyDefinitions );
    }

	override public function getDefault<T>( name:String ) :T {
		var def = propertyDefinitions.get(name);
		if( def==null ) return null;
		return def.getDefault();
	}

    static var propertyDefinitions:Hash<StylePropertyDefinition>;
    static function __init__() {
        propertyDefinitions = new Hash<StylePropertyDefinition>();
        for( def in [
            new BoundedFloatProperty("opacity",0,1,1),
            new PaintProperty("fill",SolidColor(0,0,0,1)),
            new BoundedFloatProperty("fill-opacity",0,1,1),
            new PaintProperty("stroke"),
            new UnitFloatProperty("stroke-width",1),
            new BoundedFloatProperty("stroke-opacity",0,1,1),
            
            new StringListProperty("font-family"),
            new UnitFloatProperty("font-size"),
            new StringChoiceProperty("font-weight", ["normal","bold"] ),
            
            new EnumProperty<Visibility>("visibility", Visibility ),
            new EnumProperty<JoinStyle>("stroke-linejoin", JoinStyle, "join", MiterJoin ),
            new EnumProperty<JoinStyle>("stroke-linecap", CapsStyle, "caps" ),
            new FloatProperty("stroke-miterlimit",4),
            ] ) {
            
            propertyDefinitions.set( def.name, def );
        }
    }
}
