import Xinf;

import xinf.style.Selector;
import xinf.style.StyleSheet;

class Example {

	var g:Group;
	var doc:Svg;
	
	public function new( ?url:String ) :Void {
	
		g = new Group();
		Root.appendChild(g);
		
		var stage = {x:100.,y:100.};

		var scale = 1.;
		var offset={ x:0., y:0. };
		var self=this;
		
		var trans = function() {
			//doc.transform = new Scale( stage.x/doc.width, stage.y/doc.height );
			self.g.transform = new Concatenate( 
							new Concatenate(
								new Translate( 0, 0 ), //-doc.width/2, -doc.height/2 ),
								new Concatenate(
//									new Scale(  (stage.x/doc.width)*scale, 
//												(stage.y/doc.height)*scale ),
									new Scale(  scale, scale ),
									new Translate(offset.x,offset.y)
								)
							),
							new Translate( stage.x/2, stage.y/2 )
							);
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
				case "s":
					var o = neko.io.File.write("out.svg",false);
					o.write( xinf.xml.PrettyPrinter.pretty( self.doc.toXml() ) );
					o.close();
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

		load( url );

	}
	
	public function load( url:String ) :Void {
		if( doc!=null ) {
			g.removeChild(doc);
		}
		
		var self=this;
		var onLoad = function(doc:Svg) {
				self.doc=doc;
				self.g.appendChild( doc );
				doc.addEventListener( LinkEvent.ACTUATE, function(e) {
					self.load(e.href);
				});
			};
		
		if( url==null ) {
			Document.instantiate( Std.resource("test.svg"), onLoad, Svg );
		} else {
			Document.load( url, onLoad, Svg );
		}

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
