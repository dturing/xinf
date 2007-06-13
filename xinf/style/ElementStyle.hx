
package xinf.style;

import xinf.erno.Color;
import xinf.style.StyleParser;

class ElementStyle extends InheritedStyle {
    public var fill(get_fill,set_fill):Color;
    function get_fill() :Color { return getProperty("fill",Color); }
    function set_fill( v:Color ) :Color { return setProperty("fill",v); }

    public var stroke(get_stroke,set_stroke):Color;
    function get_stroke() :Color { return getProperty("stroke",Color); }
    function set_stroke( v:Color ) :Color { return setProperty("stroke",v); }

    public var strokeWidth(get_stroke_width,set_stroke_width):Float;
    function get_stroke_width() :Float { return getProperty("stroke-width",Float); }
    function set_stroke_width( v:Float ) :Float { return setProperty("stroke-width",v); }


    
    override public function fromXml( xml:Xml ) :Void {
        parseXmlProperties(xml,["fill","stroke","stroke-width"]);
    }
}
