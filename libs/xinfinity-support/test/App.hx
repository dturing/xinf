
import xinf.support.Font;
import xinf.support.Pixbuf;

class FontDumper {
	public var dump:String;
	
	public function new() :Void {
		dump="";
	}
	
    public function startContour( x:Int, y:Int ) :Void {
		dump+=("start("+x+","+y+") ");
    }

    public function endContour() :Void {
		dump+=("end ");
    }

    public function lineTo( x:Int, y:Int ) :Void {
		dump+=("lineTo("+x+","+y+") ");
    }

    public function curveTo( cx:Int, cy:Int, x:Int, y:Int ) :Void {
		trace("curveTo("+x+","+y+","+cx+","+cy+") ");
    }

    public function endGlyph( character:Int, advance:Int ) :Void {
		if( character > 32 && character <= 128 )
			dump += ":"+String.fromCharCode(character)+" ";
	}
}


class App extends haxe.unit.TestCase {
	private var font:Font;
	
	function testIterate() {
		var dumper = new FontDumper();
		font.iterateAllGlyphs( dumper );
		assertEquals( 
			"start(0,53) lineTo(64,53) lineTo(64,-11) lineTo(0,-11) lineTo(0,53) end :a ",
			dumper.dump );
			
		// TODO: check font metrics.
	}
    
    function testPixbuf() {
        var data = Std.resource("xinf.gif");
        var pixbuf = Pixbuf.newFromCompressedData( data );
        assertEquals(100,pixbuf.getWidth());
        assertEquals(61,pixbuf.getHeight());
        assertEquals(1,pixbuf.getHasAlpha());
		assertEquals( 100*61*4, neko.Lib.nekoToHaxe(pixbuf.copyPixels()).length );
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
