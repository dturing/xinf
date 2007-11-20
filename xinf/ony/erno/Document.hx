package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.ony.URL;

class Document extends Group, implements xinf.ony.Document {

	override function set_x(v:Float) {
        scheduleTransform();
		return super.set_x(v);
	}
    override function set_y(v:Float) {
        scheduleTransform();
		return super.set_y(v);
    }
	
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

}
