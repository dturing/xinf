package xinf.traits;

import xinf.erno.Color;

interface TraitDefinition {
    var name:String;
    function parseAndSet( value:String, obj:TraitAccess ) :Void;
	function getDefault() :Dynamic;
}
