package org.xinf.geom;

import org.xinf.util.FloatPointer;

class Matrix {
    private static var _A:Int = 0;
    private static var _B:Int = 4;
    private static var _TX:Int = 12;
    private static var _C:Int = 1;
    private static var _D:Int = 5;
    private static var _TY:Int = 13;
    
    public property _v(default,null):FloatPointer;

    public property tx( _get_tx, _set_tx ) : Float;
    private function _get_tx() : Float { return _v.get(_TX); }
    private function _set_tx( val:Float ) : Float { return _v.set(_TX,val); }

    public property ty( _get_ty, _set_ty ) : Float;
    private function _get_ty() : Float { return _v.get(_TY); }
    private function _set_ty( val:Float ) : Float { return _v.set(_TY,val); }

    public property a( _get_a, _set_a ) : Float;
    private function _get_a() : Float { return _v.get(_A); }
    private function _set_a( val:Float ) : Float { return _v.set(_A,val); }

    public property b( _get_b, _set_b ) : Float;
    private function _get_b() : Float { return _v.get(_B); }
    private function _set_b( val:Float ) : Float { return _v.set(_B,val); }

    public property c( _get_c, _set_c ) : Float;
    private function _get_c() : Float { return _v.get(_C); }
    private function _set_c( val:Float ) : Float { return _v.set(_C,val); }

    public property d( _get_d, _set_d ) : Float;
    private function _get_d() : Float { return _v.get(_D); }
    private function _set_d( val:Float ) : Float { return _v.set(_D,val); }

    public function new() {
        _v = new FloatPointer(16);
        _v.set(0,1.0);
        _v.set(5,1.0);
        _v.set(10,1.0);
        _v.set(15,1.0);
    }
    
    public static function Translation( x:Float, y:Float ) {
        var r = new Matrix();
        r.tx=x; r.ty=y;
        return r;
    }

    public static function Scale( x:Float, y:Float ) {
        var r = new Matrix();
        r.a=x; r.d=y;
        return r;
    }

    public static function Rotation( q:Float ) {
        var m = new Matrix();
        m.setRotation(q);
        return m;
    }
    
    public function setRotation( q:Float ) {
        var r = (q/180)*Math.PI;
        a=d=Math.cos(r);
        b=Math.sin(r);
        c=-b;
    }
    
    public function translate( x:Float, y:Float ) {
        concat( Translation(x,y) );
    }
    
    public function scale( x:Float, y:Float ) {
        concat( Scale(x,y) );
    }

    public function rotate( q:Float ) {
        concat( Rotation(q) );
    }
    
    public function concat( m:Matrix ) : Void {
        var v1 = _v;
        var v2 = m._v;
        var v:FloatPointer = new FloatPointer(16);
        
        // FIXME
        
        v.set(  0, (v1.get(0)*v2.get( 0)) + (v1.get(4)*v2.get( 1)) + (v1.get(8)*v2.get( 2)) + (v1.get(12)*v2.get( 3)) );
        v.set(  4, (v1.get(0)*v2.get( 4)) + (v1.get(4)*v2.get( 5)) + (v1.get(8)*v2.get( 6)) + (v1.get(12)*v2.get( 7)) );
        v.set(  8, (v1.get(0)*v2.get( 8)) + (v1.get(4)*v2.get( 9)) + (v1.get(8)*v2.get(10)) + (v1.get(12)*v2.get(11)) );
        v.set( 12, (v1.get(0)*v2.get(12)) + (v1.get(4)*v2.get(13)) + (v1.get(8)*v2.get(14)) + (v1.get(12)*v2.get(15)) );

        v.set(  1, (v1.get(1)*v2.get( 0)) + (v1.get(5)*v2.get( 1)) + (v1.get(9)*v2.get( 2)) + (v1.get(13)*v2.get( 3)) );
        v.set(  5, (v1.get(1)*v2.get( 4)) + (v1.get(5)*v2.get( 5)) + (v1.get(9)*v2.get( 6)) + (v1.get(13)*v2.get( 7)) );
        v.set(  9, (v1.get(1)*v2.get( 8)) + (v1.get(5)*v2.get( 9)) + (v1.get(9)*v2.get(10)) + (v1.get(13)*v2.get(11)) );
        v.set( 13, (v1.get(1)*v2.get(12)) + (v1.get(5)*v2.get(13)) + (v1.get(9)*v2.get(14)) + (v1.get(13)*v2.get(15)) );

        v.set(  2, (v1.get(2)*v2.get( 0)) + (v1.get(6)*v2.get( 1)) + (v1.get(10)*v2.get( 2)) + (v1.get(14)*v2.get( 3)) );
        v.set(  6, (v1.get(2)*v2.get( 4)) + (v1.get(6)*v2.get( 5)) + (v1.get(10)*v2.get( 6)) + (v1.get(14)*v2.get( 7)) );
        v.set( 10, (v1.get(2)*v2.get( 8)) + (v1.get(6)*v2.get( 9)) + (v1.get(10)*v2.get(10)) + (v1.get(14)*v2.get(11)) );
        v.set( 14, (v1.get(2)*v2.get(12)) + (v1.get(6)*v2.get(13)) + (v1.get(10)*v2.get(14)) + (v1.get(14)*v2.get(15)) );

        v.set(  3, (v1.get(3)*v2.get( 0)) + (v1.get(7)*v2.get( 1)) + (v1.get(11)*v2.get( 2)) + (v1.get(15)*v2.get( 3)) );
        v.set(  7, (v1.get(3)*v2.get( 4)) + (v1.get(7)*v2.get( 5)) + (v1.get(11)*v2.get( 6)) + (v1.get(15)*v2.get( 7)) );
        v.set( 11, (v1.get(3)*v2.get( 8)) + (v1.get(7)*v2.get( 9)) + (v1.get(11)*v2.get(10)) + (v1.get(15)*v2.get(11)) );
        v.set( 15, (v1.get(3)*v2.get(12)) + (v1.get(7)*v2.get(13)) + (v1.get(11)*v2.get(14)) + (v1.get(15)*v2.get(15)) );
        
        _v = v;
    }
    
    public function toString() : String {
        var s:String = "matrix[ \n  ";
        for( i in 0...16 ) {
            s += _v.get(i) + " ";
            if( i % 4 == 3 ) s += "\n  ";
        }
        s += "]";
        return s;
    }
}
