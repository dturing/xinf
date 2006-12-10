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
class ScrollEvent extends Event<ScrollEvent> {
	static public var SCROLL_STEP = new EventKind<ScrollEvent>("scrollStep");
	static public var SCROLL_LEAP = new EventKind<ScrollEvent>("scrollLeap");
	static public var SCROLL_TO   = new EventKind<ScrollEvent>("scrollTo");

	public var value:Float; // delta (+-1.0) or absolute (0..1) - depending on the kind
	public var targetId:Int;
	
	public function new( _type:EventKind<ScrollEvent>, value:Float, ?targetId:Int ) {
		super(_type);
		this.value = value;
		this.targetId = targetId;
	}
}
