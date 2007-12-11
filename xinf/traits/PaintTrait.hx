package xinf.traits;

import xinf.erno.Paint;
import xinf.erno.Color;

class PaintTrait extends TypedTrait<xinf.erno.Paint> {

	static var url = ~/url\((.*)\)/i;
    static var hexcolor = ~/^#([0-9a-f]+)$/i;
    static var rgbcolor = ~/^rgb\([\r\n\t ]*([0-9]+)[\r\n\t ]*,[\r\n\t ]*([0-9]+)[\r\n\t ]*,[\r\n\t ]*([0-9]+)[\r\n\t ]*\)$/;
    // TODO: rgb(r,g,b), others?

    static var colorNames:Hash<Color>;
    public static function getColorNames() :Hash<Color> {
        if( colorNames==null ) {
            colorNames = new Hash<Color>();
            colorNames.set( "none", Color.rgba(0,0,0,0) );
            
            // SVG colors
            colorNames.set( "aliceblue", Color.rgbI(240,248,255));
            colorNames.set( "antiquewhite", Color.rgbI(250,235,215));
            colorNames.set( "aqua", Color.rgbI(0,255,255));
            colorNames.set( "aquamarine", Color.rgbI(127,255,212));
            colorNames.set( "azure", Color.rgbI(240,255,255));
            colorNames.set( "beige", Color.rgbI(245,245,220));
            colorNames.set( "bisque", Color.rgbI(255,228,196));
            colorNames.set( "black", Color.rgbI(0,0,0));
            colorNames.set( "blanchedalmond", Color.rgbI(255,235,205));
            colorNames.set( "blue", Color.rgbI(0,0,255));
            colorNames.set( "blueviolet", Color.rgbI(138,43,226));
            colorNames.set( "brown", Color.rgbI(165,42,42));
            colorNames.set( "burlywood", Color.rgbI(222,184,135));
            colorNames.set( "cadetblue", Color.rgbI(95,158,160));
            colorNames.set( "chartreuse", Color.rgbI(127,255,0));
            colorNames.set( "chocolate", Color.rgbI(210,105,30));
            colorNames.set( "coral", Color.rgbI(255,127,80));
            colorNames.set( "cornflowerblue", Color.rgbI(100,149,237));
            colorNames.set( "cornsilk", Color.rgbI(255,248,220));
            colorNames.set( "crimson", Color.rgbI(220,20,60));
            colorNames.set( "cyan", Color.rgbI(0,255,255));
            colorNames.set( "darkblue", Color.rgbI(0,0,139));
            colorNames.set( "darkcyan", Color.rgbI(0,139,139));
            colorNames.set( "darkgoldenrod", Color.rgbI(184,134,11));
            colorNames.set( "darkgray", Color.rgbI(169,169,169));
            colorNames.set( "darkgreen", Color.rgbI(0,100,0));
            colorNames.set( "darkgrey", Color.rgbI(169,169,169));
            colorNames.set( "darkkhaki", Color.rgbI(189,183,107));
            colorNames.set( "darkmagenta", Color.rgbI(139,0,139));
            colorNames.set( "darkolivegreen", Color.rgbI(85,107,47));
            colorNames.set( "darkorange", Color.rgbI(255,140,0));
            colorNames.set( "darkorchid", Color.rgbI(153,50,204));
            colorNames.set( "darkred", Color.rgbI(139,0,0));
            colorNames.set( "darksalmon", Color.rgbI(233,150,122));
            colorNames.set( "darkseagreen", Color.rgbI(143,188,143));
            colorNames.set( "darkslateblue", Color.rgbI(72,61,139));
            colorNames.set( "darkslategray", Color.rgbI(47,79,79));
            colorNames.set( "darkslategrey", Color.rgbI(47,79,79));
            colorNames.set( "darkturquoise", Color.rgbI(0,206,209));
            colorNames.set( "darkviolet", Color.rgbI(148,0,211));
            colorNames.set( "deeppink", Color.rgbI(255,20,147));
            colorNames.set( "deepskyblue", Color.rgbI(0,191,255));
            colorNames.set( "dimgray", Color.rgbI(105,105,105));
            colorNames.set( "dimgrey", Color.rgbI(105,105,105));
            colorNames.set( "dodgerblue", Color.rgbI(30,144,255));
            colorNames.set( "firebrick", Color.rgbI(178,34,34));
            colorNames.set( "floralwhite", Color.rgbI(255,250,240));
            colorNames.set( "forestgreen", Color.rgbI(34,139,34));
            colorNames.set( "fuchsia", Color.rgbI(255,0,255));
            colorNames.set( "gainsboro", Color.rgbI(220,220,220));
            colorNames.set( "ghostwhite", Color.rgbI(248,248,255));
            colorNames.set( "gold", Color.rgbI(255,215,0));
            colorNames.set( "goldenrod", Color.rgbI(218,165,32));
            colorNames.set( "gray", Color.rgbI(128,128,128));
            colorNames.set( "green", Color.rgbI(0,128,0));
            colorNames.set( "greenyellow", Color.rgbI(173,255,47));
            colorNames.set( "grey", Color.rgbI(128,128,128));
            colorNames.set( "honeydew", Color.rgbI(240,255,240));
            colorNames.set( "hotpink", Color.rgbI(255,105,180));
            colorNames.set( "indianred", Color.rgbI(205,92,92));
            colorNames.set( "indigo", Color.rgbI(75,0,130));
            colorNames.set( "ivory", Color.rgbI(255,255,240));
            colorNames.set( "khaki", Color.rgbI(240,230,140));
            colorNames.set( "lavender", Color.rgbI(230,230,250));
            colorNames.set( "lavenderblush", Color.rgbI(255,240,245));
            colorNames.set( "lawngreen", Color.rgbI(124,252,0));
            colorNames.set( "lemonchiffon", Color.rgbI(255,250,205));
            colorNames.set( "lightblue", Color.rgbI(173,216,230));
            colorNames.set( "lightcoral", Color.rgbI(240,128,128));
            colorNames.set( "lightcyan", Color.rgbI(224,255,255));
            colorNames.set( "lightgoldenrodyellow", Color.rgbI(250,250,210));
            colorNames.set( "lightgray", Color.rgbI(211,211,211));
            colorNames.set( "lightgreen", Color.rgbI(144,238,144));
            colorNames.set( "lightgrey", Color.rgbI(211,211,211));
            colorNames.set( "lightpink", Color.rgbI(255,182,193));
            colorNames.set( "lightsalmon", Color.rgbI(255,160,122));
            colorNames.set( "lightseagreen", Color.rgbI(32,178,170));
            colorNames.set( "lightskyblue", Color.rgbI(135,206,250));
            colorNames.set( "lightslategray", Color.rgbI(119,136,153));
            colorNames.set( "lightslategrey", Color.rgbI(119,136,153));
            colorNames.set( "lightsteelblue", Color.rgbI(176,196,222));
            colorNames.set( "lightyellow", Color.rgbI(255,255,224));
            colorNames.set( "lime", Color.rgbI(0,255,0));
            colorNames.set( "limegreen", Color.rgbI(50,205,50));
            colorNames.set( "linen", Color.rgbI(250,240,230));
            colorNames.set( "magenta", Color.rgbI(255,0,255));
            colorNames.set( "maroon", Color.rgbI(128,0,0));
            colorNames.set( "mediumaquamarine", Color.rgbI(102,205,170));
            colorNames.set( "mediumblue", Color.rgbI(0,0,205));
            colorNames.set( "mediumorchid", Color.rgbI(186,85,211));
            colorNames.set( "mediumpurple", Color.rgbI(147,112,219));
            colorNames.set( "mediumseagreen", Color.rgbI(60,179,113));
            colorNames.set( "mediumslateblue", Color.rgbI(123,104,238));
            colorNames.set( "mediumspringgreen", Color.rgbI(0,250,154));
            colorNames.set( "mediumturquoise", Color.rgbI(72,209,204));
            colorNames.set( "mediumvioletred", Color.rgbI(199,21,133));
            colorNames.set( "midnightblue", Color.rgbI(25,25,112));
            colorNames.set( "mintcream", Color.rgbI(245,255,250));
            colorNames.set( "mistyrose", Color.rgbI(255,228,225));
            colorNames.set( "moccasin", Color.rgbI(255,228,181));
            colorNames.set( "navajowhite", Color.rgbI(255,222,173));
            colorNames.set( "navy", Color.rgbI(0,0,128));
            colorNames.set( "oldlace", Color.rgbI(253,245,230));
            colorNames.set( "olive", Color.rgbI(128,128,0));
            colorNames.set( "olivedrab", Color.rgbI(107,142,35));
            colorNames.set( "orange", Color.rgbI(255,165,0));
            colorNames.set( "orangered", Color.rgbI(255,69,0));
            colorNames.set( "orchid", Color.rgbI(218,112,214));
            colorNames.set( "palegoldenrod", Color.rgbI(238,232,170));
            colorNames.set( "palegreen", Color.rgbI(152,251,152));
            colorNames.set( "paleturquoise", Color.rgbI(175,238,238));
            colorNames.set( "palevioletred", Color.rgbI(219,112,147));
            colorNames.set( "papayawhip", Color.rgbI(255,239,213));
            colorNames.set( "peachpuff", Color.rgbI(255,218,185));
            colorNames.set( "peru", Color.rgbI(205,133,63));
            colorNames.set( "pink", Color.rgbI(255,192,203));
            colorNames.set( "plum", Color.rgbI(221,160,221));
            colorNames.set( "powderblue", Color.rgbI(176,224,230));
            colorNames.set( "purple", Color.rgbI(128,0,128));
            colorNames.set( "red", Color.rgbI(255,0,0));
            colorNames.set( "rosybrown", Color.rgbI(188,143,143));
            colorNames.set( "royalblue", Color.rgbI(65,105,225));
            colorNames.set( "saddlebrown", Color.rgbI(139,69,19));
            colorNames.set( "salmon", Color.rgbI(250,128,114));
            colorNames.set( "sandybrown", Color.rgbI(244,164,96));
            colorNames.set( "seagreen", Color.rgbI(46,139,87));
            colorNames.set( "seashell", Color.rgbI(255,245,238));
            colorNames.set( "sienna", Color.rgbI(160,82,45));
            colorNames.set( "silver", Color.rgbI(192,192,192));
            colorNames.set( "skyblue", Color.rgbI(135,206,235));
            colorNames.set( "slateblue", Color.rgbI(106,90,205));
            colorNames.set( "slategray", Color.rgbI(112,128,144));
            colorNames.set( "slategrey", Color.rgbI(112,128,144));
            colorNames.set( "snow", Color.rgbI(255,250,250));
            colorNames.set( "springgreen", Color.rgbI(0,255,127));
            colorNames.set( "steelblue", Color.rgbI(70,130,180));
            colorNames.set( "tan", Color.rgbI(210,180,140));
            colorNames.set( "teal", Color.rgbI(0,128,128));
            colorNames.set( "thistle", Color.rgbI(216,191,216));
            colorNames.set( "tomato", Color.rgbI(255,99,71));
            colorNames.set( "turquoise", Color.rgbI(64,224,208));
            colorNames.set( "violet", Color.rgbI(238,130,238));
            colorNames.set( "wheat", Color.rgbI(245,222,179));
            colorNames.set( "white", Color.rgbI(255,255,255));
            colorNames.set( "whitesmoke", Color.rgbI(245,245,245));
            colorNames.set( "yellow", Color.rgbI(255,255,0));
            colorNames.set( "yellowgreen", Color.rgbI(154,205,50));
        }
        return colorNames;
    }
 
