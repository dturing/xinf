/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

import xinf.traits.TraitAccess;

import xinf.style.StyleSheet;
import xinf.style.Selector;

/**
	The StyleParser class provides static functions
	to parse CSS-type style definitions, selectors
	and rules into xinf types (and intermediate objects).
*/
class StyleParser {
	static var comment = ~/\/\*[^\*]*\*\//g;
    static var split = ~/[ \r\n\t]*;[ \r\n\t]*/g;
	
	/** 
		From a dynamic object with text values as returned by [parseToObject],
		parse individual style properties as defined by [via]'s traits
		definitions, and set the resulting typed values on [to].
	**/
    public static function fromObject( s:Dynamic, via:TraitAccess, to:Dynamic ) :Void {
		for( field in Reflect.fields(s) ) {
			var field2 = StringTools.replace( field, "_", "-" );
			via.setTraitFromDynamic( field2, Reflect.field(s,field), to );
		}
	}

	/**
		Parse a single CSS style definition (as found in a "style" attribute)
		into an dynamic object. The property values are not parsed, but
		retained as Strings (use fromObject to parse/type them).
		
		For example, "[fill:red,stroke:#f00]" will be turned into
		[{ style:"red", stroke:"#f00" }].
	**/
    public static function parseToObject( text:String ) :Dynamic {
		var to = Reflect.empty();
		text = comment.replace(text,"");
        var properties = split.split(text);
        for( prop in properties ) {
            var p = prop.split(":");
            if( p.length==2 ) {
				var name = StringTools.trim(p[0]);
				var value = StringTools.trim(p[1]);
				Reflect.setField( to, name, value );
            } else if( prop.length==0 ) {
            } else {
                throw("invalid CSS: '"+prop+"'" );
            }
        }
		return to;
    }

	static var cssRules = ~/\W*(.*)\W{\W(.*)\W/g;
	
	/** 
		parse CSS style rules, as found in a 
		[<style type="text/css">] element.
	**/
	public static function parseRules( text:String ) :Array<StyleRule> {
		//trace("should parse style: "+text+", defs "+definitions );
		text = comment.replace(text,"");
		
		var rules = new Array<StyleRule>();
		
		var ruleTexts = text.split("}");
		for( ruleText in ruleTexts ) {
			var sr = ruleText.split("{");
			if( sr.length==2 ) {
				var selText = StringTools.trim(sr[0]);
				var styleText = StringTools.trim(sr[1]);
				
				// TODO parse selector
				var sel = parseSelectorGroup( selText );
				
				var s:Dynamic = parseToObject( styleText );
				
				trace(""+sel+" "+s );
				rules.push( { selector:sel, style:s } );

			} else {
				if( StringTools.trim(ruleText).length>0 )
					throw("ignore non-CSS '"+ruleText+"'");
			}
		}
		
		return rules;
	}

    static var comma_split = ~/[ \r\n\t]*,[ \r\n\t]*/g;
    static var ws_split = ~/[ \r\n\t]+/g;
	static var first_s = ~/([^ ]+) (([\*\+>]) )?(.+)/;
    
	/**
		Parse a CSS selector
	**/
	static function parseSelectorGroup( text:String ) :Selector {
		var anyTexts = comma_split.split(text);
		var any = new Array<Selector>();
		for( a in anyTexts ) {
			if( a.length>0 ) {
				any.push( parseSelector( a ) );
			}
		}
		if( any.length==1 ) return any[0];
		return AnyOf( any );
	}

	static function parseSelector( text:String, ?already:Selector ) :Selector {
		
		if( first_s.match(text) ) {
			// hierarchical
			
			var a_s = first_s.matched(1);
			var b = first_s.matched(4);
			var op = first_s.matched(3);
			var a = parseCombinedSelector( a_s );
			
			var a2 = if( already!=null ) AllOf([ already, a ]) else a;
			var a3 = switch( op ) {
				case "":
					Ancestor(a2);
				case null:
					Ancestor(a2);
				case "+":
					Preceding(a2);
				case ">":
					Parent(a2);
				case "*":
					GrandAncestor(a2);
				default:
					trace("a: "+a+", b: "+b+", op: "+op );
					throw("unknown style selector operator '"+op+"'");
					Unknown(op);
			}
			return parseSelector( b, a3 );
		} else {
			// single/combined selector
			var thisSelector = parseCombinedSelector(text);
			if( already!=null ) return AllOf([ already, thisSelector ]);
			return thisSelector;
		}
	}
	
	static function parseCombinedSelector( text:String ) :Selector {
		var allTexts = ws_split.split(text);
		var all = new Array<Selector>();
		for( a in allTexts ) {
			if( a.length>0 ) {
				parseSingleSelector( a, all );
			}
		}
		if( all.length==1 ) return all[0];
		return AllOf( all );
	}

	static var classSel = ~/\.([:a-zA-Z0-9\-]*)/; // FIXME: ':' is in there for now. parse :pseudos as StyleClass(:pseudo) 
	static var idSel = ~/#([a-zA-Z0-9\-]*)/;
	static function parseSingleSelector( text:String, list:Array<Selector> ) :Void {
		if( classSel.match(text) ) {
			list.push( StyleClass( classSel.matched(1) ) );
			parseSingleSelector( classSel.matchedLeft()+classSel.matchedRight(), list );
			return;
		}
		if( idSel.match(text) ) {
			list.push( ById( idSel.matched(1) ) );
			parseSingleSelector( idSel.matchedLeft()+idSel.matchedRight(), list );
			return;
		}
		if( text=="*" ) {
			list.push(Any);
			return;
		}
		if( StringTools.trim(text).length>0 ) {
			list.push( ClassName( text ) );
		}
	}

}
