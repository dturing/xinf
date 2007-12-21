/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.type.URL;
import xinf.xml.Node;
import xinf.xml.Document;
import xinf.xml.Binding;
import xinf.xml.Instantiator;

class Svg extends xinf.ony.base.Svg {

	public function new( ?traits:Dynamic ) {
		super(traits);
		//construct();
	}

	static var svgNamespace:String;
	
	static function __init__() :Void {
		svgNamespace = "http://www.w3.org/2000/svg";
	
        var binding = new Binding<Element>();
        
        binding.add( "g", Group );
        binding.add( "rect", Rectangle );
        binding.add( "line", Line );
        binding.add( "polygon", Polygon );
        binding.add( "polyline", Polyline );
        binding.add( "ellipse", Ellipse );
        binding.add( "circle", Circle );
        binding.add( "text", Text );
        binding.add( "textArea", EditableTextArea );
        binding.add( "path", Path );
        binding.add( "image", Image );
		
		binding.add( "svg", Svg );
		binding.add( "use", Use );
        binding.add( "defs", Definitions );
		
        binding.add( "linearGradient", xinf.ony.base.LinearGradient );
        binding.add( "radialGradient", xinf.ony.base.RadialGradient );
		binding.add( "style", xinf.ony.base.Style );
		
		xinf.xml.Document.addBinding( svgNamespace, binding );
    }
}
