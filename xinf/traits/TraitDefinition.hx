/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

interface TraitDefinition {
    function parse( value:String ) :Dynamic;
	function fromDynamic( value:Dynamic ) :Dynamic;
	function getDefault() :Dynamic;
	
	// FIXME: these really here?
	function interpolate( a:Dynamic, b:Dynamic, f:Float ) :Dynamic;
	function distance( a:Dynamic, b:Dynamic ) :Float;
	function add( a:Dynamic, b:Dynamic ) :Dynamic;
}
