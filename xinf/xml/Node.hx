/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

/**
	A generic Node, as in an XML document, but
	also the base class for all xinf's SVG-like
	$xinf.ony.Element$s.
	
	While this is oriented on the SVG uDOM, there
	are some differences. There is currently no
	namespace support; parentNode is parentElement
	here; xinf currently doesn't support any
	other node types than $xinf.xml.Element$,
	and there is no textContent.

	This might change when xinf supports 
	(re-)serialization of XML content. The
	Interface described here should stay the same.

	$SVG svgudom#dom__Node Node in SVG uDOM$
**/
class Node implements Serializable {

	/* TinySVG1.2 uDOM: 
		readonly attribute DOMString namespaceURI;
        readonly attribute DOMString localName;
        attribute DOMString textContent;
	*/

	/**
		The parent Element of this Node, if the
		Node is attached.
	*/
	public var parentElement(default,null) :XMLElement;
	
	/**
		The Document that ultimately contains this
		Node. In Xinf, there is currently only one
		document. See $xinf.ony.Root$. A node is
		always associated to a Document.
	*/
	public var ownerDocument(default,null) :Document;

    var mChildren(default,null):Array<Node>;
	
	/**
		An iterator of the child Nodes contained in	this Node.
	*/
	public var childNodes(get_childNodes,null) :Iterator<Node>;
    function get_childNodes() :Iterator<Node> {
        return mChildren.iterator();
    }

	/**
		Create a new, empty Node.
		
		FIXME: should be associated to the root document?
	*/
    public function new() {
        mChildren = new Array<Node>();
    }

	/**
		De-serialize the node content and attributes
		from the given Xml.
		
		You'll usually not call this. Instead, use
		$xinf.xml.Document$.instantiate or .load.
	*/
    public function fromXml( xml:Xml ) :Void {
        if( ownerDocument==null ) throw("Document not set.");
        for( node in xml.elements() ) {
            ownerDocument.unmarshal( node, this );
        }
	}

	/**
		Called after the Document has been fully loaded
		(not including external references like images)
		and the Node structure is set up. Provides a 
		hook for deriving classes to initialize things
		that depend on the document structure to be
		fully set up.
		
		This also calls onLoad on any child nodes.
	*/
	public function onLoad() :Void {
		for( child in mChildren ) {
			child.onLoad();
		}
	}
	
	function setOwnerDocument( doc:Document ) {
		if( doc == ownerDocument ) return;
		ownerDocument = doc;
		for( c in mChildren ) c.setOwnerDocument(doc);
	}

	function acquired( newChild:Node ) {
		if( ownerDocument != null )
			newChild.setOwnerDocument( ownerDocument );
	}
	
	/**
		Appendsthe Node [newChild] to the end
		of the list of children of this node.
	*/
	public function appendChild( newChild:Node ) :Node {
		mChildren.push( newChild );
		acquired(newChild);
		return newChild;
	}
	
	/**
		Insertsthe Node [newChild] into the list of
		children of this node, immediately before
		[refChild].
	*/
	public function insertBefore( newChild:Node, refChild:Node ) :Node {
		var pos=-1;
		var i=0;
		for( child in mChildren ) {
			if( child==refChild ) pos=i;
			i++;
		}
		if( pos==-1 )
			mChildren.push( newChild );
		else 
			mChildren.insert( pos-1, newChild );
			
		acquired(newChild);
				
		return newChild;
	}

	/**
		Removesthe Node [oldChild] from the list of children.
	*/
	public function removeChild( oldChild:Node ) :Node {
        mChildren.remove( oldChild );
		oldChild.ownerDocument = null;
		oldChild.parentElement = null;
		return oldChild;
	}

	/**
		Creates a 1-to-1 clone of this Node.
		If [deep] is true, any children will be
		cloned, too. Else, the new Node is empty.
	*/
	public function cloneNode( deep:Bool ) :Node {
		var clone:Node = cast(Type.createInstance( Type.getClass(this), [ null ] ));
		copyProperties( clone );
		
		if( deep ) {
			clone.mChildren = new Array<Node>();
			for( child in mChildren ) {
				var c =  child.cloneNode(deep);
				clone.appendChild( c );
			}
		}

		return clone;
	}

	function copyProperties( to:Dynamic ) :Void {
	}
	
	/**
		Convenience function, return the parentElement
		of this Node typed to the class [type], or [null]
		if the parent is not of that type.
	*/
	public function getTypedParent<T>( type:Class<T> ) :T {
		if( Std.is( parentElement, type ) ) return cast(parentElement);
		return null;
	}

	/**
		Create a human-readable String representation
		of this node, mostly for debugging purposes.
		The string will be the class name of this individual
		instance.
	*/
    public function toString() :String {
		return( Type.getClassName( Type.getClass(this) ) );
    }
}
