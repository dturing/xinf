/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.ony.type.Paint;
import xinf.traits.SpecialTraitValue;

class PaintTrait extends TypedTrait<Paint> {

	static var url = ~/url\((.*)\)/i;
    static var hexcolor = ~/^#([0-9a-f]+)$/i;
    static var rgbcolor = ~/^rgb\([\r\n\t ]*([0-9]+)[\r\n\t ]*,[\r\n\t ]*([0-9]+)[\r\n\t ]*,[\r\n\t ]*([0-9]+)[\r\n\t ]*\)$/;
    static var rgbpercentcolor = ~/^rgb\([\r\n\t ]*([0-9\.]+)[\r\n\t ]*%[\r\n\t ]*,[\r\n\t ]*([0-9\.]+)[\r\n\t ]*%[\r\n\t ]*,[\r\n\t ]*([0-9\.]+)[\r\n\t ]*%[\r\n\t ]*\)$/;
    // TODO: rgb(r,g,b), others?

    static var colorNames:Hash<Paint>;
    public static function getColorNames() :Hash<Paint> {
        if( colorNames==null ) {
            colorNames = new Hash<Paint>();
            colorNames.set( "none", Paint.None );
            
            // SVG colors
			#if no-svg-colors
			#else true
            colorNames.set( "aliceblue", RGBColor(240/255,248/255,255/255));
            colorNames.set( "antiquewhite", RGBColor(250/255,235/255,215/255));
            colorNames.set( "aqua", RGBColor(0/255,255/255,255/255));
            colorNames.set( "aquamarine", RGBColor(127/255,255/255,212/255));
            colorNames.set( "azure", RGBColor(240/255,255/255,255/255));
            colorNames.set( "beige", RGBColor(245/255,245/255,220/255));
            colorNames.set( "bisque", RGBColor(255/255,228/255,196/255));
            colorNames.set( "black", RGBColor(0/255,0/255,0/255));
            colorNames.set( "blanchedalmond", RGBColor(255/255,235/255,205/255));
            colorNames.set( "blue", RGBColor(0/255,0/255,255/255));
            colorNames.set( "blueviolet", RGBColor(138/255,43/255,226/255));
            colorNames.set( "brown", RGBColor(165/255,42/255,42/255));
            colorNames.set( "burlywood", RGBColor(222/255,184/255,135/255));
            colorNames.set( "cadetblue", RGBColor(95/255,158/255,160/255));
            colorNames.set( "chartreuse", RGBColor(127/255,255/255,0/255));
            colorNames.set( "chocolate", RGBColor(210/255,105/255,30/255));
            colorNames.set( "coral", RGBColor(255/255,127/255,80/255));
            colorNames.set( "cornflowerblue", RGBColor(100/255,149/255,237/255));
            colorNames.set( "cornsilk", RGBColor(255/255,248/255,220/255));
            colorNames.set( "crimson", RGBColor(220/255,20/255,60/255));
            colorNames.set( "cyan", RGBColor(0/255,255/255,255/255));
            colorNames.set( "darkblue", RGBColor(0/255,0/255,139/255));
            colorNames.set( "darkcyan", RGBColor(0/255,139/255,139/255));
            colorNames.set( "darkgoldenrod", RGBColor(184/255,134/255,11/255));
            colorNames.set( "darkgray", RGBColor(169/255,169/255,169/255));
            colorNames.set( "darkgreen", RGBColor(0/255,100/255,0/255));
            colorNames.set( "darkgrey", RGBColor(169/255,169/255,169/255));
            colorNames.set( "darkkhaki", RGBColor(189/255,183/255,107/255));
            colorNames.set( "darkmagenta", RGBColor(139/255,0/255,139/255));
            colorNames.set( "darkolivegreen", RGBColor(85/255,107/255,47/255));
            colorNames.set( "darkorange", RGBColor(255/255,140/255,0/255));
            colorNames.set( "darkorchid", RGBColor(153/255,50/255,204/255));
            colorNames.set( "darkred", RGBColor(139/255,0/255,0/255));
            colorNames.set( "darksalmon", RGBColor(233/255,150/255,122/255));
            colorNames.set( "darkseagreen", RGBColor(143/255,188/255,143/255));
            colorNames.set( "darkslateblue", RGBColor(72/255,61/255,139/255));
            colorNames.set( "darkslategray", RGBColor(47/255,79/255,79/255));
            colorNames.set( "darkslategrey", RGBColor(47/255,79/255,79/255));
            colorNames.set( "darkturquoise", RGBColor(0/255,206/255,209/255));
            colorNames.set( "darkviolet", RGBColor(148/255,0/255,211/255));
            colorNames.set( "deeppink", RGBColor(255/255,20/255,147/255));
            colorNames.set( "deepskyblue", RGBColor(0/255,191/255,255/255));
            colorNames.set( "dimgray", RGBColor(105/255,105/255,105/255));
            colorNames.set( "dimgrey", RGBColor(105/255,105/255,105/255));
            colorNames.set( "dodgerblue", RGBColor(30/255,144/255,255/255));
            colorNames.set( "firebrick", RGBColor(178/255,34/255,34/255));
            colorNames.set( "floralwhite", RGBColor(255/255,250/255,240/255));
            colorNames.set( "forestgreen", RGBColor(34/255,139/255,34/255));
            colorNames.set( "fuchsia", RGBColor(255/255,0/255,255/255));
            colorNames.set( "gainsboro", RGBColor(220/255,220/255,220/255));
            colorNames.set( "ghostwhite", RGBColor(248/255,248/255,255/255));
            colorNames.set( "gold", RGBColor(255/255,215/255,0/255));
            colorNames.set( "goldenrod", RGBColor(218/255,165/255,32/255));
            colorNames.set( "gray", RGBColor(128/255,128/255,128/255));
            colorNames.set( "green", RGBColor(0/255,128/255,0/255));
            colorNames.set( "greenyellow", RGBColor(173/255,255/255,47/255));
            colorNames.set( "grey", RGBColor(128/255,128/255,128/255));
            colorNames.set( "honeydew", RGBColor(240/255,255/255,240/255));
            colorNames.set( "hotpink", RGBColor(255/255,105/255,180/255));
            colorNames.set( "indianred", RGBColor(205/255,92/255,92/255));
            colorNames.set( "indigo", RGBColor(75/255,0/255,130/255));
            colorNames.set( "ivory", RGBColor(255/255,255/255,240/255));
            colorNames.set( "khaki", RGBColor(240/255,230/255,140/255));
            colorNames.set( "lavender", RGBColor(230/255,230/255,250/255));
            colorNames.set( "lavenderblush", RGBColor(255/255,240/255,245/255));
            colorNames.set( "lawngreen", RGBColor(124/255,252/255,0/255));
            colorNames.set( "lemonchiffon", RGBColor(255/255,250/255,205/255));
            colorNames.set( "lightblue", RGBColor(173/255,216/255,230/255));
            colorNames.set( "lightcoral", RGBColor(240/255,128/255,128/255));
            colorNames.set( "lightcyan", RGBColor(224/255,255/255,255/255));
            colorNames.set( "lightgoldenrodyellow", RGBColor(250/255,250/255,210/255));
            colorNames.set( "lightgray", RGBColor(211/255,211/255,211/255));
            colorNames.set( "lightgreen", RGBColor(144/255,238/255,144/255));
            colorNames.set( "lightgrey", RGBColor(211/255,211/255,211/255));
            colorNames.set( "lightpink", RGBColor(255/255,182/255,193/255));
            colorNames.set( "lightsalmon", RGBColor(255/255,160/255,122/255));
            colorNames.set( "lightseagreen", RGBColor(32/255,178/255,170/255));
            colorNames.set( "lightskyblue", RGBColor(135/255,206/255,250/255));
            colorNames.set( "lightslategray", RGBColor(119/255,136/255,153/255));
            colorNames.set( "lightslategrey", RGBColor(119/255,136/255,153/255));
            colorNames.set( "lightsteelblue", RGBColor(176/255,196/255,222/255));
            colorNames.set( "lightyellow", RGBColor(255/255,255/255,224/255));
            colorNames.set( "lime", RGBColor(0/255,255/255,0/255));
            colorNames.set( "limegreen", RGBColor(50/255,205/255,50/255));
            colorNames.set( "linen", RGBColor(250/255,240/255,230/255));
            colorNames.set( "magenta", RGBColor(255/255,0/255,255/255));
            colorNames.set( "maroon", RGBColor(128/255,0/255,0/255));
            colorNames.set( "mediumaquamarine", RGBColor(102/255,205/255,170/255));
            colorNames.set( "mediumblue", RGBColor(0/255,0/255,205/255));
            colorNames.set( "mediumorchid", RGBColor(186/255,85/255,211/255));
            colorNames.set( "mediumpurple", RGBColor(147/255,112/255,219/255));
            colorNames.set( "mediumseagreen", RGBColor(60/255,179/255,113/255));
            colorNames.set( "mediumslateblue", RGBColor(123/255,104/255,238/255));
            colorNames.set( "mediumspringgreen", RGBColor(0/255,250/255,154/255));
            colorNames.set( "mediumturquoise", RGBColor(72/255,209/255,204/255));
            colorNames.set( "mediumvioletred", RGBColor(199/255,21/255,133/255));
            colorNames.set( "midnightblue", RGBColor(25/255,25/255,112/255));
            colorNames.set( "mintcream", RGBColor(245/255,255/255,250/255));
            colorNames.set( "mistyrose", RGBColor(255/255,228/255,225/255));
            colorNames.set( "moccasin", RGBColor(255/255,228/255,181/255));
            colorNames.set( "navajowhite", RGBColor(255/255,222/255,173/255));
            colorNames.set( "navy", RGBColor(0/255,0/255,128/255));
            colorNames.set( "oldlace", RGBColor(253/255,245/255,230/255));
            colorNames.set( "olive", RGBColor(128/255,128/255,0/255));
            colorNames.set( "olivedrab", RGBColor(107/255,142/255,35/255));
            colorNames.set( "orange", RGBColor(255/255,165/255,0/255));
            colorNames.set( "orangered", RGBColor(255/255,69/255,0/255));
            colorNames.set( "orchid", RGBColor(218/255,112/255,214/255));
            colorNames.set( "palegoldenrod", RGBColor(238/255,232/255,170/255));
            colorNames.set( "palegreen", RGBColor(152/255,251/255,152/255));
            colorNames.set( "paleturquoise", RGBColor(175/255,238/255,238/255));
            colorNames.set( "palevioletred", RGBColor(219/255,112/255,147/255));
            colorNames.set( "papayawhip", RGBColor(255/255,239/255,213/255));
            colorNames.set( "peachpuff", RGBColor(255/255,218/255,185/255));
            colorNames.set( "peru", RGBColor(205/255,133/255,63/255));
            colorNames.set( "pink", RGBColor(255/255,192/255,203/255));
            colorNames.set( "plum", RGBColor(221/255,160/255,221/255));
            colorNames.set( "powderblue", RGBColor(176/255,224/255,230/255));
            colorNames.set( "purple", RGBColor(128/255,0/255,128/255));
            colorNames.set( "red", RGBColor(255/255,0/255,0/255));
            colorNames.set( "rosybrown", RGBColor(188/255,143/255,143/255));
            colorNames.set( "royalblue", RGBColor(65/255,105/255,225/255));
            colorNames.set( "saddlebrown", RGBColor(139/255,69/255,19/255));
            colorNames.set( "salmon", RGBColor(250/255,128/255,114/255));
            colorNames.set( "sandybrown", RGBColor(244/255,164/255,96/255));
            colorNames.set( "seagreen", RGBColor(46/255,139/255,87/255));
            colorNames.set( "seashell", RGBColor(255/255,245/255,238/255));
            colorNames.set( "sienna", RGBColor(160/255,82/255,45/255));
            colorNames.set( "silver", RGBColor(192/255,192/255,192/255));
            colorNames.set( "skyblue", RGBColor(135/255,206/255,235/255));
            colorNames.set( "slateblue", RGBColor(106/255,90/255,205/255));
            colorNames.set( "slategray", RGBColor(112/255,128/255,144/255));
            colorNames.set( "slategrey", RGBColor(112/255,128/255,144/255));
            colorNames.set( "snow", RGBColor(255/255,250/255,250/255));
            colorNames.set( "springgreen", RGBColor(0/255,255/255,127/255));
            colorNames.set( "steelblue", RGBColor(70/255,130/255,180/255));
            colorNames.set( "tan", RGBColor(210/255,180/255,140/255));
            colorNames.set( "teal", RGBColor(0/255,128/255,128/255));
            colorNames.set( "thistle", RGBColor(216/255,191/255,216/255));
            colorNames.set( "tomato", RGBColor(255/255,99/255,71/255));
            colorNames.set( "turquoise", RGBColor(64/255,224/255,208/255));
            colorNames.set( "violet", RGBColor(238/255,130/255,238/255));
            colorNames.set( "wheat", RGBColor(245/255,222/255,179/255));
            colorNames.set( "white", RGBColor(255/255,255/255,255/255));
            colorNames.set( "whitesmoke", RGBColor(245/255,245/255,245/255));
            colorNames.set( "yellow", RGBColor(255/255,255/255,0/255));
            colorNames.set( "yellowgreen", RGBColor(154/255,205/255,50/255));
			
            colorNames.set( "Background", RGBColor(58/255,110/255,165/255));
            colorNames.set( "AppWorkspace", RGBColor(58/255,110/255,165/255));
            colorNames.set( "Window", RGBColor(255/255,255/255,255/255));
            colorNames.set( "WindowText", RGBColor(0/255,0/255,0/255) );
            colorNames.set( "WindowFrame", RGBColor(0/255,0/255,0/255) );
            colorNames.set( "Menu", RGBColor(212/255,208/255,200/255));
            colorNames.set( "MenuText", RGBColor(0/255,0/255,0/255) );
            colorNames.set( "ButtonFace", RGBColor(212/255,208/255,200/255));
            colorNames.set( "ButtonShadow", RGBColor(64/255,64/255,64/255));
            colorNames.set( "ButtonHighlight", RGBColor(255/255,255/255,255/255));
            colorNames.set( "ThreeDFace", RGBColor(212/255,208/255,200/255));
            colorNames.set( "ThreeDDarkShadow", RGBColor(64/255,64/255,64/255));
            colorNames.set( "ThreeDLightShadow", RGBColor(255/255,255/255,255/255));
            colorNames.set( "HighlightText", RGBColor(255/255,255/255,255/255));
            colorNames.set( "CaptionText", RGBColor(255/255,255/255,255/255) );
            colorNames.set( "ActiveBorder", RGBColor(0/255,0/255,0/255));
            colorNames.set( "ActiveCaption", RGBColor(10/255,36/255,106/255));
			#end

			#if notango
			#else true
				colorNames.set( "yellow", RGBColor(0xfc/255,0xe9/255,0x4f/255) );
				colorNames.set( "orange", RGBColor(0xfc/255,0xaf/255,0x3e/255) );
				colorNames.set( "green", RGBColor(0x73/255,0xd2/255,0x16/255) );
				colorNames.set( "lightblue", RGBColor(0x72/255,0x9f/255,0xcf/255) );
				colorNames.set( "blue", RGBColor(0x34/255,0x65/255,0xa4/255) );
				colorNames.set( "darkblue", RGBColor(0x20/255,0x4a/255,0x87/255) );
				colorNames.set( "red", RGBColor(0xcc/255,0x00/255,0x00/255) );
				colorNames.set( "lightgray", RGBColor(0xd3/255,0xd7/255,0xcf/255) );
				colorNames.set( "gray", RGBColor(0xba/255,0xbd/255,0xb6/255) );
				colorNames.set( "darkgray", RGBColor(0x55/255,0x57/255,0x53/255) );
			#end
		}
        return colorNames;
    }
 
