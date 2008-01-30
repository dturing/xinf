/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

interface TraitAccess {
	function getTrait<T>( name:String, type:Dynamic, ?presentation:Bool ) :T;
	function setTrait<T>( name:String, value:T ) :T;
	function getStyleTrait<T>( name:String, type:Dynamic, ?inherit:Bool, ?presentation:Bool ) :T;
	function setStyleTrait<T>( name:String, value:T ) :T;
	
	function setTraitFromString( name:String, value:String, to:Dynamic ) :Void;
	function setTraitFromDynamic( name:String, value:Dynamic, to:Dynamic ) :Void;
	
//	function getTraitDefinition( name:String ) :TraitDefinition;
}