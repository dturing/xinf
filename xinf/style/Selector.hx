/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

/**
	CSS selectors enum.
	
	$CSS selector# CSS: Selectors$
*/
enum Selector {
	/** Match any element ("[*]").
		$CSS selector#universal-selector Universal selector$ */
	Any;
	
	/** Match elements with tag name [name].
		$CSS selector#type-selectors Type selectors$ */
	ClassName( name:String );
	
	/** Match elements with style class [name] ("[.name]")
		$CSS selector#class-html Class selectors$ */
	StyleClass( name:String );
	
	/** Match the element with id [id] ("[#id]")
		$CSS selector#id-selectors ID selectors$ */
	ById( id:String );
	
	
	/** Match if any of the selectors in [a] match. 
		$CSS selector#grouping Grouping$ */
	AnyOf( a:Iterable<Selector> );
	
	/** Match if all of the selectors in [a] match. */
	AllOf( a:Iterable<Selector> );

	/** Match if the element's parent matches 
		the given Selector [s]. ("[a > b]")
		$CSS selector#child-selectors Child selectors$ */
	Parent( s:Selector );
	
	/** Match if the element has an ancestor
		that matches the given Selector [s]. ("[a b]")
		$CSS selector#descendant-selectors Descendant selectors$ */
	Ancestor( s:Selector );

	/** Match if the element has an ancestor
		that is not it's immediate parent and
		matches the given Selector [s]. 
		("[a * b]") 
		$CSS selector#descendant-selectors Descendant selectors$ */
	GrandAncestor( s:Selector );
	
	/** Match if the element just before the element
		in question matches the given Selector [s]. 
		("[a + b]") 
		$CSS selector#adjacent-selectors Adjacent sibling selectors$ */
	Preceding( s:Selector );
	
	/** Unknown selector. Behaviour is undefined. */
	Unknown( text:String );
}
