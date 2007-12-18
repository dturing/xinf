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
    public static var RED:Paint = SolidColor(1,0,0,1);
    public static var GREEN:Paint = SolidColor(0,1,0,1);
    public static var BLUE:Paint = SolidColor(0,0,1,1);
    public static var TRANSPARENT:Paint = SolidColor(0,0,0,0);
}
