/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

import xinf.xml.Node;
import xinf.xml.XMLElement;
import xinf.traits.SpecialTraitValue;
import xinf.traits.TraitTypeException;

/**
	An Element with style.
	
	Keeps a list of associated style classes, and automatically
	matches against the ownerDocument's StyleSheet.
	
	Recognizes the "style" attribute when parsing from XML.
*/
class StyledElement extends XMLElement {

	/* TODO: make "style" and "class" attributes a TRAIT? */

	var styleClasses :Hash<Bool>;
	var _matchedStyle:Dynamic;
	
	/**
		Create a new StyledElement with initially empty style classes.
	*/
	public function new( traits:Dynamic ) {
		super(traits);
		_matchedStyle = Reflect.empty();
		styleClasses = new Hash<Bool>();
	}

	/**
		Set the style trait [name] to [value]. 
		Similar to $xinf.xml.Element$.setTrait, but also
		calls styleChanged().
	*/
	override public function setStyleTrait<T>( name:String, value:T ) :T {
		var r = setTrait( name, value );
		styleChanged();
		return r;
	}

	override public function setPresentationTrait( name:String, value:Dynamic ) :Dynamic {
		super.setPresentationTrait(name,value);
		styleChanged(null);
		return value;
	}

	/**
		Return the value of the "style trait" [name]. Style traits
		differ from normal traits in a few aspects:
		<ul>
			<li>they can come from $xinf.style.StyleSheet$s
				</li>
			<li>they can have $xinf.traits.SpecialTraitValue$s
				</li>
			<li>they can be inherited (when [inherit] is true or omitted,
				or the trait has the special type $xinf.traits.Inherit$)
				</li>
			<li>their value is cached, so access should be relatively 
				efficient even when the value is determined by inheritance.
				</li>
		</ul>
		
		DOCME: move this doc somewhere else?
	*/
	override public function getStyleTrait<T>( name:String, type:Dynamic, ?inherit:Bool, ?presentation:Bool ) :T {
		if( inherit==null ) inherit=true;

		var v:T = null;
		
		// lookup presentation value
		if( presentation!=false ) {
			v = Reflect.field(_ptraits,name);
			if( v!=null ) return v;
		}
		
		#if profile
//			xinf.test.Counter.count("getStyleTrait("+name+")");
		#end
		
		// lookup XML attribute
		if( v==null )
			v = Reflect.field(_traits,name);
		
// FIXME Code doubling before and after this, in XMLElement--
		// lookup in matched style
		if( v==null ) 
			v = Reflect.field(_matchedStyle,name);
		
		// inherited..
		if( v==null && inherit ) {
			var p = parentElement;
			if( p!=null ) {
				v = p.getStyleTrait( name, type, inherit );
			}
		}
// --FIXME

		// default.
		if( v==null ) {
			var def = getTraitDefinition(name);
			if( def!=null ) {
				return def.getDefault();
			}
		}
		
		if( v!=null ) {
			cacheTrait( name, v, type );
		}
		
		return v;
	}

	public function hasOwnStyleTrait<T>( name:String ) :Bool {
		// lookup XML attribute
		var v = Reflect.field(_traits,name);
		
		// lookup in matched style
		if( v==null ) v = Reflect.field(_matchedStyle,name);
		
		return v!=null;
	}

	static var ws_split = ~/[ \r\n\t]+/g;
	override public function fromXml( xml:Xml ) :Void {
		super.fromXml( xml );

		if( xml.exists("style") ) {
			StyleParser.fromObject( 
				StyleParser.parseToObject( xml.get("style") ),
				this, _traits );
		}

		if( xml.exists("class") ) {
			var cs = ws_split.split( xml.get("class") );
			for( c in cs ) {
				var ct = StringTools.trim(c);
				if( ct.length>0 ) addStyleClass(ct);
			}
        }

		styleChanged();
	}
	
	override public function onLoad() :Void {
		super.onLoad();
		updateClassStyle();
	}

