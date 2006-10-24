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

package xinf.live;

class LiveObject extends xinf.ony.Object {
	public var name:String;
	
	public function new( name:String ) :Void {
		super();
		this.name = name;
	}
	
	public function changed() :Void {
		scheduleRedraw();
		postEvent( new ChangeEvent( ChangeEvent.CHANGED, this ) );
	}
	
	public function relatesTo( d:LiveObject ) :Void {
		d.addEventListener( ChangeEvent.CHANGED, relativeChanged );
	}
	
	public function relativeChanged( e:ChangeEvent ) :Void {
		changed();
	}
	
	public function toString() :String {
		return name;
	}
}