	var def:Paint;
	
	public function new( ?def:Paint ) {
		super( Paint );
		this.def=def;
		if( def==null ) this.def=None;
	}
 
	override public function parse( value:String ) :Dynamic {
        var v:Paint;
		
		if( value==null ) {
			return null;
		} else if( value=="currentColor" ) {
			return CurrentColor.currentColor;
		} else if( value=="inherit" ) {
			return Inherit.inherit;
        } else if( hexcolor.match(value) ) {
            var w = hexcolor.matched(1);
            if( w.length==3 ) {
                var c = Std.parseInt("0x"+w);
                var r = ((c&0xf00)>>8)/0xf;
                var g = ((c&0x0f0)>>4)/0xf;
                var b =  (c&0x00f)/0xf;
                v = RGBColor( r,g,b );
            } else if( w.length==6 ) {
                v = fromRGBInt( Std.parseInt("0x"+w) );
            }
        } else if( rgbpercentcolor.match(value) ) {
            v = RGBColor( Std.parseFloat( rgbpercentcolor.matched(1) )/100, 
                            Std.parseFloat( rgbpercentcolor.matched(2) )/100, 
                            Std.parseFloat( rgbpercentcolor.matched(3) )/100 );
        } else if( rgbcolor.match(value) ) {
            v = RGBColor( Std.parseInt( rgbcolor.matched(1) )/255, 
                            Std.parseInt( rgbcolor.matched(2) )/255, 
                            Std.parseInt( rgbcolor.matched(3) )/255 );
		} else if( url.match(value) ) {
			v = URLReference( url.matched(1) );
        } else if( (v=getColorNames().get(value)) !=null ) {
            // do nothing more
        } else if( StringTools.trim(value).length==0 ) {
            v = None;
        }
        
        if( v==null ) throw("Not a color: -"+value+"- ("+value.length+")" );

        return v;
    }

