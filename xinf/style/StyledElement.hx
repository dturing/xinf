/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

import xinf.xml.Node;
import xinf.xml.Element;
import xinf.traits.TraitException;
import xinf.traits.SpecialTraitValue;

class StyledElement extends Element {

	var styleClasses :Hash<Bool>;
	var _style:Dynamic;
	var _cache:Dynamic;
	var _matchedStyle:Dynamic;
	
	public function new( traits:Dynamic ) {
		super(traits);
		_style = Reflect.empty();
		_cache = Reflect.empty();
		_matchedStyle = Reflect.empty();
		styleClasses = new Hash<Bool>();
	}
	
	override public function setStyleTrait<T>( name:String, value:T ) :T {
		var r = setTrait( name, value );
		Reflect.setField(_cache,name,r);
		styleChanged();
		return r;
	}

	function clearTraitsCache() {
		_cache = Reflect.empty();
	}

	override public function getStyleTrait<T>( name:String, type:Dynamic, ?inherit:Bool ) :T {
		if( Reflect.hasField(_cache,name) ) return Reflect.field(_cache,name);
		
		#if profile
			xinf.test.Counter.count("getStyleTrait("+name+")");
		#end

		if( inherit==null ) inherit=true;
		
		// lookup XML attribute
		var v = Reflect.field(_traits,name);

		// lookup in style attribute FIXME: maybe, there is no difference between attributes and @style?
		if( v==null ) v = Reflect.field(_style,name);
		
		// lookup in matched style
		if( v==null ) v = Reflect.field(_matchedStyle,name);
		
		// inherited.. (no update- FIXME/TODO/MAYBE)
		if( inherit && v==null ) {
			var p:StyledElement = getTypedParent(StyledElement);
			if( p!=null ) {
				try {
					v = p.getStyleTrait( name, type, inherit );
				} catch( e:TraitNotFoundException ) {
				}
			}
		}

		if( v!=null ) {
			if( Std.is(v,type) ) {
				Reflect.setField(_cache,name,v);
				return v;
			}
			if( Std.is(v,SpecialTraitValue) ) {
				var v2:SpecialTraitValue = cast(v);
				return( v2.get(name,type,this) );
			}
			throw( new TraitTypeException( name, this, v, type ) );
		}

		// default.
		var def = getTraitDefinition(name);
		if( def!=null ) {
			var d = def.getDefault();
			Reflect.setField(_cache,name,d);
			return d;
		}
		
		return null;
	}
	
	static var ws_split = ~/[ \r\n\t]+/g;
	override public function fromXml( xml:Xml ) :Void {
		super.fromXml( xml );

		if( xml.exists("style") ) {
			StyleParser.parse( xml.get("style"), this, _style );
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

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties(to);
		
		// copy style traits
		to._style = Reflect.copy(_style);
	}

	// hook
    public function styleChanged() :Void {
	}

	// Style class functions
    
	function updateClassStyle() :Void {
		if( ownerDocument!=null && ownerDocument.styleSheet!=null ) {
			clearTraitsCache();
			_matchedStyle = ownerDocument.styleSheet.match(this);
//			trace(""+this+" matched: "+untyped _matchedStyle.padding );
			styleChanged();
		}
    }
	
    public function addStyleClass( name:String ) :Void {
        styleClasses.set( name, true );
        updateClassStyle();
    }
    
    public function removeStyleClass( name:String ) :Void {
        styleClasses.remove( name );
        updateClassStyle();
    }
    
    public function hasStyleClass( name:String ) :Bool {
        return styleClasses.get(name)!=null;
    }

    public function getStyleClasses() :Iterator<String> {
        return styleClasses.keys();
    }
	
	public function getTagName() :String {
		var cl:Class<Dynamic> = Type.getClass(this);
		while( cl!=null ) {
			if( Reflect.hasField(cl,"tagName") ) return Reflect.field(cl,"tagName");
			cl = Type.getSuperClass(cl);
		}
		return null;
	}
	
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
