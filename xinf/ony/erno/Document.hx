package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.ony.URL;
import xinf.xml.Binding;

class Document extends xinf.ony.base.Document {

    private var baseURL:URL;
    public function setBaseURL( url:URL ) :URL {
        baseURL = url;
        return baseURL;
    }
    public function getBaseURL() :URL {
        return baseURL;
    }

    override public function reTransform( g:Renderer ) :Void {
        g.setTransform( xid, x, y, 1., 0., 0., 1. );
        // TODO g.setTranslation( xid, x, y );
    }

    public static function load( url_s:String, ?onLoad:Document->Void ) :Document {
		return xinf.ony.base.Document.load( url_s, onLoad );
	}
	
	static function __init__() :Void {
        var binding = new Binding<Element>();
        
        // basic elements FIXME: runtime dependant! or *Impl
        binding.add( "g", Group );
        binding.add( "rect", Rectangle );
        binding.add( "line", Line );
        binding.add( "polygon", Polygon );
        binding.add( "polyline", Polyline );
        binding.add( "ellipse", Ellipse );
        binding.add( "circle", Circle );
        binding.add( "text", Text );
        binding.add( "path", Path );
        binding.add( "image", Image );
		
		binding.add( "svg", Document );
		binding.add( "use", Use );
        binding.add( "defs", Definitions );
        /*
        binding.add( "a", Link );
        */
		
		xinf.ony.base.Document.binding = binding;
    }
}
