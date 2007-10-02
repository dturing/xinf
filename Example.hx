import Xinf;

import xinf.ul.widget.Button;

class Example {
	public static function main() {
		var url = "file://test.svg";
		//var url = "http://localhost/svg/struct-image-02-b.svg";
		
		trace("trying to load: "+url );
		
		#if neko
			if( neko.Sys.args().length>0 ) {
				url = neko.Sys.args()[0];
			}
		#end
		
		var doc = Document.load( url );
		Root.attach( doc );
	
		try {
			var root:Group = doc.getTypedElementById("test",Group);
			var i = new xinf.ul.Interface(root);
			
			var b = Button.createSimple("Hello", function(v) {
				trace(v); }, "Clicked Hello" );
				
			i.attach(b);
		} catch( e:Dynamic ) {
			trace("Exception in UL Test: "+e );
		}
		
		Root.main();
	}
}
