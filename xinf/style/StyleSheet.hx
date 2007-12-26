/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

import xinf.style.Selector;
import xinf.traits.TraitAccess;

/**
	A single style rule of a CSS stylesheet.
	
	[style] has values still as text, 
	as returned by $xinf.style.StyleParser$.parseToObject.
*/
typedef StyleRule = {
    var selector:Selector;
    var style:Dynamic;
}


/**
	Typedef for "stylable" objects, used only
	for $xinf.style.StyleSheet::match$.
	
	$xinf.style.StyledElement$ fits the description.
*/
typedef Stylable = {
	function matchSelector(s:Selector):Bool;
}


/**
	A CSS-like stylesheet.
	
	DOCME:
	Best, describe where xinf (still) lacks from CSS-2.
	
	$CSS cover CSS 2 Specification$
*/
class StyleSheet {

	/**
		The default stylesheet. It is always applied,
		with lowest priority.
	*/
    public static var DEFAULT:StyleSheet = new StyleSheet();
	
	private var rules :Array<StyleRule>;
	
	/**
		Create a new StyleSheet, either empty or filled
		with the rules given in [rules]. 
	*/
    public function new( ?_rules:Iterable<StyleRule> ) :Void {
        rules = new Array<StyleRule>();
		if( _rules!=null ) addMany( _rules );
    }
	
	/**
		Parse a textual CSS stylesheet to the end 
		of this StyleSheet.
	*/
	public function parseCSS( data:String ) {
		addMany( StyleParser.parseRules( data ) );
	}
	
	/**
		Add a single StyleRule to the end of this StyleSheet.
	*/
    public function add( rule:StyleRule ) {
		var s = Reflect.empty();
		for( field in Reflect.fields(rule.style) ) {
			var field2 = StringTools.replace( field, "_", "-" );
			Reflect.setField( s, field2, Reflect.field(rule.style,field) );
		}
		rules.push( { selector:rule.selector, style:s } );
    }
	
	/**
		Add a number of StyleRules to the end of this StyleSheet.
	*/
	public function addMany( _rules:Iterable<StyleRule> ) {
		for( rule in _rules )
			add( rule );
	}

	/**
		Match the given object [e] against the rules found
		in this, or the default, StyleSheet.
		
		Matching styles are aggregated into a single dynamic
		object, with the property values still unparsed text
		(as returned by $xinf.style.StyleParser::parseToObject$.
		
		Priorities are not as elaborate as stipulated by CSS2: 
		simply, rules that come last always have higher priority.
		
		Rules from the DEFAULT StyleSheet are also applied (with
		lower priority than the ones found in this StyleSheet).
	*/
    public function match( e:Stylable ) :Dynamic {
		var a = new Array<Dynamic>();
		
		if( DEFAULT != null ) {
			for( rule in DEFAULT.rules ) {
				if( e.matchSelector( rule.selector ) ) {
					a.push( rule.style );
				}
			}
		}
		
		for( rule in rules ) {
			if( e.matchSelector( rule.selector ) ) {
				a.push( rule.style );
			}
		}
		
		// consolidate
		var r = Reflect.empty();
		for( style in a ) {
			for( field in Reflect.fields(style) ) {
				Reflect.setField( r, field,
					Reflect.field( style, field ));
			}
		}
        return r;
    }
	
}
