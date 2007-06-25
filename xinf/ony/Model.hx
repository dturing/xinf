
package xinf.ony;

// these will be runtime-specific

typedef Group_ = xinf.ony.erno.Group
typedef Document_ = xinf.ony.erno.Document
typedef Rectangle_ = xinf.ony.erno.Rectangle
typedef Line_ = xinf.ony.erno.Line
typedef Polygon_ = xinf.ony.erno.Polygon


class Model {
    private var mRoot:xinf.ony.Document;
    
    public function new() {
        var r = new xinf.ony.erno.Root();
        mRoot = new Document_();
        r.attach( mRoot );
    }
    
    public function main() {
        xinf.erno.Runtime.runtime.run();
    }
    
    public function getByXid( xid:Int ) :Element {
        return xinf.ony.erno.Object.findById(xid);
    }
    
    public function root() :Group {
        return mRoot;
    }
    
    public function group() :Group {
        return new Group_();
    }
    
    public function document() :Document {
        return new Document_();
    }
    
    public function rectangle() :Rectangle {
        return new Rectangle_();
    }

    public function line() :Line {
        return new Line_();
    }

    public function polygon() :Polygon {
        return new Polygon_();
    }
    
    public function loadDocument( url:String, ?onLoad:Document->Void ) :Document {
        var doc = document();
        doc.style.xmlBase = url;
        try {
            var request = new haxe.Http(url);
            request.onError = function(e) {
                    throw(e);
                };
            request.onData = function(data) {
                    var xml = Xml.parse(data);
                    doc.fromXml( xml.firstElement() );
                    if( onLoad!=null ) onLoad( doc );
                };
            request.request(false);
        } catch( e:Dynamic ) {
            throw("Could not load document '"+url+"': "+e );
        }
        return doc;
    }
}
