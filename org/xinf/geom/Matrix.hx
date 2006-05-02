package org.xinf.geom;

import org.xinf.util.CPtr;

class Matrix {
    private static var _A:Int = 0;
    private static var _B:Int = 4;
    private static var _TX:Int = 12;
    private static var _C:Int = 1;
    private static var _D:Int = 5;
    private static var _TY:Int = 13;
    
    public property _v(default,null):Dynamic;

    public property tx( _get_tx, _set_tx ) : Float;
    private function _get_tx() : Float { return CPtr.float_get(_v,_TX); }
    private function _set_tx( val:Float ) : Float { return CPtr.float_set(_v,_TX,val); }

    public property ty( _get_ty, _set_ty ) : Float;
    private function _get_ty() : Float { return CPtr.float_get(_v,_TY); }
    private function _set_ty( val:Float ) : Float { return CPtr.float_set(_v,_TY,val); }

    public property a( _get_a, _set_a ) : Float;
    private function _get_a() : Float { return CPtr.float_get(_v,_A); }
    private function _set_a( val:Float ) : Float { return CPtr.float_set(_v,_A,val); }

    public property b( _get_b, _set_b ) : Float;
    private function _get_b() : Float { return CPtr.float_get(_v,_B); }
    private function _set_b( val:Float ) : Float { return CPtr.float_set(_v,_B,val); }

    public property c( _get_c, _set_c ) : Float;
    private function _get_c() : Float { return CPtr.float_get(_v,_C); }
    private function _set_c( val:Float ) : Float { return CPtr.float_set(_v,_C,val); }

    public property d( _get_d, _set_d ) : Float;
    private function _get_d() : Float { return CPtr.float_get(_v,_D); }
    private function _set_d( val:Float ) : Float { return CPtr.float_set(_v,_D,val); }

