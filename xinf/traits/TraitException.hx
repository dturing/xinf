package xinf.traits;

// move this out if ever needed elsewhere
class Exception {
	public var message:String;
	
	public function new( ?msg:String ) {
		message=msg;
	}
	
	public function toString() :String {
		return( message );
	}
}

class TraitException extends Exception {
}

class TraitNotFoundException extends TraitException {
	public function new( name:String, obj:TraitAccess ) {
		super("Trait '"+name+"' not found in "+obj);
	}
}

class TraitTypeException extends TraitException {
	public function new( name:String, obj:TraitAccess, value:Dynamic, expected:Class<Dynamic> ) {
		super("Trait '"+name+"' in "+obj+" is of wrong type.");
	}
}
