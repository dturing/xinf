import Xinf;

class Viewer {

	var doc:Svg;
	var g:Group;
	
	var scale:Float;
	var offset:TPoint;
	var stage:TPoint;

	public function new( ?url:String ) :Void {

		scale = 1.;
		offset = { x:0., y:0. };
		stage = { x:320., y:240. };

		g = new Group();
		Root.appendChild(g);
		
		if( url==null ) {
			Document.instantiate( Std.resource("test.svg"), loaded, Svg );
		} else {
			Document.load( url, loaded );
		}

		Root.addEventListener( GeometryEvent.STAGE_SCALED, onStageScale );
		Root.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		Root.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
	}
	

	function loaded(e:Svg) {
		doc=e;
		trace("loaded "+e);
		g.appendChild( doc );
		retransform();
	}

	function retransform() {
		if( doc==null ) return;
		
		//doc.transform = new Scale( stage.x/doc.width, stage.y/doc.height );
		g.transform = new Concatenate( 
						new Concatenate(
							new Translate( -doc.width/2, -doc.height/2 ),
							new Concatenate(
								new Scale( scale, scale ),
						//		new Scale(  (stage.x/doc.width)*scale, 
						//					(stage.y/doc.height)*scale ),
								new Translate(offset.x,offset.y)
							)
						),
						new Translate( stage.x/2, stage.y/2 )
					  );
	}

	function onStageScale( e:GeometryEvent ) {
		stage.x=e.x; stage.y=e.y;
		retransform();
	}

	function onKeyDown( e:KeyboardEvent ) {
			var d=25;
			trace("key "+e.key );
			switch( e.key ) {
				case "up":
					offset.y += d;
				case "down":
					offset.y -= d;
				case "left":
					offset.x += d;
				case "right":
					offset.x -= d;
				case "-":
					scale*=.9;
				case "+":
					scale*=1./.9;
				case "1":
					offset = { x:0., y:0. };
					scale = 1;
			}
			
		retransform();
	}
		
	function onMouseDown( check:MouseEvent ) {
		var upL:Dynamic;
		var moveL:Dynamic;
		var old = offset;
		var self = this;
		moveL= Root.addEventListener( MouseEvent.MOUSE_MOVE, function(e) {
			self.offset = { x:old.x-(check.x-e.x), y:old.y-(check.y-e.y) };
			self.retransform();
		});
		upL = Root.addEventListener( MouseEvent.MOUSE_UP, function(e) {
			Root.removeEventListener( MouseEvent.MOUSE_UP, upL );
			Root.removeEventListener( MouseEvent.MOUSE_MOVE, moveL );
		});
	}
	
	public static function main() :Void {
		var arg:String;
		#if neko
			arg = neko.Sys.args()[0];
		#end
		Root.setBackgroundColor(0,0,0,0);
		var d = new Viewer( arg );
		Root.main();
	}
}
