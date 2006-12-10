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

class Matrix {
	public var m00:Float;
	public var m01:Float;
	public var m02:Float;
	public var m10:Float;
	public var m11:Float;
	public var m12:Float;
	public var m20:Float;
	public var m21:Float;
	public var m22:Float;
	
	public function new() :Void {
	}
	
	public function set( m:Matrix ) :Void {
		m00=m.m00; m01=m.m01; m02=m.m02;
		m10=m.m10; m11=m.m11; m12=m.m12;
		m20=m.m20; m21=m.m21; m22=m.m22;
	}
	
	public function apply( p:Coord2d ) :Coord2d {
		return {
			x: (p.x*m00) + (p.y*m10) + m20,
			y: (p.x*m01) + (p.y*m11) + m21
			};
	}
	
	public function multiply( m:Matrix ) :Matrix {
		var o:Matrix=new Matrix();
		
		o.m00 = (m00*m.m00) + (m01*m.m10) + (m02*m.m20);
		o.m01 = (m00*m.m01) + (m01*m.m11) + (m02*m.m21);
		o.m02 = (m00*m.m02) + (m01*m.m12) + (m02*m.m22);

		o.m10 = (m10*m.m00) + (m11*m.m10) + (m12*m.m20);
		o.m11 = (m10*m.m01) + (m11*m.m11) + (m12*m.m21);
		o.m12 = (m10*m.m02) + (m11*m.m12) + (m12*m.m22);

		o.m20 = (m20*m.m00) + (m21*m.m10) + (m22*m.m20);
		o.m21 = (m20*m.m01) + (m21*m.m11) + (m22*m.m21);
		o.m22 = (m20*m.m02) + (m21*m.m12) + (m22*m.m22);
		
		return o;
	}

	public function setIdentity() :Matrix {
		m00=1; m01=0; m02=0;
		m10=0; m11=1; m12=0;
		m20=0; m21=0; m22=1;
		return this;
	}
	
	public function setTranslation( x:Float, y:Float ) :Matrix {
		m20 = x;
		m21 = y;
		return this;
	}
	
	public function setScale( x:Float, y:Float ) :Matrix {
		m00 = x;
		m11 = y;
		return this;
	}

	public function setRotation( a:Float ) :Matrix {
		var c = Math.cos(a);
		var s = Math.sin(a);
		m00=c; m01=s;
		m10=-s; m11=c;
		return this;
	}
}
