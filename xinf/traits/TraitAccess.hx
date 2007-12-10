package xinf.traits;

interface TraitAccess {
	function getTrait<T>( name:String, type:Class<T> ) :T;
	function setTrait<T>( name:String, value:T ) :T;
	function setTraitFromString( name:String, value:String ) :String;
	
	function getTraitDefinition( name:String ) :TraitDefinition;
}