    public function new() {
        _v = CPtr.float_alloc(16);
        setIdentity();
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
    
    public function setIdentity() {
        for( i in 0...16 ) {
            // TODO: cptr function to set to 0?
            CPtr.float_set(_v,i,0.0);
        }
        CPtr.float_set(_v,0,1.0);
        CPtr.float_set(_v,5,1.0);
        CPtr.float_set(_v,10,1.0);
        CPtr.float_set(_v,15,1.0);
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
        var v = CPtr.float_alloc(16);
        
        // FIXME
        
        CPtr.float_set(v,  0, (CPtr.float_get(v1,0)*CPtr.float_get(v2, 0)) + (CPtr.float_get(v1,4)*CPtr.float_get(v2, 1)) + (CPtr.float_get(v1,8)*CPtr.float_get(v2, 2)) + (CPtr.float_get(v1,12)*CPtr.float_get(v2, 3)) );
        CPtr.float_set(v,  4, (CPtr.float_get(v1,0)*CPtr.float_get(v2, 4)) + (CPtr.float_get(v1,4)*CPtr.float_get(v2, 5)) + (CPtr.float_get(v1,8)*CPtr.float_get(v2, 6)) + (CPtr.float_get(v1,12)*CPtr.float_get(v2, 7)) );
        CPtr.float_set(v,  8, (CPtr.float_get(v1,0)*CPtr.float_get(v2, 8)) + (CPtr.float_get(v1,4)*CPtr.float_get(v2, 9)) + (CPtr.float_get(v1,8)*CPtr.float_get(v2,10)) + (CPtr.float_get(v1,12)*CPtr.float_get(v2,11)) );
        CPtr.float_set(v, 12, (CPtr.float_get(v1,0)*CPtr.float_get(v2,12)) + (CPtr.float_get(v1,4)*CPtr.float_get(v2,13)) + (CPtr.float_get(v1,8)*CPtr.float_get(v2,14)) + (CPtr.float_get(v1,12)*CPtr.float_get(v2,15)) );

        CPtr.float_set(v,  1, (CPtr.float_get(v1,1)*CPtr.float_get(v2, 0)) + (CPtr.float_get(v1,5)*CPtr.float_get(v2, 1)) + (CPtr.float_get(v1,9)*CPtr.float_get(v2, 2)) + (CPtr.float_get(v1,13)*CPtr.float_get(v2, 3)) );
        CPtr.float_set(v,  5, (CPtr.float_get(v1,1)*CPtr.float_get(v2, 4)) + (CPtr.float_get(v1,5)*CPtr.float_get(v2, 5)) + (CPtr.float_get(v1,9)*CPtr.float_get(v2, 6)) + (CPtr.float_get(v1,13)*CPtr.float_get(v2, 7)) );
        CPtr.float_set(v,  9, (CPtr.float_get(v1,1)*CPtr.float_get(v2, 8)) + (CPtr.float_get(v1,5)*CPtr.float_get(v2, 9)) + (CPtr.float_get(v1,9)*CPtr.float_get(v2,10)) + (CPtr.float_get(v1,13)*CPtr.float_get(v2,11)) );
        CPtr.float_set(v, 13, (CPtr.float_get(v1,1)*CPtr.float_get(v2,12)) + (CPtr.float_get(v1,5)*CPtr.float_get(v2,13)) + (CPtr.float_get(v1,9)*CPtr.float_get(v2,14)) + (CPtr.float_get(v1,13)*CPtr.float_get(v2,15)) );

        CPtr.float_set(v,  2, (CPtr.float_get(v1,2)*CPtr.float_get(v2, 0)) + (CPtr.float_get(v1,6)*CPtr.float_get(v2, 1)) + (CPtr.float_get(v1,10)*CPtr.float_get(v2, 2)) + (CPtr.float_get(v1,14)*CPtr.float_get(v2, 3)) );
        CPtr.float_set(v,  6, (CPtr.float_get(v1,2)*CPtr.float_get(v2, 4)) + (CPtr.float_get(v1,6)*CPtr.float_get(v2, 5)) + (CPtr.float_get(v1,10)*CPtr.float_get(v2, 6)) + (CPtr.float_get(v1,14)*CPtr.float_get(v2, 7)) );
        CPtr.float_set(v, 10, (CPtr.float_get(v1,2)*CPtr.float_get(v2, 8)) + (CPtr.float_get(v1,6)*CPtr.float_get(v2, 9)) + (CPtr.float_get(v1,10)*CPtr.float_get(v2,10)) + (CPtr.float_get(v1,14)*CPtr.float_get(v2,11)) );
        CPtr.float_set(v, 14, (CPtr.float_get(v1,2)*CPtr.float_get(v2,12)) + (CPtr.float_get(v1,6)*CPtr.float_get(v2,13)) + (CPtr.float_get(v1,10)*CPtr.float_get(v2,14)) + (CPtr.float_get(v1,14)*CPtr.float_get(v2,15)) );

        CPtr.float_set(v,  3, (CPtr.float_get(v1,3)*CPtr.float_get(v2, 0)) + (CPtr.float_get(v1,7)*CPtr.float_get(v2, 1)) + (CPtr.float_get(v1,11)*CPtr.float_get(v2, 2)) + (CPtr.float_get(v1,15)*CPtr.float_get(v2, 3)) );
        CPtr.float_set(v,  7, (CPtr.float_get(v1,3)*CPtr.float_get(v2, 4)) + (CPtr.float_get(v1,7)*CPtr.float_get(v2, 5)) + (CPtr.float_get(v1,11)*CPtr.float_get(v2, 6)) + (CPtr.float_get(v1,15)*CPtr.float_get(v2, 7)) );
        CPtr.float_set(v, 11, (CPtr.float_get(v1,3)*CPtr.float_get(v2, 8)) + (CPtr.float_get(v1,7)*CPtr.float_get(v2, 9)) + (CPtr.float_get(v1,11)*CPtr.float_get(v2,10)) + (CPtr.float_get(v1,15)*CPtr.float_get(v2,11)) );
        CPtr.float_set(v, 15, (CPtr.float_get(v1,3)*CPtr.float_get(v2,12)) + (CPtr.float_get(v1,7)*CPtr.float_get(v2,13)) + (CPtr.float_get(v1,11)*CPtr.float_get(v2,14)) + (CPtr.float_get(v1,15)*CPtr.float_get(v2,15)) );
        
        _v = v;
    }
    
    public function toString() : String {
        var s:String = "matrix[ \n  ";
        for( i in 0...16 ) {
            s += CPtr.float_get(_v,i) + " ";
            if( i % 4 == 3 ) s += "\n  ";
        }
        s += "]";
        return s;
    }
}
