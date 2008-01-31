/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Matrix implements Transform {
/*
    a  b  0
    c  d  0
    tx ty 1
*/
    
    public var a:Float;
    public var c:Float;
    public var tx:Float;
    public var b:Float;
    public var d:Float;
    public var ty:Float;
    
    public function new( ?m:TMatrix ) :Void {
        if( m==null ) 
            setIdentity();
        else { 
            set( m );
        }
    }

    public function getTranslation() {
        return { x:tx, y:ty };
    }
    public function getScale() {
        return { x:a, y:d };
    }
    public function getMatrix() {
        return this;
    }

    public function set( m:TMatrix ) :Void {
        a=m.a; c=m.c; tx=m.tx;
        b=m.b; d=m.d; ty=m.ty;
    }
    
    public function apply( p:TPoint ) :TPoint {
        return {
            x: (p.x*a) + (p.y*c) + tx,
            y: (p.x*b) + (p.y*d) + ty
            };
    }

    public function applyInverse( p:TPoint ) :TPoint {
        return invert().apply(p);
    }
    
    // TODO: geom.TRectangle
    // FIXME: regard all four corners?
    public function transformBBox( r:{l:Float,t:Float,r:Float,b:Float}) :{l:Float,t:Float,r:Float,b:Float} {
        var tl = apply( {x:r.l,y:r.t} );
        var br = apply( {x:r.r,y:r.b} );
        return {
            l: Math.min(tl.x,br.x),
            t: Math.min(tl.y,br.y),
            r: Math.max(tl.x,br.x), 
            b: Math.max(tl.y,br.y)
            };
    }

    public function invert() :Matrix {
        var o:Matrix=new Matrix();
        
        var d1 = 1./((a*d) - (b*c));
        
        o.a = d*d1;
        o.b = -b*d1;
        o.c = -c*d1;
        o.d = a*d1;
        
        o.tx = ((c*ty)-(d*tx))*d1;
        o.ty = -((a*ty)-(b*tx))*d1;
        
        return o;
    }

    public function multiply( m:TMatrix ) :Matrix {
        var o:Matrix=new Matrix();
        
        o.a = (a*m.a) + (b*m.c);
        o.c = (c*m.a) + (d*m.c);
        o.tx = (tx*m.a) + (ty*m.c) + m.tx;

        o.b = (a*m.b) + (b*m.d);
        o.d = (c*m.b) + (d*m.d);
        o.ty = (tx*m.b) + (ty*m.d) + m.ty;
        
        return o;
    }

    public function setIdentity() :Matrix {
        a=1; c=0; tx=0;
        b=0; d=1; ty=0;
        return this;
    }
    
    public function translate( x:Float, y:Float ) :Matrix {
        return multiply( new Matrix().setTranslation(x,y) );
    }
    public function setTranslation( x:Float, y:Float ) :Matrix {
        tx = x;
        ty = y;
        return this;
    }
    
    public function scale( x:Float, y:Float ) :Matrix {
        return multiply( new Matrix().setScale(x,y) );
    }
    public function setScale( x:Float, y:Float ) :Matrix {
        a = x;
        d = y;
        return this;
    }

    public function skew( x:Float, y:Float ) :Matrix {
        return multiply( new Matrix().setSkew(x,y) );
    }
    public function setSkew( x:Float, y:Float ) :Matrix {
        c = x;
        b = y;
        return this;
    }

    public function rotate( a:Float ) :Matrix {
        return multiply( new Matrix().setRotation(a) );
    }
    public function setRotation( angle:Float ) :Matrix {
        var co = Math.cos(angle);
        var si = Math.sin(angle);
        a=co; b=si;
        c=-si; d=co;
        return this;
    }

	public function interpolateWith( p:Transform, f:Float ) :Transform {
		return this;
	}

    public function toString() {
        return("matrix("+a+","+b+","+c+","+d+","+tx+","+ty+")");
    }
}
