/* 
   xinf is not flash.
   Copyr (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ul.skin;

import Xinf;
import xinf.erno.Paint;

class SimpleSkin extends Skin {
	var bg:Rectangle;
	
	public function new() {
		bg = new Rectangle();
		setTo(null);
	}

	override public function setTo( name:String ) :Void {
		switch( name ) {
			case "focus":
				bg.style.fill = SolidColor(.8,.8,.8,.6);
				bg.style.stroke = Color.BLACK;
				bg.style.strokeWidth = 2;
			case "press":
				bg.style.fill = SolidColor(.9,.9,.9,.8);
				bg.style.stroke = Color.BLACK;
				bg.style.strokeWidth = 2;
			default:
				bg.style.fill = SolidColor(.8,.8,.8,.6);
				bg.style.stroke = Color.BLACK;
				bg.style.strokeWidth = 1;
		}
	}

	override public function resize( s:TPoint ) :Void {
		bg.width = s.x;
		bg.height = s.y;
	}

    override public function attachBackground( c:Group ) :Void {
		c.attach( bg );
    }

    override public function detachBackground( c:Group ) :Void {
		c.detach( bg );
    }

    override public function attachForeground( c:Group ) :Void {
		// disabled as simple rectangle drains all mouse events
    }

    override public function detachForeground( c:Group ) :Void {
    }

}
