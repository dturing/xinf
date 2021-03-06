/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;
import xinf.style.StyledElement;
import xinf.style.StyleSheet;
import xinf.style.Selector;
import xinf.event.SimpleEvent;

import xinf.erno.TextFormat;
import xinf.ony.type.Paint;
import xinf.ony.type.StringList;
import xinf.ul.skin.Skin;

import xinf.ony.traits.StringListTrait;
import xinf.traits.StringTrait;
import xinf.traits.FloatTrait;
import xinf.ony.traits.PaintTrait;
import xinf.ul.BorderTrait;

class Component extends StyledElement {
	public static function init() {
		Root.getRootSvg();
		StyleSheet.DEFAULT.parseCSS( "
			
			.xinful {
				font-size: 12;
/* FIXME: this slows down initialization, heavily:
		font-family: sans; */
			}
			
			text, TextArea {
				fill: black;
			}
			
			* {
				focus-color: #4e9a06;
				min-width: 75px;
				min-height: 25px;
			}
			
			RoundRobin {
				line-increment: 18.;
			}
			
			.Container, .Interface {
				padding: 3;
			}

			.:focus {
				skin: focus;
			}
			
			.Cursor {
				fill: #4e9a06;
			}

			.Button, .Dropdown {
				padding: 6 3 6 3;
			}

			.Button.:press {
				skin: focus-bright;
				padding: 6 4 6 2;
			}
			
			.CheckBox {
				border: 0;
				padding: 0 3 6 3;
				skin: none;
			}

			.ListView, .TreeView {
				min-height: 75px;
				padding: 6 3;
			}
			
			.TreeView polygon {
				fill: darkgray;
			}

			.Table {
				min-width: 300px;
				min-height: 375px;
				padding: 6 3;
			}

			.VScrollbar {
				skin: ;
			}

			.LineEdit {
				min-width: 100;
				padding: 5 2 5 2;
			}
		
			.LineEdit.:focus {
				skin: focus-bright;
			}
			
			.Label {
				min-width: 20;
			}
			
		");
	}
	
	static var TRAITS = {
		skin:			new StringTrait(),
		horizontalalign:	new FloatTrait(),
		verticalalign:		new FloatTrait(),
		border:				new BorderTrait(),
		padding:			new BorderTrait(),
		margin:				new BorderTrait(),
		minwidth:			new LengthTrait(),
		maxwidth:			new LengthTrait(new Length(Math.POSITIVE_INFINITY)),
		minheight:			new LengthTrait(),
		maxheight:			new LengthTrait(new Length(Math.POSITIVE_INFINITY)),
		focuscolor:			new PaintTrait(Paint.None),
	};

	public var skin(get_skin,set_skin):String;
	function get_skin() :String { return getStyleTrait("skin",String); }
	function set_skin( v:String ) :String { return setStyleTrait("skin",v); }

	public var horizontalAlign(get_horizontal_align,set_horizontal_align):Float;
	function get_horizontal_align() :Float { return getStyleTrait("horizontalalign",Float); }
	function set_horizontal_align( v:Float ) :Float { return setStyleTrait("horizontalalign",v); }

	public var verticalAlign(get_vertical_align,set_vertical_align):Float;
	function get_vertical_align() :Float { return getStyleTrait("verticalalign",Float); }
	function set_vertical_align( v:Float ) :Float { return setStyleTrait("verticalalign",v); }

	public var border(get_border,set_border):Border;
	function get_border() :Border { return getStyleTrait("border",Border); }
	function set_border( v:Border ) :Border { return setStyleTrait("border",v); }

	public var padding(get_padding,set_padding):Border;
	function get_padding() :Border { return getStyleTrait("padding",Border); }
	function set_padding( v:Border ) :Border { return setStyleTrait("padding",v); }

	public var margin(get_margin,set_margin):Border;
	function get_margin() :Border { return getStyleTrait("margin",Border); }
	function set_margin( v:Border ) :Border { return setStyleTrait("margin",v); }

	public var minWidth(get_min_width,set_min_width):Float;
	function get_min_width() :Float { return getStyleTrait("minwidth",Length).value; }
	function set_min_width( v:Float ) :Float { setStyleTrait("minwidth",new Length(v)); return v; }

	public var maxWidth(get_max_width,set_max_width):Float;
	function get_max_width() :Float { return getStyleTrait("max-width",Length).value; }
	function set_max_width( v:Float ) :Float { setStyleTrait("max-width",new Length(v)); return v; }

	public var minHeight(get_min_height,set_min_height):Float;
	function get_min_height() :Float { return getStyleTrait("minheight",Length).value; }
	function set_min_height( v:Float ) :Float { setStyleTrait("minheight",new Length(v)); return v; }

	public var maxHeight(get_max_height,set_max_height):Float;
	function get_max_height() :Float { return getStyleTrait("maxheight",Length).value; }
	function set_max_height( v:Float ) :Float { setStyleTrait("maxheight",new Length(v)); return v; }

	public var focusColor(get_focus_color,set_focus_color):Paint;
	function get_focus_color() :Paint { return getStyleTrait("focuscolor",Paint); }
	function set_focus_color( v:Paint ) :Paint{ return setStyleTrait("focuscolor",v); }

	static var highestId:Int = 0;
	public var __parentSizeListener:Dynamic;

	public var parent(default,null):Container;
	
	public var prefSize(getPrefSize,null):TPoint;
	var _prefSize:TPoint;
	
	var _skin:Skin;
	
	public var size(get_size,set_size):TPoint;
	public var position(default,set_position):TPoint; // TODO!
	var group:Group;
	
	public var cid(default,null):Int;

	public function new( ?traits:Dynamic ) :Void {
		super(traits);
		cid = highestId++;
		
		group = new Group();

		_prefSize = { x:.0, y:.0 };
		position = { x:.0, y:.0 };
		_skin = new xinf.ul.skin.SimpleSkin();

		// add our own class to the list of style classes
		var clNames:Array<String> = Type.getClassName(Type.getClass(this)).split(".");
		addStyleClass( clNames[ clNames.length-1 ] );
		// and for the group, too
		group.addStyleClass( clNames[ clNames.length-1 ] );
		// and have the group be of "xinful" class
		group.addStyleClass( "xinful" );
	}
	
	public function getTextFormat() {
		var family = group.fontFamily;
		var size = group.fontSize;
		var format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
		return format;
	}
		
	override public function styleChanged( ?attr:String ) :Void {
		super.styleChanged( attr );
		_skin.setTo( skin, this );
	}

	override function setOwnerDocument( doc:Document ) {
		super.setOwnerDocument(doc);
		untyped group.setOwnerDocument(doc); //FIXME 
	}

	public function getPrefSize() :TPoint {
		return( _prefSize );
	}
	
	public function setPrefSize( n:TPoint ) :TPoint {
		var s = n; //addPadding(n);
		if( _prefSize==null || s.x!=_prefSize.x || s.y!=_prefSize.y ) {
			_prefSize = s;
			postEvent( new ComponentSizeEvent( ComponentSizeEvent.PREF_SIZE_CHANGED, _prefSize.x, _prefSize.y, this ) );
		}
		return( _prefSize );
	}
	
	// perform the actual resizing, called by the layout manager
	public function set_size( s:TPoint ) :TPoint {
		size = s;
		_skin.resize( s );
		return s;
	}
	public function get_size() :TPoint {
		if( size==null ) return _prefSize;
		return size;
	}
	
	public function set_position( p:TPoint ) :TPoint {
		position = p;
		if( group!=null ) {
			group.transform = new Translate(p.x,p.y);
		}
		return( p );
	}

	public function getElement() :Element {
		return group;
	}

}
