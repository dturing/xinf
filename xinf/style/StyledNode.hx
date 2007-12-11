package xinf.style;

import xinf.xml.Node;
import xinf.traits.TraitException;

class StyledNode extends Node {

	var _style:Dynamic;
	
	public function new( traits:Dynamic ) {
		super(traits);
		_style = Reflect.empty();
	}
	
	public function setStyleTrait<T>( name:String, value:T ) :T {
		var r = setTrait( name, value );
		styleChanged();
		return r;
	}
	
	public function getStyleTrait<T>( name:String, type:Dynamic, ?inherit:Bool ) :T {
		if( inherit==null ) inherit=true;
		
		// lookup XML attribute
		var v = Reflect.field(_traits,name);
		if(v!=null) {
			if( Std.is(v,type) ) return v;
			throw( new TraitTypeException( name, this, v, type ) );
		}
		
		// lookup in style attribute
		v = Reflect.field(_style,name);
		if(v!=null) {
			if( Std.is(v,type) ) return v;
			throw( new TraitTypeException( name, this, v, type ) );
		}
		
		// inherited.. (no update- FIXME/TODO/MAYBE)
		if( inherit ) {
			var p = getStyleParent();
			if( p!=null ) return p.getStyleTrait( name, type, inherit );
		}
		
		// default.
		var def = getTraitDefinition(name);
		if( def!=null ) {
			return def.getDefault();
		}
		return null;
	}

	override public function fromXml( xml:Xml ) :Void {
		super.fromXml( xml );
		// TODO parse @style
		styleChanged();
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
