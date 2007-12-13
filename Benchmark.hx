
import Xinf;

import xinf.erno.Paint;

class Benchmark {
	public static function main() {
		var n=100;
		
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
				r.x=-12;
			});
		}
		
		Root.main();
	}
}
