/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.erno;

/**
    Describes a RGBA Color. Component values are between 0.0 (dark) and 1.0 (bright).
**/
class Color {
	/* fixme: place somewhere else */
	public static function intToString( v:Int, ?radix:Int, ?l:Int ) :String {
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

    /** Constructor. Initializes to (0,0,0,0). **/
    public function new() {
        r = g = b = a = .0;
    }
    
    /** Sets the R, G and B components from an integer (like 0x00ff00 for green) **/
    public function fromRGBInt( c:Int ) :Color {
        r = ((c&0xff0000)>>16)/0xff;
        g = ((c&0xff00)>>8)/0xff;
        b =  (c&0xff)/0xff;
        a = 1.;
        return this;
    }

    /** Sets the R, G, and B components from individual 0-1 floats, a is 1 **/
    public function fromRGBA( r:Float, g:Float, b:Float, a:Float ) :Color {
		this.r=r; this.g=g; this.b=b;
		this.a=a;
        return this;
    }

	/** Sets the R, G, B and A components from individual 0-1 floats **/
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
	
	public static function rgba(r:Float,g:Float,b:Float,a:Float) :Color {
		return new Color().fromRGBA(r,g,b,a);
	}
	
	public static var BLACK:Color = new Color().fromRGBInt(0);
	public static var WHITE:Color = new Color().fromRGBInt(0xffffff);
	public static var RED:Color = new Color().fromRGBInt(0xff0000);
	public static var GREEN:Color = new Color().fromRGBInt(0x00ff00);
	public static var BLUE:Color = new Color().fromRGBInt(0x0000ff);
}
