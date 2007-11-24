package xinf.ony;

import xinf.style.StyleSheet;
import xinf.style.ElementStyle;
import xinf.xml.Binding;
import xinf.xml.Instantiator;

class Document extends Group {

    public var x(default,set_x):Float;
    public var y(default,set_y):Float;
    public var width(default,set_width):Float;
    public var height(default,set_height):Float;
    function set_x(v:Float) {
        x=v; scheduleTransform(); return x;
    }
    function set_y(v:Float) {
        y=v; scheduleTransform(); return y;
    }
    function set_width(v:Float) {
        width=v; return width;
    }
    function set_height(v:Float) {
        height=v; return height;
    }

    public var styleSheet(default,null):StyleSheet<ElementStyle>;
    public var elementsById(default,null):Hash<xinf.ony.Element>;
	
    public function new() :Void {
        super();
        document=this;
        styleSheet=null;
		x=y=0.;
        elementsById = new Hash<xinf.ony.Element>();
    }

    public function getElementById( id:String ) :Element {
        var r = elementsById.get(id);
        if( r==null ) throw("No such Element #"+id+" - elements: "+elementsById );
        return r;
    }

	public function getTypedElementById<T>( id:String, cl:Class<T> ) :T {
        var r = getElementById( id );
		if( !Std.is( r, cl ) ) throw("Element #"+id+" is not of class "+Type.getClassName(cl)+" (but instead "+Type.getClassName(Type.getClass(r))+")" );
        return cast(r);
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);

        x = getFloatProperty(xml,"x");
        y = getFloatProperty(xml,"y");
        width = getFloatProperty(xml,"width");
        height = getFloatProperty(xml,"height");

		// for now...
        if( xml.exists("viewBox") ) {
            var vb = xml.get("viewBox").split(" ");
            if( vb.length != 4 ) {
                throw("illegal/unsupported viewBox: "+vb );
            }
            width = Std.parseInt( vb[2] );
            height = Std.parseInt( vb[3] );
        }
    }

    public function unmarshal( xml:Xml, ?parent:Group ) :Element {
        var r = binding.instantiate( xml );
        if( r==null ) return null;
        
        if( parent!=null ) parent.attach(r);
        untyped r.document = this; // FIXME
        
        r.fromXml( xml );
        if( r.id!=null ) {
            elementsById.set( r.id, r );
        }
        return r;
    }

    override public function attachedTo( p:xinf.ony.Group ) :Void {
        super.attachedTo(p);
        document=this;
    }

    public static function overrideBinding( nodeName:String, cl:Class<xinf.ony.Element> ) :Void {
        binding.add( nodeName, cl );
    }
    
    public static function addInstantiator( i:Instantiator<xinf.ony.Element> ) :Void {
        binding.addInstantiator( i );
    }

	public static function instantiate( data:String, ?onLoad:Document->Void ) :Document {
        var doc = new Document();
		var xml = Xml.parse(data);
		doc.fromXml( xml.firstElement() );
		doc.onLoad();
		if( onLoad!=null ) onLoad( doc );
		return doc;
	}
	
    public static function load( url_s:String, ?onLoad:Document->Void ) :Document {
        var doc = new Document();
        doc.style.xmlBase = url_s;
        
        var url = new URL(url_s);
        url.fetch( function(data) {
                var xml = Xml.parse(data);
                doc.fromXml( xml.firstElement() );
				doc.onLoad();
                if( onLoad!=null ) onLoad( doc );
            }, function( error ) {
                throw(error);
            } );
        return doc;
    }
	
	static var binding:Binding<xinf.ony.Element>;
	static function __init__() :Void {
        binding = new Binding<xinf.ony.Element>();
        
        // basic elements
        binding.add( "g", Group );
        binding.add( "rect", Rectangle );
		/*
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
		*/
        /*
        binding.add( "a", Link );
        */
    }
}