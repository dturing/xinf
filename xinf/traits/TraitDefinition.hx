package xinf.traits;

import xinf.erno.Color;

interface TraitDefinition {
    function parseAndSet( name:String, value:String, obj:TraitAccess ) :Void;
	function getDefault() :Dynamic;
}
