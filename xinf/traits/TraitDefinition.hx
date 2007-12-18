/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

interface TraitDefinition {
    function parse( value:String ) :Dynamic;
	function getDefault() :Dynamic;
}
