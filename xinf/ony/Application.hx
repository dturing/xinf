/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ony;

import Reflect;

typedef ApplicationParameter = {
	var name:String;
	var letter:String;
	var type:Type;
	var help:String;
	var defaultValue:Dynamic;
}

class Application {
	public function new( ?p:List<ApplicationParameter> ) :Void {
		trace("xinfony Application params: "+p );
		#if neko
			trace( "neko commandline args: "+neko.Sys.args() );
//			neko.Sys.exit(0);
		#end
	}

	public function run() :Void {
		Root.getRoot().run();
	}
	
	public function main( parameters:Hash<String>, arguments:List<String> ) :Int {
		return 0;
	}
}