	override public function getDefault() :Dynamic {
		return def;
	}

    /* fixme: place somewhere else */
    private static function intToString( v:Int, ?radix:Int, ?l:Int ) :String {
        var glyphs="0123456789abcdef";
        var r:String="";
        if( radix==null ) radix=10;
        if( l==null ) l=0;
        var t:Float = v;
        var u:Float;
        while( v>0 ) {
            // this is likely hilarious.
            t=v;
            t/=radix;
            t-=Math.floor(t);
            t*=radix;
            v-=Math.round(t);
            v/=radix;
            r = glyphs.charAt(Math.round(t))+r;
        }
        l -= r.length;
        for( i in 0...l ) {
            r = "0"+r;
        }
        return r;
    }

    /** Set the R, G and B components from an integer (like 0x00ff00 for green) **/
    private static function fromRGBInt( c:Int ) :Paint {
        var r = ((c&0xff0000)>>16)/0xff;
        var g = ((c&0xff00)>>8)/0xff;
        var b =  (c&0xff)/0xff;
        return RGBColor(r,g,b);
    }

	override public function interpolate( a:Dynamic, b:Dynamic, f:Float ) :Dynamic {
		var aC:Paint = cast(a);
		var bC:Paint = cast(b);
		switch( aC ) {
			case RGBColor(r1,g1,b1):
				switch( bC ) {
					case RGBColor(r2,g2,b2):
						return RGBColor(
								r1+((r2-r1)*f),
								g1+((g2-g1)*f),
								b1+((b2-b1)*f)
							);
					default:
						return a;
				}
			default:
				return a;
		}
	}
	
	override public function distance( a:Dynamic, b:Dynamic ) :Float {
		var aC:Paint = cast(a);
		var bC:Paint = cast(b);
		switch( aC ) {
			case RGBColor(r1,g1,b1):
				switch( bC ) {
					// FIXME: stupid color distance algorithm
					case RGBColor(r2,g2,b2):
						return Math.abs( (r2-r1)+(g2-g1)+(b2+b1) );
					default:
						return 1.;
				}
			default:
				return 1.;
		}
	}

	override public function add( a:Dynamic, b:Dynamic ) :Dynamic {
		return interpolate(a,b,.5);
	}
	
}
