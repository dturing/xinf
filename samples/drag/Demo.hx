import Xinf;

class Demo {
	
	var r:Rectangle;
	
	public function new() :Void {
	
		r = new Rectangle();
		r.style.fill = Color.RED;
		r.x=r.y=100;
		r.width=r.height=100;
	
		r.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		
		Root.attach( r );
	}
	
	public function onMouseDown( e:MouseEvent ) :Void {
		var ofs = e;
		var upL:Dynamic;
		var moveL:Dynamic;
		var self = this;
		
		upL = Root.addEventListener( MouseEvent.MOUSE_UP, function(e) {
				Root.removeEventListener( MouseEvent.MOUSE_UP, upL );
				Root.removeEventListener( MouseEvent.MOUSE_MOVE, moveL );
			} );
			
		moveL = Root.addEventListener( MouseEvent.MOUSE_MOVE, function(e) {
				var o = { x:ofs.x-e.x, y:ofs.y-e.y };
				ofs = e;
				self.r.x -= o.x;
				self.r.y -= o.y;
			} );
	}
	
	public static function main() :Void {
		var d = new Demo();
		Root.main();
	}
}
