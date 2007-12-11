package xinf.traits;

interface TraitAccess {
	function getTrait<T>( name:String, type:Dynamic ) :T;
	function setTrait<T>( name:String, value:T ) :T;
	function getStyleTrait<T>( name:String, type:Dynamic, ?inherit:Bool ) :T;
	function setStyleTrait<T>( name:String, value:T ) :T;
	function setTraitFromString( name:String, value:String, ?to:Dynamic ) :String;
	
	function getTraitDefinition( name:String ) :TraitDefinition;
}