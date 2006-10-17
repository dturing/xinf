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

package xinf.erno;

import xinf.erno.DrawingInstruction;

class Renderer {
	public function draw( i:DrawingInstruction ) :Void {
		trace("unimplemented drawing instruction "+i);
	}
	
	public function drawList( instructions:Iterator<DrawingInstruction> ) :Void {
		for( i in instructions ) {
			draw( i );
		}
	}
	
	public function getNextId() :Int {
		throw("unimplemented");
		return null;
	}
	public function getRootId() :Int {
		throw("unimplemented");
		return null;
	}
}