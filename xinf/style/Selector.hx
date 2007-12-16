package xinf.style;

enum Selector {
	Any;
	
	ClassName( name:String );
	StyleClass( name:String );
	ById( id:String );
	
	AnyOf( a:Iterable<Selector> );
	AllOf( a:Iterable<Selector> );

	Parent( s:Selector );
	Ancestor( s:Selector );
	GrandAncestor( s:Selector );
	Preceding( s:Selector );
	
	Unknown( text:String );
}
