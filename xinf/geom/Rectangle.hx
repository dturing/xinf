/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

class Rectangle {
    
    public var l:Float;
    public var t:Float;
    public var r:Float;
    public var b:Float;
    
    public function new( ?c:TRectangle ) :Void {
        if( c==null ) l=t=r=b=0.;
        else {
            l=c.l; t=c.t; r=c.r; b=c.b;
        }
    }
    
    public function w() :Float {
        return( r-l );
    }
    
    public function h() :Float {
        return( b-t );
    }
    
    public function cx() :Float {
        return( l+((r-l)/2) );
    }
    
    public function cy() :Float {
        return( t+((b-t)/2) );
    }
    
    private function equal( a:Float, b:Float, epsilon:Float ) :Bool {
        return( Math.abs(a-b)<epsilon );
    }
    
    public function touches( a:TRectangle, e:Float ) :Bool {
        return( equal(l,a.l,e) || equal(r,a.r,e) || equal(t,a.t,e) || equal(b,a.b,e) );
    }
    
    public function intersectsRectangle( i:TRectangle ) :Bool {
        return( l<=i.r && r>=i.l && t<=i.b && b>=i.t );
    }
    
    public function within( w:TRectangle ) :Bool {
        return( l>=w.l && t>=w.t && r<=w.r && b<=w.b );
    }
    
    public function contains( p:TPoint ) :Bool {
        return( p.x>=l && p.x<=r && p.y>=t && p.y<=b );
    }
    
    public function merge( m:TRectangle ) :Void {
        if( m.l<l ) l=m.l;
        if( m.t<t ) t=m.t;
        if( m.r>r ) r=m.r;
        if( m.b>b ) b=m.b;
    }
    
    public static function createR( r:TRectangle ) {
        return new Rectangle(r);
    }
    
    public static function createC( l:Float, t:Float, r:Float, b:Float ) {
        return new Rectangle( {l:l, t:t, r:r, b:b} );
    }
    
    public function toString() :String {
        return("("+l+","+t+"+"+(r-l)+"x"+(b-t)+")");
    }
    
}


