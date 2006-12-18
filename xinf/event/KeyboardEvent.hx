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

class KeyboardEvent extends Event<KeyboardEvent> {
	
	static public var KEY_DOWN = new EventKind<KeyboardEvent>("keyDown");
	static public var KEY_UP   = new EventKind<KeyboardEvent>("keyUp");

	public var code:Int;
	public var key:String;
	public var shiftMod:Bool;
	public var altMod:Bool;
	public var ctrlMod:Bool;
	
	public function new( _type:EventKind<KeyboardEvent>, 
			code:Int, key:String, ?shiftMod:Bool, ?altMod:Bool, ?ctrlMod:Bool ) {
		super(_type);
		this.code=code; this.key=key;
		this.shiftMod = if( shiftMod==null ) false else shiftMod;
		this.altMod = if( altMod==null ) false else altMod;
		this.ctrlMod = if( ctrlMod==null ) false else ctrlMod;
	}

	public function toString() :String {
		// FIXME #if debug
		var r = ""+type+"(";
		if( shiftMod ) r+="Shift-";
		if( altMod ) r+="Alt-";
		if( ctrlMod ) r+="Ctrl-";
		if( key==null ) r+="[null]";
		else if( r.length==1 ) r+="'"+key+"'";
		else r+=key;
		r+=")";
		return r;
	}
	
}