	/**
		Hook function. Derived classes can override this to do 
		something when the element's style changes (like redraw).
		
		In reality, it is not strictly always called when the
		style would change-- notably, if the style comes from
		a StyleSheet, and either the StyleSheet changes or
		this element would match different selectors (because
		it changed in the display hierarchy), or similar things,
		it will *not* be called, in the current implementation.
		
		Note, however, that setting any trait with setStyleTrait,
		or changing a StyledElement's style classes does indeed 
		trigger a call to styleChanged.
	*/
    public function styleChanged( ?attribute:String ) :Void {
//		trace("restyle "+this);
	
		for( child in childNodes ) {
			if( Std.is( child, StyledElement ) ) {
				var s:StyledElement = cast(child);
				if( attribute==null || !s.hasOwnStyleTrait(attribute) ) {
					s.styleChanged( attribute );
				}
			}
		}
	}

	// Style class functions

	override function setOwnerDocument( doc:xinf.xml.Document ) {
		super.setOwnerDocument(doc);
		updateClassStyle();
	}

	function updateClassStyle() :Void {
		if( ownerDocument!=null && ownerDocument.styleSheet!=null ) {
			clearPresentationTraits();
			var match = ownerDocument.styleSheet.match(this);
			if( match!=null ) {
				_matchedStyle = Reflect.empty();
				StyleParser.fromObject( match, this, _matchedStyle );
			} else _matchedStyle=null;
			styleChanged();
		}
    }
	
	/**
		Add the style class [name], and re-match against ownerDocument's StyleSheet.
	*/
    public function addStyleClass( name:String ) :Void {
        styleClasses.set( name, true );
        updateClassStyle();
    }
    
	/**
		Remove the style class [name], and re-match against ownerDocument's StyleSheet.
	*/
    public function removeStyleClass( name:String ) :Void {
        styleClasses.remove( name );
        updateClassStyle();
    }
    
	/**
		Return [true] if [name] is in the list of style classes.
	*/
    public function hasStyleClass( name:String ) :Bool {
        return styleClasses.get(name)!=null;
    }

	/**
		Return an iterator of the list of style classes.
	*/
    public function getStyleClasses() :Iterator<String> {
        return styleClasses.keys();
    }
	
	/**
		Return the element's XML tag name.
		
		FIXME: this needs rework. currently, tagName must be
		set "manually" by deriving classes. $xinf.xml.Binding$
		could/should take care of that.
	*/
	public function getTagName() :String {
		var cl:Class<Dynamic> = Type.getClass(this);
		while( cl!=null ) {
			if( Reflect.hasField(cl,"tagName") ) return Reflect.field(cl,"tagName");
			cl = Type.getSuperClass(cl);
		}
		return null;
	}
	
	/**
		Return [true] if the object matches
		the given Selector [s], false otherwise.
	*/
	public function matchSelector( s:Selector ) :Bool {
		switch( s ) {
			case Any:
				return true;
				
			case ById(id):
				return( this.id == id );
				
			case ClassName(name):
				return( getTagName() == name );
				
			case StyleClass(name):
				return hasStyleClass( name );
				
			case AnyOf(a):
				for( sel in a ) {
					if( matchSelector(sel) ) return true;
				}
				return false;
				
			case AllOf(a):
				for( sel in a ) {
					if( !matchSelector(sel) ) return false;
				}
				return true;

			case Parent(sel):
				var p = getTypedParent( StyledElement );
				if( p==null ) return false;
				return p.matchSelector(sel);
				
			case Ancestor(sel):
				var p:StyledElement = this;
				while( p != null ) {
					p = p.getTypedParent( StyledElement );
					if( Std.is( p, StyledElement )
						&& cast(p).matchSelector(sel) ) return true;
				}
				return false;

			case GrandAncestor(sel):
				var p = getTypedParent( StyledElement );
				while( p!=null && p.parentElement != null ) {
					p = p.getTypedParent( StyledElement );
					if( p!=null && p.matchSelector(sel) ) return true;
				}
				return false;

			case Preceding(sel):
				if( parentElement==null ) return false;
				// FIXME: maybe implement children as a doubly-linked list?
				var prev:Node = null;
				for( c in parentElement.mChildren ) {
					if( c==this ) {
						if( prev==null ) return false;
						return( Std.is( prev, StyledElement ) 
							&& cast(prev).matchSelector(sel) );
					}
					prev=c;
				}
				return false;

			default:
				return false;
				
		}
		return false;
	}
}
