/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.xml.URL;
import xinf.xml.Node;
import xinf.xml.Document;
import xinf.xml.Binding;
import xinf.xml.Instantiator;

class Svg extends xinf.ony.Svg {

	public function new( ?traits:Dynamic ) {
		super(traits);
		//construct();
	}
	
	static function __init__() :Void {
		var svgns = "http://www.w3.org/2000/svg";
	
        xinf.xml.Document.addToBinding( svgns, "g", Group );
        xinf.xml.Document.addToBinding( svgns,"rect", Rectangle );
        xinf.xml.Document.addToBinding( svgns,"line", Line );
        xinf.xml.Document.addToBinding( svgns,"polygon", Polygon );
        xinf.xml.Document.addToBinding( svgns,"polyline", Polyline );
        xinf.xml.Document.addToBinding( svgns,"ellipse", Ellipse );
        xinf.xml.Document.addToBinding( svgns,"circle", Circle );
        xinf.xml.Document.addToBinding( svgns,"text", Text );
        xinf.xml.Document.addToBinding( svgns,"textArea", EditableTextArea );
        xinf.xml.Document.addToBinding( svgns,"path", Path );
        xinf.xml.Document.addToBinding( svgns,"image", Image );
		
		xinf.xml.Document.addToBinding( svgns,"svg", Svg );
		xinf.xml.Document.addToBinding( svgns,"use", Use );
        xinf.xml.Document.addToBinding( svgns,"defs", Definitions );
		
        xinf.xml.Document.addToBinding( svgns,"linearGradient", LinearGradient );
        xinf.xml.Document.addToBinding( svgns,"radialGradient", RadialGradient );
        xinf.xml.Document.addToBinding( svgns,"solidColor", SolidColor );
		xinf.xml.Document.addToBinding( svgns,"style", xinf.ony.Style );
	}
}
