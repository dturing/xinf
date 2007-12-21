/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

class Node implements Serializable {

	public var parentElement(default,null) :Element;
	public var ownerDocument(default,null) :Document;

    var mChildren(default,null):Array<Node>;
	public var childNodes(get_childNodes,null) :Iterator<Node>;
    function get_childNodes() :Iterator<Node> {
        return mChildren.iterator();
    }

    public function new() {
        mChildren = new Array<Node>();
    }

    public function fromXml( xml:Xml ) :Void {
        if( ownerDocument==null ) throw("Document not set.");
        for( node in xml.elements() ) {
            ownerDocument.unmarshal( node, this );
        }
	}

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
	
	public function appendChild( newChild:Node ) :Node {
		mChildren.push( newChild );
		acquired(newChild);
		return newChild;
	}
	
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

	public function removeChild( oldChild:Node ) :Node {
        mChildren.remove( oldChild );
		oldChild.ownerDocument = null;
		oldChild.parentElement = null;
		return oldChild;
	}

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
	
	public function getTypedParent<T>( type:Class<T> ) :T {
		if( Std.is( parentElement, type ) ) return cast(parentElement);
		return null;
	}

    public function toString() :String {
		return( Type.getClassName( Type.getClass(this) ) );
    }

/* TinySVG1.2 uDOM: 
		readonly attribute DOMString namespaceURI;
        readonly attribute DOMString localName;
        attribute DOMString textContent;
	*/
}
