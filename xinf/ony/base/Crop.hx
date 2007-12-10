package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.traits.TraitDefinition;
import xinf.traits.FloatTrait;

class Crop extends GroupImpl {

	static var TRAITS:Hash<TraitDefinition>;
	static function __init__() {
		TRAITS = new Hash<TraitDefinition>();
		for( trait in [
			new FloatTrait("width",0.),
			new FloatTrait("height",0.),
		] ) { TRAITS.set( trait.name, trait ); }
	}

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Float); }
    function set_width( v:Float ) :Float { redraw(); return setTrait("width",v); }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Float); }
    function set_height( v:Float ) :Float { redraw(); return setTrait("height",v); }

}