package xinf.traits;

import xinf.traits.TraitException;

class TraitsObject implements TraitAccess {
	public function getTrait<T>( name:String, type:Class<T> ) :T {
		var v = Reflect.field(this,name);
		if(v!=null) {
			if( Std.is(v,type) ) return v;
			throw( new TraitTypeException( name, this, v, type ) );
		}
		var def = getTraitDefinition(name);
		if( def!=null ) {
			return def.getDefault();
		}
		return null;
	}
	public function getCSSTrait<T>( name:String, type:Class<T>, obj:Stylable, ?inherit:Bool ) :T {
		var v = Reflect.field(this,name);
		if(v!=null) {
			if( Std.is(v,type) ) return v;
			throw( new TraitTypeException( name, this, v, type ) );
		}
/*
		var style = obj.style;
		v = Reflect.field(obj.style,name);
		if(v!=null) {
			if( Std.is(v,type) ) return v;
			throw( new TraitTypeException( name, this, v, type ) );
		}
		
		if( inherit ) {
			style = obj.getParentStyle();
		v = Reflect.field(this,name);
		if(v!=null) {
			if( Std.is(v,type) ) return v;
			throw( new TraitTypeException( name, this, v, type ) );
		}
*/
		var def = getTraitDefinition(name);
		if( def!=null ) {
			return def.getDefault();
		}
		return null;
	}
	public function setTrait<T>( name:String, value:T ) :T {
		Reflect.setField(this,name,value);
		return value;
	}
	public function setTraitFromString( name:String, value:String ) :String {
		var def = getTraitDefinition(name);
		def.parseAndSet( value, this );
		return value;
	}
	
	public function setTraitsFromObject( o:Dynamic ) {
		for( field in Reflect.fields(o) ) {
			setTrait( field, Reflect.field(o,field) );
		}
	}
	
	public function setTraitsFromXml( xml:Xml ) {
		try {
			for( field in xml.attributes() ) {
				setTraitFromString( field, xml.get(field) );
			}
		} catch( e:TraitNotFoundException ) {
		}
	}
	
	public function getTraitDefinition( name:String ) :TraitDefinition {
		var cl:Class<Dynamic> = Type.getClass( this );
		var t:TraitDefinition;
		var t = getClassTrait( cl, name );
		while( t==null && cl!=null ) {
			cl = Type.getSuperClass(cl);
			t = getClassTrait( cl, name );
		}
		if( t==null ) throw( new TraitNotFoundException(name,this) );
		return t;
	}
	function getClassTrait( cl, name:String ) :TraitDefinition {
		var h:Hash<TraitDefinition> = cast( Reflect.field(cl,"TRAITS") );
		if( h!=null ) return h.get(name);
		return null;
	}
}
