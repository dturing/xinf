/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

class TraitTypeException {
	public var message:String;
	
	public function new( name:String, obj:TraitAccess, value:Dynamic, expected:Class<Dynamic> ) {
		message = "Trait '"+name+"' in "+obj+" is of wrong type: "+Type.getClassName(Type.getClass(value))
			+" ('"+value+"'), expect "+Type.getClassName(expected);
	}

	public function toString() :String {
		return( message );
	}
}