	var def:Paint;
	
	public function new( ?def:Paint ) {
		super();
		this.def=def;
		if( def==null ) this.def=None;
	}
 
	override public function parse( value:String ) :Dynamic {
        var v:Paint;
		var color:Color;
        
        if( hexcolor.match(value) ) {
            var w = hexcolor.matched(1);
            if( w.length==3 ) {
                var c = Std.parseInt("0x"+w);
                var r = ((c&0xf00)>>8)/0xf;
                var g = ((c&0x0f0)>>4)/0xf;
                var b =  (c&0x00f)/0xf;
                color = new Color().fromRGBA( r,g,b,1.0 );
            } else if( w.length==6 ) {
                color = new Color().fromRGBInt( Std.parseInt("0x"+w) );
            }
        } else if( rgbcolor.match(value) ) {
            v = SolidColor( Std.parseInt( rgbcolor.matched(1) ), 
                            Std.parseInt( rgbcolor.matched(2) ), 
                            Std.parseInt( rgbcolor.matched(3) ), 1. );
		} else if( url.match(value) ) {
			v = URLReference( url.matched(1) );
        } else if( (color=getColorNames().get(value)) !=null ) {
            // do nothing more
        } else if( StringTools.trim(value).length==0 ) {
            color = Color.rgba(0,0,0,0);
        }
        
		if( v==null && color!=null ) v = SolidColor( color.r, color.g, color.b, color.a );

        if( v==null ) throw("Not a color: -"+value+"- ("+value.length+")" );

        return v;
    }

	override public function getDefault() :Dynamic {
		return def;
	}

}
