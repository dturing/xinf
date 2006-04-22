package org.xinf.display.primitive;

class FillColor extends Primitive {
    private var r:Float;
    private var g:Float;
    private var b:Float;
    private var a:Float;

    public function new() {
        super();
        r = g = b = 0.0;
        a = 1.0;
    }
    
    public function setFromInt( c:Int, _a:Float ) {
        r = int32_and( int32_shr( c, 16 ), 0xff );
        r/=0xff;
        g = int32_and( int32_shr( c, 8 ), 0xff );
        g/=0xff;
        b = int32_and( c, 0xff );
        b/=0xff;
        a=_a;
    }
    
    public function set( _r:Float, _g:Float, _b:Float, _a:Float ) {
        r=_r; g=_g; b=_b; a=_a;
    }
    
    public function _render( rend:org.xinf.render.IRenderer ) {
        rend.setColor( r, g, b, a );
    }
    
    private static var int32_shr = neko.Lib.load("std","int32_shr",2);
    private static var int32_and = neko.Lib.load("std","int32_and",2);
}
