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

package xinf.ul;

import xinf.ony.Group;
import xinf.geom.Types;
import xinf.event.GeometryEvent;

class Interface extends Container {
	var area:TRectangle;

	public function new( g:Group ) {
		super( g );

		var a = g.getTypedChildByName( "area", xinf.ony.Rectangle );
		area = { l:a.x, t:a.y, r:a.x+a.width, b:a.y+a.height };
		setPrefSize( { x:area.r-area.l, y:area.b-area.t } );
	}
}
