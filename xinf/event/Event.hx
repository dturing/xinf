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
	Base class for all events.
    The type argument (T) has to be set to a child class of Event.
**/

class Event<T> {
	public var type(default,null) : EventKind<T>;
	
	public var origin:haxe.PosInfos; // FIXME if debug_events
	
	public function new( t ) {
		type = t;
	}
	
	public function toString() :String {
		// FIXME #if debug
		var r = ""+type;
		if( origin != null ) r+=", from "+origin.fileName+":"+origin.lineNumber+" { ";
		for( field in Reflect.fields(this) ) {
			if( field != "origin" )
				r+=field+":"+Reflect.field(this,field)+" ";
		}
		r+=" }";
		
		return r;
	}
}
