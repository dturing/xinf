/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.type;

import xinf.type.Paint;

/**
    Describes a RGBA Color. Component values are between 0.0 (dark) and 1.0 (bright).
**/
class Color {
    
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


    /** Red component **/
    public var r:Float;
    /** Green component **/
    public var g:Float;
    /** Blue component **/
    public var b:Float;
    /** Alpha component. 
        0.0 is transparent, 1.0 opaque. **/
    public var a:Float;

    /** Constructor. Initializes to (.5,.5,.5,.5). **/
    public function new() {
        r = b = 0.0;
        g = a = 1.0;
    }
    
    /** Sets the R, G and B components from an integer (like 0x00ff00 for green) **/
    public function fromRGBInt( c:Int ) :Color {
        r = ((c&0xff0000)>>16)/0xff;
        g = ((c&0xff00)>>8)/0xff;
        b =  (c&0xff)/0xff;
        a = 1.;
        return this;
    }

    /** Sets the R, G, B and A components from individual 0-1 floats **/
    public function fromRGBA( r:Float, g:Float, b:Float, a:Float ) :Color {
        this.r=r; this.g=g; this.b=b;
        this.a=a;
        return this;
    }

    /** Sets the R, G, and B components from individual 0-1 floats, a is 1 **/
    public function fromRGB( r:Float, g:Float, b:Float, a:Float ) :Color {
        this.r=r; this.g=g; this.b=b;
        this.a=1;
        return this;
    }

    /** Returns an integer value describing the RGB (not A) part of the color. **/
    public function toRGBInt() : Int {
        return ( Math.round(r*0xff) << 16 ) | ( Math.round(g*0xff) << 8 ) | Math.round(b*0xff);
    }

    /** Returns a CSS-like string describing the color, in the form "rgb(r,g,b)". Values will be between 0 and 255.  **/
    public function toRGBString() : String {
        return("rgb("+Math.round(r*0xff)+","+Math.round(g*0xff)+","+Math.round(b*0xff)+")");
    }

    /** Returns a CSS-like hexadecimal string describing the color, in the form "#rrggbb". Values will be between 0 and 255.  **/
    public function toHexString() : String {
        return("#"+intToString(Math.round(r*0xff),16,2)
                +intToString(Math.round(g*0xff),16,2)
                +intToString(Math.round(b*0xff),16,2));
    }

    public function toString() : String {
        return("("+r+","+g+","+b+","+a+")");
    }
    
    /** creates a new Color object from the given values for red, green, blue and alpha **/
    public static function rgba(r:Float,g:Float,b:Float,a:Float) :Color {
        return new Color().fromRGBA(r,g,b,a);
    }

    /** creates a new Color object from the given values for red, green and blue. alpha will be 1 (opaque) **/
    public static function rgb(r:Float,g:Float,b:Float) :Color {
        return new Color().fromRGBA(r,g,b,1.0);
    }

    /** creates a new Color object from the given 0-255 values for red, green and blue. alpha will be 1 (opaque) **/
    public static function rgbI(r:Int,g:Int,b:Int) :Color {
        return new Color().fromRGBA(r/255.,g/255.,b/255.,1.0);
    }
    
    public function toSolidColor() :Paint {
    	return SolidColor(r,g,b,a);
    }

    public static var BLACK:Paint = SolidColor(0,0,0,1);
    public static var WHITE:Paint = SolidColor(1,1,1,1);
    public static var PRIMARY_RED:Paint = SolidColor(1,0,0,1);
    public static var PRIMARY_GREEN:Paint = SolidColor(0,1,0,1);
    public static var PRIMARY_BLUE:Paint = SolidColor(0,0,1,1);
    public static var TRANSPARENT:Paint = SolidColor(0,0,0,0);

#if no-tango-colors
#else true
    public static var Butter:Array<Paint> = [ 
        SolidColor(0xfc/0xff,0xe9/0xff,0x4f/0xff,1.),
        SolidColor(0xed/0xff,0xd4/0xff,0x00/0xff,1.),
        SolidColor(0xc4/0xff,0xa0/0xff,0x00/0xff,1.)
     ];
    public static var YELLOW:Paint = Butter[0];

    public static var Orange:Array<Paint> = [ 
        SolidColor(0xfc/0xff,0xaf/0xff,0x3e/0xff,1.),
        SolidColor(0xf5/0xff,0x79/0xff,0x00/0xff,1.),
        SolidColor(0xce/0xff,0x5c/0xff,0x00/0xff,1.)
     ];
    public static var ORANGE:Paint = Orange[0];

    public static var Chocolate:Array<Paint> = [ 
        SolidColor(0xe9/0xff,0xb9/0xff,0x6e/0xff,1.),
        SolidColor(0xc1/0xff,0x7d/0xff,0x11/0xff,1.),
        SolidColor(0x8f/0xff,0x59/0xff,0x02/0xff,1.)
     ];

    public static var Chameleon:Array<Paint> = [ 
        SolidColor(0x8a/0xff,0xe2/0xff,0x34/0xff,1.),
        SolidColor(0x73/0xff,0xd2/0xff,0x16/0xff,1.),
        SolidColor(0x4e/0xff,0x9a/0xff,0x06/0xff,1.)
     ];
    public static var GREEN:Paint = Chameleon[1];

    public static var SkyBlue:Array<Paint> = [ 
        SolidColor(0x72/0xff,0x9f/0xff,0xcf/0xff,1.),
        SolidColor(0x34/0xff,0x65/0xff,0xa4/0xff,1.),
        SolidColor(0x20/0xff,0x4a/0xff,0x87/0xff,1.)
     ];
    public static var LIGHT_BLUE:Paint = SkyBlue[0];
    public static var BLUE:Paint = SkyBlue[1];
    public static var DARK_BLUE:Paint = SkyBlue[2];

    public static var Plum:Array<Paint> = [ 
        SolidColor(0xad/0xff,0x7f/0xff,0xa8/0xff,1.),
        SolidColor(0x75/0xff,0x50/0xff,0x7b/0xff,1.),
        SolidColor(0x5c/0xff,0x35/0xff,0x66/0xff,1.)
     ];

    public static var ScarletRed:Array<Paint> = [ 
        SolidColor(0xef/0xff,0x29/0xff,0x29/0xff,1.),
        SolidColor(0xcc/0xff,0x00/0xff,0x00/0xff,1.),
        SolidColor(0xa4/0xff,0x00/0xff,0x00/0xff,1.)
     ];
    public static var RED:Paint = ScarletRed[1];

    public static var Aluminium:Array<Paint> = [ 
        SolidColor(0xee/0xff,0xee/0xff,0xec/0xff,1.),
        SolidColor(0xd3/0xff,0xd7/0xff,0xcf/0xff,1.),
        SolidColor(0xba/0xff,0xbd/0xff,0xb6/0xff,1.),
        SolidColor(0x88/0xff,0x8a/0xff,0x85/0xff,1.),
        SolidColor(0x55/0xff,0x57/0xff,0x53/0xff,1.),
        SolidColor(0x2e/0xff,0x34/0xff,0x36/0xff,1.)
     ];
    public static var LIGHT_GRAY:Paint = Aluminium[1];
    public static var GRAY:Paint = Aluminium[2];
    public static var DARK_GRAY:Paint = Aluminium[4];
#end
}
