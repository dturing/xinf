/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;
import xinf.style.StyledElement;
import xinf.style.StyleSheet;
import xinf.style.Selector;
import xinf.event.SimpleEvent;

import xinf.erno.TextFormat;
import xinf.type.Paint;
import xinf.type.Border;
import xinf.type.StringList;
import xinf.ul.skin.Skin;

import xinf.traits.StringListTrait;
import xinf.traits.StringTrait;
import xinf.traits.FloatTrait;
import xinf.traits.BorderTrait;
import xinf.traits.PaintTrait;

class Component extends StyledElement {
	public static var styleSheet:StyleSheet 
		= new StyleSheet(
	[
		{ selector:Any, style:{
				padding: new Border(6,3,6,3),
				border: new Border(1,1,1,1),
				horizontal_align: 0.,
				vertical_align: 0.,
				font_family: new StringList(["sans"]),
				font_size: 12,
				text_color: Color.BLACK,
				min_width: 100,
			} },
		{ selector:StyleClass("Container"), style:{
				horizontal_align: 0.,
				vertical_align: 0.,
			} },
		{ selector:StyleClass("ListView"), style:{
				min_width: 100.,
				min_height: 75.,
			} },
		{ selector:StyleClass("Label"), style:{
				padding: new Border(2,2,2,2),
				border: new Border(0,0,0,0),
				horizontal_align: 0.,
				vertical_align: 0.,
				font_family: new StringList(["sans"]),
				font_size: 12,
				text_color: Color.BLACK,
				skin: "none",
			} },
		{ selector:StyleClass("Button"), style:{
				padding: new Border(6,3,6,3),
				border: new Border(1,1,1,1),
				min_width: 100,
				min_height: 10,
				horizontal_align: .5,
				vertical_align: .5,
			} },
		{ selector:StyleClass(":focus"), style:{
				skin: "focus",
				padding: new Border(5,2,5,2),
				border: new Border(2,2,2,2),
			} },
		{ selector:AllOf([ StyleClass("Button"), StyleClass(":press") ]), style:{
				skin: "focus-bright",
				padding: new Border(5,3,5,1),
			} },
		{ selector:StyleClass("ListView"), style:{
				padding: new Border( 3,1,0,1 ),
			} },
		{ selector:StyleClass("LineEdit"), style:{
				padding: new Border(2,2,2,1),
				min_width: 100,
				min_height: 10,
			} },
		{ selector:AllOf([ StyleClass("LineEdit"), StyleClass(":focus") ]), style:{
				skin: "focus-bright",
			} },
	]);
	
	static var TRAITS = {
		skin:			new StringTrait(),
		font_family:	new StringListTrait(),
		font_size:		new FloatTrait(10.),
		text_color:		new PaintTrait(Color.BLACK),
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
    function get_font_size() :Float { return getStyleTrait("font-size",Float); }
    function set_font_size( v:Float ) :Float { return setStyleTrait("font-size",v); }

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


    public var __parentSizeListener:Dynamic;

    public var parent(default,null):Container;
    
	public var prefSize(getPrefSize,null):TPoint;
    var _prefSize:TPoint;
	
	var _skin:Skin;
	
	public var size(default,set_size):TPoint;
	public var position(default,set_position):TPoint; // TODO!
	var element:Element;

    public function new( ?e:Element, ?traits:Dynamic ) :Void {
		super(traits);
        _prefSize = { x:.0, y:.0 };
		
		element=e;
		if( element==null ) {
			element = new Group();
		}
		
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
		
    override public function styleChanged() :Void {
		_skin.setTo( skin );
    }
	
    override public function updateClassStyle() :Void {
		clearTraitsCache();
		_matchedStyle = styleSheet.match(this);
		styleChanged();
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
	
	public function set_position( p:TPoint ) :TPoint {
		position = p;
		if( element!=null ) {
			element.transform = new Translate(p.x,p.y);
		}
		return( p );
	}

    public function getElement() :Element {
		return element;
    }
	
	public function toString() :String {
		return( Type.getClassName(Type.getClass(this)) );
	}

}
