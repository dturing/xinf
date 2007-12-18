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
				bg.fill = SolidColor(.9,.9,.9,.8);
				bg.stroke = Color.BLACK;
				bg.strokeWidth = 2;
			case "focus-bright":
				bg.fill = SolidColor(.98,.98,.98,.9);
				bg.stroke = Color.BLACK;
				bg.strokeWidth = 2;
			case "none":
				bg.fill = Color.TRANSPARENT;
				bg.stroke = Color.TRANSPARENT;
				bg.strokeWidth = 0;
			default:
				bg.fill = SolidColor(.9,.9,.9,.8);
				bg.stroke = Color.BLACK;
				bg.strokeWidth = 1;
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
