/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.skin;

import Xinf;
import xinf.ony.type.Paint;
import xinf.ul.Component;

class SimpleSkin extends Skin {
	var bg:Rectangle;
	
	public function new() {
		bg = new Rectangle();
		//setTo(null);
	}

	override public function setTo( name:String, component:Component ) :Void {
		switch( name ) {
			case "focus":
				bg.fill = RGBColor(.9,.9,.9);
				bg.fillOpacity = .8;
				bg.stroke = component.focusColor;
				bg.strokeWidth = 2;
			case "focus-bright":
				bg.fill = RGBColor(.98,.98,.98);
				bg.fillOpacity = .9;
				bg.stroke = component.focusColor;
				bg.strokeWidth = 2;
			case "none":
				bg.fill = Paint.None;
				bg.stroke = Paint.None;
				bg.strokeWidth = 0;
			default:
				bg.fill = RGBColor(.9,.9,.9);
				bg.fillOpacity = .5;
				bg.stroke = RGBColor(.3,.3,.3);
				bg.strokeWidth = 1;
		}
	}

	override public function resize( s:TPoint ) :Void {
		bg.width = s.x;
		bg.height = s.y;
	}

	override public function attachBackground( c:Group ) :Void {
		c.appendChild( bg );
	}

	override public function detachBackground( c:Group ) :Void {
		c.removeChild( bg );
	}

	override public function attachForeground( c:Group ) :Void {
		// disabled as simple rectangle drains all mouse events
	}

	override public function detachForeground( c:Group ) :Void {
	}

}
