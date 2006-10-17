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
	xinf.event.Global is the application-unique EventDispatcher
	for global events (like QUIT, ENTER_FRAME, etc).
**/

class Global extends SimpleEventDispatcher {
	public static var global:Global = new Global();
	
	public static function addEventListener<T>( type :EventKind<T>, h :T->Void ) :Void {
		global.addEventListener( type, h );
	}

	public static function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool {
		return global.removeEventListener( type, h );
	}

	public static function dispatchEvent<T>( e : Event<T> ) :Void {
		global.dispatchEvent(e);
	}

	public static function postEvent<T>( e : Event<T>, pos:haxe.PosInfos ) :Void {
		// FIXME. global events would get delivered to root mostly, if we used postEvent...
		e.origin = pos;
		global.dispatchEvent(e);
	}
}
