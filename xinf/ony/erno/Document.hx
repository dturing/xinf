package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.ony.URL;

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
}
