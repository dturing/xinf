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

package xinf.event;

/**
	
**/
class MouseEvent extends Event<MouseEvent> {
	static public var MOUSE_DOWN = new EventKind<MouseEvent>("mouseDown");
	static public var MOUSE_UP   = new EventKind<MouseEvent>("mouseUp");
	static public var MOUSE_MOVE = new EventKind<MouseEvent>("mouseMove");
	static public var MOUSE_OVER = new EventKind<MouseEvent>("mouseOver");
	static public var MOUSE_OUT  = new EventKind<MouseEvent>("mouseOut");

	public var x:Int;
	public var y:Int;
	public var button:Int;
	public var targetId:Int;
	
	public function new( _type:EventKind<MouseEvent>, _x:Int, _y:Int, ?_button:Int, ?targetId:Int ) {
		super(_type);
		x=_x; y=_y; button=_button;
		this.targetId = targetId;
	}
}
