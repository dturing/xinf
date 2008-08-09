/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

class XinfTest {
	
	public function new() :Void {

		xinf.style.StyleSheet.DEFAULT.parseCSS( "
			* {
				fill:none;
				fill-opacity:.8;
				stroke-width:30;
				stroke:black;
				stroke-opacity:.5;
			}
		");
		var g = new Group();
		Root.appendChild(g);
		g.transform = new Translate(50,50);
		
		var path = new Path({ d:"M10,10 L100,0 Q70,50,100,100, C70,70,30,130,0,100 Z" });
		path.transform = new Translate(100,250);
		g.appendChild(path);
	
		addHover( path );
	
		var r = new Rectangle({ x:100, y:100, width:100, height:100 });
		g.appendChild(r);
		addHover( r );
		
		var c = new Circle({ cx:300, cy:100, r:50, stroke_dasharray:"50 10" });
		g.appendChild(c);
		addHover( c );
		
		var ellipse = new Ellipse({ cx:300, cy:300, rx:50, ry:30, stroke:"none" });
		g.appendChild(ellipse);
		addHover( ellipse );
	
	}
	
	function addHover( e:Element ) {
		e.addEventListener( MouseEvent.MOUSE_OVER, function(ev) {
			//e.fill = 
			e.stroke = Paint.RGBColor(1.,0,0);
		});
		e.addEventListener( MouseEvent.MOUSE_OUT, function(ev) {
			//e.fill = 
			e.stroke = Paint.RGBColor(.5,.5,.5);
		});
	}
	
	public static function main() :Void {
		Root.setBackgroundColor(.3,.3,.3,0);
		var d = new XinfTest();
		Root.main();
	}
}
