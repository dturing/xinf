package xinf.style;

import xinf.xml.Node;
import xinf.traits.TraitException;

class StyledNode extends Node {

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
		if(v!=null) {
			if( Std.is(v,type) ) {
				Reflect.setField(_cache,name,v);
				return v;
			}
			throw( new TraitTypeException( name, this, v, type ) );
		}

		// lookup in style attribute
		v = Reflect.field(_style,name);
		if(v!=null) {
			if( Std.is(v,type) ) {
				Reflect.setField(_cache,name,v);
				return v;
			}
			throw( new TraitTypeException( name, this, v, type ) );
		}
		
		// lookup in matched style
		v = Reflect.field(_matchedStyle,name);
		if(v!=null) {
			if( Std.is(v,type) ) {
				Reflect.setField(_cache,name,v);
				return v;
			}
			throw( new TraitTypeException( name, this, v, type ) );
		}
		
		
		// inherited.. (no update- FIXME/TODO/MAYBE)
		if( inherit ) {
			var p = getStyleParent();
			if( p!=null ) {
				try {
					v = p.getStyleTrait( name, type, inherit );
					Reflect.setField(_cache,name,v);
					return v;
				} catch( e:TraitNotFoundException ) {
				}
			}
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
	public function getStyleParent() :StyledNode {
		return null;
	}
		
	// hook
    public function styleChanged() :Void {
	}

	// hook
    public function updateClassStyle() :Void {
    }
	
	// Style class functions
    
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
				
			default:
				return false;
				
		}
		return false;
	}
}
