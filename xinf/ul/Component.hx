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
			* {
				font-size: 12;
			}
			
			.Button {
				border: 1;
				padding: 6 3 6 3;
			}

			.Label {
				padding: 6 3 6 3;
			}

			.Button, .Dropdown, .LineEdit, .Slider {
				min-height: 16;
				min-width: 75;
			}
			
			.Interface {
				horizontal-align: 0.;
				vertical-align: 0.;
			}
			
			.Container, .Interface {
				padding: 5;
			}
			
			.ListView {
				min-width: 100;
				min-height: 75;
			}
			
			.:focus {
				skin: focus;
				border: 2;
				padding: 5 2 5 2;
			}
			
			.Button.:press, .LineEdit.:focus {
				skin: focus-bright;
				padding: 5 3 5 1;
			}
			
		");
	}
	
	static var TRAITS = {
		skin:			new StringTrait(),
		font_family:	new StringListTrait(),
		font_size:		new LengthTrait(new Length(10)),
		text_color:		new PaintTrait(RGBColor(0,0,0)),
		horizontal_align:	new FloatTrait(),
		vertical_align:		new FloatTrait(),
		border:				new BorderTrait(),
		padding:			new BorderTrait(),
		margin:				new BorderTrait(),
		min_width:			new FloatTrait(),
		max_width:			new FloatTrait(Math.POSITIVE_INFINITY),
		min_height:			new FloatTrait(),
		max_height:			new FloatTrait(Math.POSITIVE_INFINITY),
	};

	public var skin(get_skin,set_skin):String;
    function get_skin() :String { return getStyleTrait("skin",String); }
    function set_skin( v:String ) :String { return setStyleTrait("skin",v); }

	public var fontFamily(get_font_family,set_font_family):StringList;
    function get_font_family() :StringList { return getStyleTrait("font-family",StringList); }
    function set_font_family( v:StringList ) :StringList { return setStyleTrait("font-family",v); }

    public var fontSize(get_font_size,set_font_size):Float;
    function get_font_size() :Float { return getStyleTrait("font-size",Length).value; }
    function set_font_size( v:Float ) :Float { return setStyleTrait("font-size",new Length(v)).value; }

    public var textColor(get_text_color,set_text_color):Paint;
    function get_text_color() :Paint { return getStyleTrait("text-color",Paint); }
    function set_text_color( v:Paint ) :Paint { return setStyleTrait("text-color",v); }

	// TODO fontWeight (as in ElementStyle)

    public var horizontalAlign(get_horizontal_align,set_horizontal_align):Float;
    function get_horizontal_align() :Float { return getStyleTrait("horizontal-align",Float); }
    function set_horizontal_align( v:Float ) :Float { return setStyleTrait("horizontal-align",v); }

    public var verticalAlign(get_vertical_align,set_vertical_align):Float;
    function get_vertical_align() :Float { return getStyleTrait("vertical-align",Float); }
    function set_vertical_align( v:Float ) :Float { return setStyleTrait("vertical-align",v); }

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
    function get_min_width() :Float { return getStyleTrait("min-width",Float); }
    function set_min_width( v:Float ) :Float { return setStyleTrait("min-width",v); }

    public var maxWidth(get_max_width,set_max_width):Float;
    function get_max_width() :Float { return getStyleTrait("max-width",Float); }
    function set_max_width( v:Float ) :Float { return setStyleTrait("max-width",v); }

    public var minHeight(get_min_height,set_min_height):Float;
    function get_min_height() :Float { return getStyleTrait("min-height",Float); }
    function set_min_height( v:Float ) :Float { return setStyleTrait("min-height",v); }

    public var maxHeight(get_max_height,set_max_height):Float;
    function get_max_height() :Float { return getStyleTrait("max-height",Float); }
    function set_max_height( v:Float ) :Float { return setStyleTrait("max-height",v); }

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
    }
	
	public function getTextFormat() {
		var family = fontFamily;
		var size = fontSize;
		var format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
		return format;
	}
		
    override public function styleChanged( ?attr:String ) :Void {
		super.styleChanged( attr );
		_skin.setTo( skin );
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
