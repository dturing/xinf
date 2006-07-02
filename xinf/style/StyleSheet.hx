package xinf.style;

import xinf.style.Style;

signature StyleRule {
	var classes:Array<String>;
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
	
	public function add( classNames:Array<String>, style:Style ) {
		var rule = {
			classes:classNames,
			style:style
		};
		
		var l = byClassName.get(classNames[0]);
		if( l==null ) {
			l = new List<StyleRule>();
			byClassName.set( classNames[0], l );
		}
		l.push( rule );
	}
	
	private function findStyles( classNames:Array<String> ) :Iterator<Style> {
		var primary:List<StyleRule> = null;
		var i=0;
		while( i<classNames.length && primary==null ) {
			primary = byClassName.get( classNames[i] );
			i++;
		}
		if( primary==null ) return null;
		
		var styles = new List<Style>();
	//	styles.push( defaultStyle );
		for( rule in primary ) {
			var match:Bool = true;
			for( c in rule.classes ) {
				var match2:Bool = false;
				for( className in classNames ) {
					if( className == c ) match2=true;
				}
				if( match2 == false ) match=false;
			}
			if( match ) styles.push( rule.style );
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
	
	public function match( classNames:Array<String> ) :Style {
		return aggregateStyles( findStyles( classNames ) );
	}
	
	
	private static function newDefaultStyle():Style {
		return {
			padding: { l:0, t:0, r:0, b:0 },
			border: { l:0, t:0, r:0, b:0 },
			color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
			background: null,
			minWidth: null,
			skin: null,
			textAlign: 0
		};
	}
}
