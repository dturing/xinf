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
import xinf.erno.Runtime;

class Application {
	public var root(default,null):Root;
	public var runtime(default,null):Runtime;
	
	public function new() :Void {
		Runtime.init();
		runtime = Runtime.runtime;
		root = new Root();
	
/*
		#if neko
			trace( "neko commandline args: "+neko.Sys.args() );
			neko.Sys.exit(0);
		#end
*/
	}

	public function run() :Void {
		Runtime.run();
	}
}
