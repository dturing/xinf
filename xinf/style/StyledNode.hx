package xinf.style;

import xinf.xml.Node;
import xinf.traits.TraitException;

class StyledNode extends Node {

	var _style:Dynamic;
	var _cache:Dynamic;
	
	public function new( traits:Dynamic ) {
		super(traits);
		_style = Reflect.empty();
		_cache = Reflect.empty();
	}
	
	override public function setStyleTrait<T>( name:String, value:T ) :T {
		var r = setTrait( name, value );
		Reflect.setField(_cache,name,r);
		styleChanged();
		return r;
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

	override public function fromXml( xml:Xml ) :Void {
		super.fromXml( xml );

		if( xml.exists("style") ) {
			StyleParser.parse( xml.get("style"), this, _style );
		}

		styleChanged();
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
	public function matchSelector( s:Selector ) :Bool {
		return false;
	}
	
	// hook
    public function styleChanged() :Void {
	}
}
