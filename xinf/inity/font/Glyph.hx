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

package xinf.inity.font;

import xinf.inity.GLPolygon;
import xinf.erno.DrawingInstruction;

// FIXME: cache in display list?
class Glyph {
    private var polygon:Array<DrawingInstruction>;
	private var displayList:Int;
    public var advance:Float;
    
    public function new( p:Array<DrawingInstruction>, adv:Float ) {
		polygon = p;
        advance = adv;
		
//		cache(1.0);
    }
	
	public function cache( pixelSize:Float ) :Void {
		var p = new GLPolygon(pixelSize);
		for( i in polygon ) {
			p.append(i);
		}
		
		GL.NewList( displayList, GL.COMPILE );
		p.drawFilled();
		GL.EndList();
	}
    
    public function render( s:Float ) {
		if( displayList==null ) {
			displayList = GL.GenLists(1);
			Font.cacheGlyph(this);
		}

		GL.CallList(displayList);
        GL.Translatef( Math.round((advance*s))/s, .0, .0 );
	}
}