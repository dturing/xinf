
import freetype.Font;

class FontDumper {
	public var dump:String;
	
	public function new() :Void {
		dump="";
	}
	
    public function startContour( x:Int, y:Int ) :Void {
    }

    public function endContour() :Void {
    }

    public function lineTo( x:Int, y:Int ) :Void {
    }

    public function curveTo( cx:Int, cy:Int, x:Int, y:Int ) :Void {
    }

    public function endGlyph( character:Int, advance:Int ) :Void {
		if( character > 32 && character <= 128 )
			dump += String.fromCharCode(character)+" ";
	}
}


class App extends haxe.unit.TestCase {
	private var font:Font;
	
	function testIterate() {
		var dumper = new FontDumper();
		font.iterateAllGlyphs( dumper );
		assertEquals( 
			"! \" # $ % & ' ( ) * + , - . / 0 1 2 3 4 5 6 7 8 9 : ; < = > ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \\ ] ^ _ ` a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~ ",
			dumper.dump );
	}

	public function new() {
		super();
		var data = Std.resource("default-font");
		font = new Font( data );
	}
	
	public static function main() {
		var r = new haxe.unit.TestRunner();
		r.add( new App() );
		r.run();
	}
}
