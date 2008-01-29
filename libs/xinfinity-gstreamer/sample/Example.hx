import Xinf;
import XinfMedia;

import xinf.style.Selector;
import xinf.style.StyleSheet;

class Example {
	
	public function new( ?url:String ) :Void {
	
		var g = new Group();
		Root.appendChild(g);
		
		var doc:Node;
		var stage = {x:100.,y:100.};
		
		if( url==null ) {
			doc = Document.instantiate( Std.resource("test.svg") );
			g.appendChild( doc );
		} else {
			Document.load( url, function(doc) {
				g.appendChild( doc );
			});
		}

		var scale = 1.;
		var offset={ x:0., y:0. };
		
		var trans = function() {
			//doc.transform = new Scale( stage.x/doc.width, stage.y/doc.height );
			g.transform = new TransformList([
								new Translate( 0, 0 ), //-doc.width/2, -doc.height/2 ),
//									new Scale(  (stage.x/doc.width)*scale, 
//												(stage.y/doc.height)*scale ),
								new Scale(  scale, scale ),
								new Translate(offset.x,offset.y),
								new Translate( stage.x/2, stage.y/2 ),
							]);
		};

		Root.addEventListener( GeometryEvent.STAGE_SCALED, function(e) {
			stage.x=e.x; stage.y=e.y;
			trans();
		});
		

		Root.addEventListener( KeyboardEvent.KEY_DOWN, function(e) {
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
			
			trans();
		});
		
		Root.addEventListener( MouseEvent.MOUSE_DOWN, function(check) {
			var upL:Dynamic;
			var moveL:Dynamic;
			var old = offset;
			moveL= Root.addEventListener( MouseEvent.MOUSE_MOVE, function(e) {
				offset = { x:old.x-(check.x-e.x), y:old.y-(check.y-e.y) };
				trans();
			});
			upL = Root.addEventListener( MouseEvent.MOUSE_UP, function(e) {
				Root.removeEventListener( MouseEvent.MOUSE_UP, upL );
				Root.removeEventListener( MouseEvent.MOUSE_MOVE, moveL );
			});
		});
	}
	
	public static function main() :Void {
		var arg:String;
		#if neko
			arg = neko.Sys.args()[0];
		#end
		var d = new Example( arg );
		Root.main();
	}
}
