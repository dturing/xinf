import Xinf;

class DraggableRectangle extends Rectangle {
	
	public function new() :Void {
		super();
		
		style.fill = Color.BLUE;
		x=y=100;
		width=height=100;
		addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		
		var self=this;
		addEventListener( MouseEvent.MOUSE_OVER, function(e) { self.style.fill = Color.RED; } );
		addEventListener( MouseEvent.MOUSE_OUT, function(e) { self.style.fill = Color.BLUE; } );

	}
	
	public function onMouseDown( e:MouseEvent ) :Void {
		var ofs = e;
		var upL:Dynamic;
		var moveL:Dynamic;
		var self = this;
		
		style.fill = Color.GREEN;
		
		upL = Root.addEventListener( MouseEvent.MOUSE_UP, function(e) {
				self.style.fill = Color.RED;
				Root.removeEventListener( MouseEvent.MOUSE_UP, upL );
				Root.removeEventListener( MouseEvent.MOUSE_MOVE, moveL );
			} );
			
		moveL = Root.addEventListener( MouseEvent.MOUSE_MOVE, function(e) {
				var o = { x:ofs.x-e.x, y:ofs.y-e.y };
				ofs = e;
				self.x -= o.x;
				self.y -= o.y;
			} );
	}
	
}

class Demo {
	
	public function new() :Void {
		Root.attach( new DraggableRectangle() );
	}
	
	public static function main() :Void {
		var d = new Demo();
		Root.main();
	}
}
