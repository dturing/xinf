/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

class XinfTest {
	
	public function new() :Void {

		var g = new Group();
		Root.appendChild(g);
		g.transform = new Translate(50,50);
		
		var path = new Path({ fill:"blue", d:"M10,10 L100,0 Q70,50,100,100, C70,70,30,130,0,100 Z" });
		path.transform = new Translate(100,250);
		g.appendChild(path);
	
		addHover( path );
	
		var r = new Rectangle({ fill:"blue", x:100, y:100, width:100, height:100 });
		g.appendChild(r);
		addHover( r );
		
		var c = new Circle({ fill:"red", cx:300, cy:100, r:50 });
		g.appendChild(c);
		addHover( c );
		
		var ellipse = new Ellipse({ fill:"orange", cx:300, cy:300, rx:50, ry:30 });
		g.appendChild(ellipse);
		addHover( ellipse );
	
	}
	
	function addHover( e:Element ) {
		e.addEventListener( MouseEvent.MOUSE_OVER, function(ev) {
			e.fill = Paint.RGBColor(1,0,0);
		});
		e.addEventListener( MouseEvent.MOUSE_OUT, function(ev) {
			e.fill = Paint.RGBColor(0,1,0);
		});
	}
	
	public static function main() :Void {
		Root.setBackgroundColor(.3,.3,.3,0);
		var d = new XinfTest();
		Root.main();
	}
}
