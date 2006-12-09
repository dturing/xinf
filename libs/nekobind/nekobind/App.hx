/* 
   nekobind - nekovm-C binding generator
   Copyright (c) 2006, Daniel Fischer.
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

package nekobind;

import haxe.rtti.Type;

class App {
	var found:Bool;
	var parser:haxe.rtti.XmlParser;

	public function new() :Void {
		parser = new haxe.rtti.XmlParser();
	}
	
	function load(file:String) {
		var data = neko.io.File.getContent(file);
		var x = Xml.parse(data).firstElement();
		parser.process(x,"neko");
	}

	public function filterEntry( e, className, g ) {
		switch(e) {
			case TPackage(name,full,entries):
				for( e in entries ) {
					filterEntry( e, className, g );
				}
				
			case TClassdecl(c):
				var inf = TypeApi.typeInfos(e);
				if( className == inf.path ) {
					g.handleClass(inf,c);
					found=true;
				}
				
			default:
		}
	}
	
	public function generateAll( className:String, g:Generator ) {
		found = false;
		parser.sort();
		for( e in parser.root ) {
			filterEntry( e, className, g );
		}
		if( !found ) {
			throw("Class '"+className+"' not found.");
		}
	}

	static function main() {
		var args = neko.Sys.args();
		if( args.length != 3 ) {
			neko.Lib.println("nekogen pre-alpha (C) 2006 daniel fischer <http://0xDF.com>");
			neko.Lib.println(" Usage: nekogen -<c|i> <haxe-generated xml file> <class name>");
			neko.Lib.println("         -c generates the C binding functions");
			neko.Lib.println("         -i generates the haXe binding implementation Class");
			neko.Sys.exit(1);
		}
		
		var xml=args[1];
		var cl=args[2];
		
		var g:Generator;
		switch( args[0] ) {
			case "-c":
				g = new CWrapperGenerator();
			case "-i":
				g = new HaxeImplGenerator();
			default:
				throw("no option "+args[0] );
		};
		
		var m = new App();
		m.load( xml );
		m.generateAll( cl, g );
	}
}
