/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

import xinf.type.URL;
import xinf.style.StyleSheet;
import xinf.traits.StringTrait;

class Document extends Element {

	static var TRAITS = {
		xml__base:		new StringTrait(),
	};
	
    public var base(get_base,set_base):String; // FIXME: maybe, as xml: is not a "normal" namespace prefix, this might actually work... - although, it's not really a style trait, but is inherited...
    function get_base() :String { 
		var p:Element=this;
		var b:String=null;
		while( p!=null ) {
			var thisBase = p.getTrait("xml:base",String);
			if( thisBase!=null ) b = if( b!=null ) thisBase+b else thisBase; // FIXME: actually, URL.relateTo
			p = p.parentElement;
		}
		return b; 
	} 
    function set_base( v:String ) :String { return setStyleTrait("xml:base",v); }

	public var documentElement(default,null):Element;
    public var elementsById(default,null):Hash<Node>;
    public var styleSheet(default,null):StyleSheet;

	public function new() :Void {
		super();
        elementsById = new Hash<Node>();
 		styleSheet = new StyleSheet();
	}
	
    public function getElementById( id:String ) :Node {
        var r = elementsById.get(id);
        if( r==null ) throw("No such Element #"+id );
        return r;
    }

	public function getTypedElementById<T>( id:String, cl:Class<T> ) :T {
        var r = getElementById( id );
		if( !Std.is( r, cl ) ) throw("Element #"+id+" is not of class "+Type.getClassName(cl)+" (but instead "+Type.getClassName(Type.getClass(r))+")" );
        return cast(r);
    }
	
	public function getElementByURI( uri:String ) :Node {
		var u = uri.split("#");
		if( u.length!=2 ) throw("invalid URI, or URI doesn't include fragment identifier: "+uri );
		if( u[0] != "" ) throw("full URIs are not yet supported");
		var id = u[1];
		return getElementById( id );
	}
	
	public function getTypedElementByURI<T>( uri:String, cl:Class<T> ) :T {
        var r = getElementByURI( uri );
		if( !Std.is( r, cl ) ) throw("Element "+uri+" is not of class "+Type.getClassName(cl)+" (but instead "+Type.getClassName(Type.getClass(r))+")" );
        return cast(r);
	}

    public function unmarshal( xml:Xml, ?parent:Node ) :Node {
        var r = binding.instantiate( xml );
//		trace("instantiate "+xml.nodeName+": "+r+", parent "+parent );
        if( r==null ) return null;
        
		r.ownerDocument = this;
        r.fromXml( xml );

        if( parent!=null ) parent.appendChild(r);
		
        return r;
    }
/*
    public static function overrideBinding( nodeName:String, cl:Class<Node> ) :Void {
        binding.add( nodeName, cl );
    }
    
    public static function addInstantiator( i:Instantiator<Node> ) :Void {
        binding.addInstantiator( i );
    }
*/
	public static function instantiate( data:String, ?onLoad:Document->Void, ?doc ) :Document {
        if( doc==null ) doc = new Document();
		var xml = Xml.parse(data);
		doc.ownerDocument = doc;
		var e = doc.unmarshal( xml.firstElement(), doc );
		if( !Std.is(e,Element) ) throw("firstElement is not an Element?");
		doc.documentElement = cast(e);
		doc.onLoad();
		if( onLoad!=null ) onLoad( doc );
		return doc;
	}
	
    public static function load( url_s:String, ?onLoad:Document->Void ) :Document {
        var doc = new Document();
        var url = new URL(url_s);
        doc.base = url.pathString();
        url.fetch( function(data) {
				instantiate( data, onLoad, doc );
            }, function( error ) {
                throw(error);
            } );
        return doc;
    }
	
	public static var binding:IBinding;
}
