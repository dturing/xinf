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
import xinf.event.EventKind;
import xinf.event.Event;
import xinf.event.EventDispatcher;

/**
	GeometryEvent is used to propagate information about changes
	in position or size of some Element.
**/
class GeometryEvent extends Event<GeometryEvent> {
	static public var SIZE_CHANGED     = new EventKind<GeometryEvent>("sizeChanged");
	static public var POSITION_CHANGED = new EventKind<GeometryEvent>("positionChanged");
	
	public var x:Int;
	public var y:Int;
	
	public function new( _type:EventKind<GeometryEvent>, target:EventDispatcher, _x:Int, _y:Int ) {
		super(_type,target);
		x=_x; y=_y;
	}
}