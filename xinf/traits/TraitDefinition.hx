package xinf.traits;

import xinf.erno.Color;

interface TraitDefinition {
    function parse( value:String ) :Dynamic;
	function getDefault() :Dynamic;
}
