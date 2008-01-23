/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

import xinf.style.StyleSheet;
import xinf.style.StyleParser;
import xinf.traits.TraitAccess;
import xinf.traits.StringTrait;

/**
	XML-style Document class.
*/
class Document extends XMLElement {
	
	/** The root Element of this Document.
	*/
	public var documentElement(default,null):XMLElement;
	
	/** The id index of this document.
	
		Don't do lookups direcly on this Hash,
		instead use getElementById().
	*/
    public var elementsById(default,null):Hash<XMLElement>;
	
	/** The Document's StyleSheet.
	*/
    public var styleSheet(default,null):StyleSheet;

	/** Create a new, empty Document.
	*/
	public function new() :Void {
		super();
        elementsById = new Hash<XMLElement>();
 		styleSheet = new StyleSheet();
		ownerDocument = this;
	}

	/** Return the Element with the specified [id].
	
		An exception will be thrown if no Node
		with the given [id] exists.
	*/
    public function getElementById( id:String ) :XMLElement {
        var r = elementsById.get(id);
        if( r==null ) throw("No such Element #"+id+" in "+this );
        return r;
    }

	/** Return the Element with the specified [id],
		typed to the given [type].
	
		An exception will be thrown if no Node
		with the given [id] exists, or the Node
		is not of the specified [type].
	*/
	public function getTypedElementById<T>( id:String, type:Class<T> ) :T {
        var r = getElementById( id );
		if( !Std.is( r, type ) ) throw("Element #"+id+" is not of class "+Type.getClassName(type)+" (but instead "+Type.getClassName(Type.getClass(r))+")" );
        return cast(r);
    }
	
	/** Return the Element referenced by [uri].
	
		Currently, this is only good for finding Elements
		by id (uri == "#id"), but in the future this might
		return Elements of external Documents, too.
		
		An exception will be thrown if [uri] references an
		Element in an external document, or the Element
		can not be found.
	*/
	public function getElementByURI( uri:String ) :XMLElement {
		var u = uri.split("#");
		if( u.length!=2 ) throw("invalid URI, or URI doesn't include fragment identifier: "+uri );
		if( u[0] != "" ) throw("full URIs are not yet supported");
		var id = u[1];
		return getElementById( id );
	}
	
	/** Return the Element referenced by [uri],
		typed to the given [type].
	
		See also getElementByURI.
		An exception will be thrown if the Element
		is not of the specified [type].
	*/
	public function getTypedElementByURI<T>( uri:String, cl:Class<T> ) :T {
        var r = getElementByURI( uri );
		if( !Std.is( r, cl ) ) throw("Element "+uri+" is not of class "+Type.getClassName(cl)+" (but instead "+Type.getClassName(Type.getClass(r))+")" );
        return cast(r);
	}
	
	/** Unmarshal (deserialize) a Node from the given
		[xml], and attaches it to the given [parent] (if specified).
		
		If the Document's $xinf.xml.Binding$s don't support the
		given Xml, [null] will be returned.
		
		Namespaces are currently ignored. This will look though
		all given Bindings.
	*/
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
	
	/**
		Instantiate the XML given in [data], and returns the root node.
		
		If [base] is given, it will be set as the document base on the new Element.
		
		If [parentDocument] is given, all new Nodes will be associated to the given
		Document. If not, they will be associated to $xinf.ony.Root$'s Document.
		(This might change a little in the future.)
	*/
	public static function instantiate<T>( data:String, ?base:URL, ?parentDocument:Document, ?onLoad:T->Void, ?type:Class<T> ) :Node {
		// FIXME: this Root.getDocument() is really bad here..
		if( parentDocument==null ) parentDocument = xinf.ony.Root.getDocument();
		var xml = Xml.parse(data);
		var e = parentDocument.unmarshal( xml.firstElement() );
		if( base!=null && Std.is(e,XMLElement) ) {
			var el:XMLElement = cast(e);
			el.base = base.pathString();
		}
		e.onLoad();
		if( onLoad!=null ) {
			if( type!=null && !Std.is(e,type) ) throw("Document root ("+e+") is not of expected type "+Type.getClassName(type)+".");
			onLoad( cast(e) );
		}
		return e;
	}
	
	/**
		Instantiate the XML found at the URL [url_s].
		
		If [onLoad] is given, it will be called with the instantiated root node
		once the document is fully loaded (and after the Element's onLoad function
		has been called).
	*/
    public static function load<T>( url_s:String, ?parentDocument:Document, ?onLoad:T->Void, ?type:Class<T> ) :Void {
        var url = new URL(url_s);
        url.fetch( function(data) {
				instantiate( data, url, parentDocument, onLoad, type );
            }, function( error ) {
                throw(error);
            } );
    }
	
	static var bindings:Hash<IBinding>;
	
	/**
		Add a new Binding to this Document.
		
		[namespaceURI] is currently disregarded, but you should pass in the
		proper namespace anyway, to be safe for a future where we support
		namespaces.
	*/
	public static function addBinding( namespaceURI:String, binding:IBinding ) {
		if( bindings==null ) bindings = new Hash<IBinding>();
		bindings.set( namespaceURI, binding );
	}

	/**
		Bind the given class cl to the binding for the given namespace.
		Create an empty binding if the namespace is yet unbound.
	*/
	public static function addToBinding( namespaceURI:String, nodeName:String, cl:Class<Node> ) {
		if( bindings==null ) bindings = new Hash<IBinding>();
		var binding = bindings.get( namespaceURI );
		if( binding == null ) {
			binding = new Binding();
			bindings.set( namespaceURI, binding );
		}
		binding.add( nodeName, cl );
	}

}
