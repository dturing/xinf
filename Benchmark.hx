
import Xinf;

import xinf.erno.Paint;

class Benchmark {
	public static function main() {
		var n=50;
		
		for( i in 0...n ) {
			var r = new Rectangle();
			r.fill = SolidColor(0,0,0,.3);
			r.width=r.height=24;
			r.x=r.y=-12;
			r.rx=r.ry=0.;
			var t = new Translate( Math.random()*800, Math.random()*600 );
			Root.attach(r);
			Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
				r.transform = new Concatenate( new Rotate( e.frame/10 ), t );
			//	r.x=-12;
			});
		}
		
		var scanline = new Rectangle();
		scanline.height=1; scanline.fill=SolidColor(0,0,0,1);
		Root.attach( scanline );
		Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
			scanline.width = Root.width;
			scanline.transform = new Translate(0,e.frame % Root.height);
		});
		
		var flicker = new Rectangle();
		flicker.width=100; flicker.fill=SolidColor(0,0,0,1);
		Root.attach( flicker );
		Root.addEventListener( FrameEvent.ENTER_FRAME, function(e) {
			flicker.height = Root.height;
			flicker.transform = new Translate((e.frame*10) % Root.width,0);
		});
		
		Root.main();
	}
}
