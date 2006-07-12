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
	SimpleEvent is an Event that carries no further data.
**/
class SimpleEvent extends Event<SimpleEvent> {
/** quit application **/
	static public var QUIT = new EventKind<SimpleEvent>("quit");
/** something changed about the target **/
	static public var CHANGED = new EventKind<SimpleEvent>("changed");
/** Element Style changed **/
	static public var STYLE_CHANGED = new EventKind<SimpleEvent>("styleChanged");

	public function new( _type:EventKind<SimpleEvent>, target:EventDispatcher ) {
		super(_type,target);
	}
}
