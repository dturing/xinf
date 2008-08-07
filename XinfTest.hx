/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

class XinfTest {
	
	public function new() :Void {

		var path = new Path({ fill:"blue", d:"M10,10 L100,0 Q70,50,100,100, C70,70,30,130,0,100 Z" });
		path.transform = new Translate(100,250);
		Root.appendChild(path);
	
		path.addEventListener( MouseEvent.MOUSE_OVER, function(e) {
			path.fill = Paint.RGBColor(1,0,0);
		});

		path.addEventListener( MouseEvent.MOUSE_OUT, function(e) {
			path.fill = Paint.RGBColor(0,1,0);
		});
	
	}
	
	public static function main() :Void {
		Root.setBackgroundColor(.3,.3,.3,0);
		var d = new XinfTest();
		Root.main();
	}
}
