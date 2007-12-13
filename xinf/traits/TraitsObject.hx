package xinf.traits;

import xinf.traits.TraitException;

class TraitsObject implements TraitAccess {

	var _traits:Dynamic;
	
	public function new( ?traits:Dynamic ) {
		if( traits ) _traits=traits;
		else _traits = Reflect.empty();
	}
	
	public function getTrait<T>( name:String, type:Dynamic ) :T {
		var v = Reflect.field(_traits,name);
		if(v!=null) {
			if( Std.is(v,type) ) {
				return v;
			}
			throw( new TraitTypeException( name, this, v, type ) );
		}
		
		var def = getTraitDefinition(name);
		if( def!=null ) {
			var d = def.getDefault();
			return d;
		}
		
		return null;
	}

	public function setTrait<T>( name:String, value:T ) :T {
		Reflect.setField(_traits,name,value);
		return value;
	}

	public function setStyleTrait<T>( name:String, value:T ) :T {
		return setTrait(name,value);
	}

	public function getStyleTrait<T>( name:String, value:T, ?inherit:Bool ) :T {
		return setTrait(name,value);
	}

	public function setTraitFromString( name:String, value:String, ?to:Dynamic ) :String {
		var def = getTraitDefinition(name);
		if( to==null ) to=_traits;
		Reflect.setField( to, name, def.parse(value) );
		return value;
	}
	
	public function setTraitsFromObject( o:Dynamic ) {
		for( field in Reflect.fields(o) ) {
			setTrait( field, Reflect.field(o,field) );
		}
	}

	public function setTraitsFromXml( xml:Xml ) {
		for( field in xml.attributes() ) {
			try {
				setTraitFromString( field, xml.get(field) );
			} catch( e:TraitNotFoundException ) {
//				trace("Trait not found: "+name );
			}
		}
	}
	
	public function getTraitDefinition( _name:String ) :TraitDefinition {
		var name = StringTools.replace(_name,"-","_");
		var cl:Class<Dynamic> = Type.getClass( this );
		var t:TraitDefinition;
		while( t==null && cl!=null ) {
			t = getClassTrait( cl, name );
			cl = Type.getSuperClass(cl);
		}
		if( t==null ) throw( new TraitNotFoundException(name,this) );
		return t;
	}
	
	function getClassTrait( cl, name:String ) :TraitDefinition {
		var traits:Dynamic = Reflect.field(cl,"TRAITS");
		if( traits!=null ) return Reflect.field(traits,name);
		return null;
	}
	
}
