/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

import xinf.style.Selector;
import xinf.traits.TraitAccess;

typedef StyleRule = {
    var selector:Selector;
    var style:Dynamic;
}

typedef Stylable = {
	function matchSelector(s:Selector):Bool;
}


class StyleSheet {

    public static var DEFAULT:StyleSheet = new StyleSheet();
	
	private var rules :Array<StyleRule>;
	
    public function new( ?d:Iterable<StyleRule> ) :Void {
        rules = new Array<StyleRule>();
		if( d!=null ) addMany( d );
    }
	
	public function parseCSS( data:String, via:TraitAccess ) {
		addMany( StyleParser.parseRules( data, via ) );
	}
	
    public function add( rule:StyleRule ) {
		var s = Reflect.empty();
		for( field in Reflect.fields(rule.style) ) {
			var field2 = StringTools.replace( field, "_", "-" );
			Reflect.setField( s, field2, Reflect.field(rule.style,field) );
		}
		rules.push( { selector:rule.selector, style:s } );
    }
	
	public function addMany( _rules:Iterable<StyleRule> ) {
		for( rule in _rules )
			add( rule );
	}

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
