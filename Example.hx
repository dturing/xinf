import Xinf;
import xinf.ul.magic.Magic;
import xinf.ul.magic.MagicType;

class Example {
	
	public function new() :Void {
		xinf.ul.Component.init();

		xinf.style.StyleSheet.DEFAULT.parseCSS( "
			.magicLabel {
				padding: 6 3 6 3;
				horizontal-align: 1.;
			}
		");

		var g = new Group();
		Root.appendChild(g);
	
		var iface = new Magic([
				{ name:"name", type:Textual("[undefined]") },
				{ name:"fps", type:Textual("-") },
				{ name:"contrast", type:Numeric(0,100,50) },
			]);
		iface.appendTo( g, 320, 240 );
		iface.getElement().transform = new Translate( 100, 100 );
		 
		//iface.set("name","Testing...");
		iface.listen("contrast",function(c:Float) {
				trace("set contrast to "+c );
			});
	}
	
	public static function main() :Void {
		var d = new Example();
		Root.main();
	}
}
