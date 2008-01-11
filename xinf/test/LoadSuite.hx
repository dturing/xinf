/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test;

import xinf.test.TestCase;
import xinf.test.TestShell;
import xinf.test.svg.SVGTest;
import Xinf;

class LoadSuite {
    static function main() {
		new LoadSuite().run();
	}
	
	var suite:String;
	var pkg:String;
	var dir:String;
	var base:String;
	
	public function new() {
		suite = "SVG1.2";
		pkg="paint";
		dir = suite+"/svg/";
		base="http://localhost:2000/static/";
	}
	
	public function run() {
		var rq = new haxe.Http( base+suite+".xml" );
		rq.onError = function(e) { throw(e); };
		rq.onData = loaded;
		rq.request(false);
	}
	
	public function loaded( data:String ) {
		var shell = new TestShell(suite);
		
		var xml = Xml.parse(data);
		for( e in xml.firstChild().elements() ) {
			if( e.nodeName == "package"
			 && e.get("name") == pkg ) {
				for( t in e.elements() ) {
					shell.add( new SVGTest( 
						base+dir+t.get("file") ) );					
				}
			}
		}
		
        shell.run();
    }
}
