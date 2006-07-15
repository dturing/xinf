package xinf.style;

import xinf.ony.Element;
import xinf.style.Style;
import xinf.style.StyleClassElement;

class StyleSelector {
	public function matches( e:Element ) :Bool {
		return true;
	}
}

class ClassNameSelector extends StyleSelector {
	var classes:Array<String>;

	public function new( c:Array<String> ) :Void {
		classes = c;
	}
	
	override public function matches( _e:Element ) :Bool {
		if( !Std.is(_e,StyleClassElement) ) return false;
		var e:StyleClassElement = cast( _e, StyleClassElement );
		for( c in classes ) {
			if( !e.hasStyleClass(c) ) return false;
		}
		return true;
	}
}

class AncestorSelector extends StyleSelector {
	private var selector:StyleSelector;

	public function new( s:StyleSelector ) :Void {
		selector=s;
	}

	override public function matches( e:Element ) :Bool {
		var p = e.parent;
		while( p != null ) {
			if( selector.matches(p) ) {
				return true;
			}
			p = p.parent;
		}
		return false;
	}
}

class ParentSelector extends StyleSelector {
	private var selector:StyleSelector;

	public function new( s:StyleSelector ) :Void {
		selector=s;
	}

	override public function matches( e:Element ) :Bool {
		return( e.parent != null && selector.matches(e.parent) );
	}
}

class CombinedSelector extends StyleSelector {
	private var selectors:Array<StyleSelector>;

	public function new( s:Array<StyleSelector> ) :Void {
		selectors = s;
	}
	
	override public function matches( e:Element ) :Bool {
		for( s in selectors ) {
			if( !s.matches( e ) ) return false;
		}
		return true;
	}
}

signature StyleRule {
	var selector:StyleSelector;
	var style:Style;
}

class StyleSheet {
	public static var defaultStyle:Style;
	public static var defaultSheet:StyleSheet;
	public static function __init__() :Void {
		defaultStyle = newDefaultStyle();
		defaultSheet = new StyleSheet();
	}
	
	private var byClassName :Hash<List<StyleRule>>;
	public function new() :Void {
		byClassName = new Hash<List<StyleRule>>();
	}
	
	public function add( classNames:Array<String>, ?otherSelector:StyleSelector, style:Style ) {
		var selector:StyleSelector = new ClassNameSelector(classNames);
		if( otherSelector != null ) {
			selector = new CombinedSelector( [ selector, otherSelector ] );
		}
		var rule = {
			selector:selector,
			style:style
		};
		var l = byClassName.get(classNames[0]);
		if( l==null ) {
			l = new List<StyleRule>();
			byClassName.set( classNames[0], l );
		}
		l.push( rule );
	}
	
	private function findStyles( e:StyleClassElement ) :Iterator<Style> {
		var primary:List<StyleRule> = null;
		var i=0;
		var classNames = e.getStyleClasses();
		while( i<classNames.length && primary==null ) {
			primary = byClassName.get( classNames[i] );
			i++;
		}
		if( primary==null ) return null;
		
		var styles = new List<Style>();
		for( rule in primary ) {
			if( rule.selector.matches(e) ) styles.push( rule.style );
		}
		return styles.iterator();
	}
	
	private function aggregateStyles( styles:Iterator<Style> ) :Style {
		var r = newDefaultStyle();
		if( styles == null ) return r;
		for( style in styles ) {
			for( field in Reflect.fields(style) ) {
				var v = Reflect.field(style, field);
				if( v != null ) {
					Reflect.setField( r, field, v );
				}
			}
		}
		return r;
	}
	
	public function match( e:StyleClassElement ) :Style {
		return aggregateStyles( findStyles( e ) );
	}
	
	
	private static function newDefaultStyle():Style {
		return {
			padding: { l:0, t:0, r:0, b:0 },
			border: { l:0, t:0, r:0, b:0 },
			color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
			background: null,
			minWidth: null,
			skin: null,
			textAlign: 0, verticalAlign: 0
		};
	}
}
