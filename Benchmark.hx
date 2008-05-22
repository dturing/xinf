/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

import xinf.ony.type.Paint;

class Benchmark {
	public static function main() {
		var xn=10;
		var yn=10;
		var w=1024;
		var h=768;
		
		for( yi in 0...yn ) {
			var y = (h/yn)*yi;
			for( xi in 0...xn ) {
				var x = (w/xn)*xi;
				
				var r = new Rectangle();
				r.fill = RGBColor(0,0,0);
				r.fillOpacity = .3;
				r.stroke = RGBColor(0,0,0);
				r.strokeOpacity = .7;
				r.width=r.height=24;
				r.x=r.y=-12;
				r.rx=r.ry=0.;
				var t = new Translate( x, y );
				Root.appendChild(r);
				Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
					r.transform = new Concatenate( new Rotate( e.frame/10 ), t );
					//r.x=-12;
				});
			}
		}
		
		var scanline = new Rectangle();
		scanline.height=1; scanline.fill=RGBColor(0,0,0);
		Root.appendChild( scanline );
		Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
			scanline.width = Root.width;
			scanline.transform = new Translate(0,e.frame % Root.height);
		});
		
		var flicker = new Rectangle();
		flicker.width=100; flicker.fill=RGBColor(0,0,0);
		Root.appendChild( flicker );
		Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
			flicker.height = Root.height;
			flicker.transform = new Translate((e.frame*10) % Root.width,0);
		});
		
		Root.main();
	}
}
