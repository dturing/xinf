/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

import xinf.type.URL;
import xinf.style.StyleSheet;
import xinf.style.StyleParser;
import xinf.traits.TraitAccess;
import xinf.traits.StringTrait;

class Document extends Element {
	
	public var documentElement(default,null):Element;
    public var elementsById(default,null):Hash<Node>;
    public var styleSheet(default,null):StyleSheet;

	public function new() :Void {
		super();
        elementsById = new Hash<Node>();
 		styleSheet = new StyleSheet();
		ownerDocument = this;
	}
	
    public function getElementById( id:String ) :Node {
        var r = elementsById.get(id);
        if( r==null ) throw("No such Element #"+id+" in "+this+", els: "+elementsById );
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
        var r:Node;
		
		// TODO: for now, we ignore the namespace (there is none from haxe xml),
		// and just search all known bindings for the localName
		var ns = bindings.keys();
		while( ns.hasNext() && r==null ) {
			r = bindings.get(ns.next()).instantiate( xml );
		}
		
        if( r==null ) return null;
        
		r.ownerDocument = this;
        r.fromXml( xml );

        if( parent!=null ) parent.appendChild(r);
		
        return r;
    }

	override public function toString() :String {
		return("Document("+base+")");
	}
	
	public static function instantiate( data:String, ?base:URL, ?parentDocument:Document, ?onLoad:Node->Void ) :Node {
		if( parentDocument==null ) parentDocument = xinf.ony.Root.getDocument();
		var xml = Xml.parse(data);
		var e = parentDocument.unmarshal( xml.firstElement() );
		if( base!=null && Std.is(e,Element) ) {
			var el:Element = cast(e);
			el.base = base.pathString();
		}
		e.onLoad();
		if( onLoad!=null ) onLoad( e );
		return e;
	}
	
    public static function load( url_s:String, ?parentDocument:Document, ?onLoad:Node->Void ) :Void {
		if( parentDocument==null ) parentDocument = xinf.ony.Root.getDocument();
        var url = new URL(url_s);
        url.fetch( function(data) {
				instantiate( data, url, parentDocument, onLoad );
            }, function( error ) {
                throw(error);
            } );
    }
	
	static var bindings:Hash<IBinding>;
	public static function addBinding( namespaceURI:String, binding:IBinding ) {
		if( bindings==null ) bindings = new Hash<IBinding>();
		bindings.set( namespaceURI, binding );
	}
	
}
