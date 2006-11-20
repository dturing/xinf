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

class SimpleEventDispatcher implements EventDispatcher {
	private var listeners :Hash<List<Dynamic->Void>>;
	private var filters :List<Dynamic->Bool>;

	public function new() :Void {
		listeners = new Hash<List<Dynamic->Void>>();
	}

	public function addEventListener<T>( type :EventKind<T>, h :T->Void ) :T->Void {
		var t = type.toString();
		var l = listeners.get( t.toString() );
		if( l==null ) {
			l = new List<Dynamic->Void>();
			listeners.set( t, l );
		}
		l.push( h );
		return h;
	}

	public function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool {
		var t = type.toString();
		var l:List<Dynamic->Void> = listeners.get( t.toString() );
		if( l!=null ) {
			return l.remove(h);
		}
		return false;
	}

	public function removeAllListeners<T>( type :EventKind<T> ) :Bool {
		return( listeners.remove( type.toString() ) );
	}

	public function addEventFilter( f:Dynamic->Bool ) :Void {
		if( filters==null ) filters=new List<Dynamic->Bool>();
		filters.push(f);
	}

	public function dispatchEvent<T>( e : Event<T> ) :Void {
		var l:List<Dynamic->Void> = listeners.get( e.type.toString() );
		var dispatched:Bool = false;
		
		if( filters!=null ) {
			for( f in filters ) {
				if( f(e)==false ) return;
			}
		}
		
		if( l != null ) {
			for( h in l ) {
				h(e);
				dispatched=true;
			}
		}
		/*
		if( !dispatched ) {
			trace("unhandled event: "+e );
		}
		*/
	}

	public function postEvent<T>( e : Event<T>, ?pos:haxe.PosInfos ) :Void {
		// FIXME if debug_events
		e.origin = pos;
		
		// for now, FIXME (maybe)
		dispatchEvent(e);
	}
}
