/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.traits;

class DynamicTrait extends TypedTrait<Dynamic> {

	var def:String;
	
	public function new( ?def:Dynamic ) {
		super( Dynamic );
		this.def=def;
	}

	override public function parse( value:String ) :Dynamic {
		return StringTools.trim(value);
	}

	override public function getDefault() :Dynamic {
		return def;
	}

}
