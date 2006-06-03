package org.xinf.ony;

signature IColor {
    var r:Float;
    var g:Float;
    var b:Float;
    var a:Float;

    function toRGBInt() : Int;
}

class Color {
    public var r:Float;
    public var g:Float;
    public var b:Float;
    public var a:Float;

    public function new() {
        r = g = b = a = .0;
    }
    
    public function fromRGBInt( c:Int ) {
        r = ((c&0xff0000)>>16)/0xff;
        g = ((c&0xff00)>>8)/0xff;
        b =  (c&0xff)/0xff;
        a = 1.;
    }

    public function toRGBInt() : Int {
        return ( Math.round(r*0xff) << 16 ) | ( Math.round(g*0xff) << 8 ) | Math.round(b*0xff);
    }

    public function toRGBString() : String {
        return("rgb("+Math.round(r*0xff)+","+Math.round(g*0xff)+","+Math.round(b*0xff)+")");
    }
    
    public function toString() : String {
        return("("+r+","+g+","+b+","+a+")");
    }
}
