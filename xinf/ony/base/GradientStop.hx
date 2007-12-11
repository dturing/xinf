package xinf.ony.base;

import xinf.xml.Serializable;
//import xinf.style.StylePropertyDefinition;
//import xinf.style.Style;
//import xinf.style.StyleParser;
import xinf.erno.Paint;
import xinf.erno.Color;
/*
class GradientStopStyle extends Style {
    public var stopOpacity(get_stop_opacity,set_stop_opacity):Null<Float>;
    function get_stop_opacity() :Null<Float> { return getTrait("stop-opacity",Float); }
    function set_stop_opacity( v:Null<Float> ) :Null<Float> { return setTrait("stop-opacity",v); }

    public var stopColor(get_stop_color,set_stop_color):Paint;
    function get_stop_color() :Paint { return getInheritedProperty("stop-color",Paint); }
    function set_stop_color( v:Paint ) :Paint { return setProperty("stop-color",v); }

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
            new BoundedFloatProperty("stop-opacity",0,1,1),
            new PaintProperty("stop-color")
            ] ) {
            
            propertyDefinitions.set( def.name, def );
        }
    }
}
*/
class GradientStop implements Serializable {
	public var offset :Float;
	public var color :Color;
//	public var style :GradientStopStyle;

	public function new() :Void {
//		style = new GradientStopStyle();
	}

	public function fromXml( xml:Xml ) :Void {
		if( xml.exists("offset") )
			offset = Std.parseFloat( xml.get("offset") );
	/*
        if( xml.exists("style") ) {
            style.parse( xml.get("style") );
        }
        style.fromXml( xml );
		
		if( style.stopColor!=null ) {
			switch( style.stopColor ) {
				case SolidColor(r,g,b,a):
					color = Color.rgba(r,g,b,a);
					color.a = style.stopOpacity;
				default:
					throw("GradientStop stop-color must be a SolidColor");
			}
		}
		*/
	}
	
}
