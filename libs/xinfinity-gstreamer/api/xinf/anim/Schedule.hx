/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

typedef Cue<T> = {
	time:Float,
	value:T,
	next:Cue<T>,
}

class Schedule<T> {
	var first:Cue<T>;
	
	public function new() {
	}
	
	public function until( time:Float ) :Iterator<T> {
		var self=this;
		return {
			hasNext: function() {
				return( self.first!=null && self.first.time<=time );
			},
			next: function() {
				if( self.first==null || self.first.time>time ) return null;
				var r = self.first.value;
				self.first = self.first.next;
				return r;
			},
		};
	}
	
	public function callUntil( time:Float, f:T->Float->Void ) {
		while( first!=null && first.time<time ) {
			f(first.value,first.time);
			first = first.next;
		}
	}
			
	public function insert( time:Float, value:T ) :Void {
		var cue = { time:time, value:value, next:null };
		if( first==null ) {
			first=cue;
		} else {
			var c=first;
			var last = null;
			while( c!=null && c.time<=cue.time ) {
				last=c;
				c=c.next;
			}
			if( last==null ) {
				cue.next=c;
				first=cue;
			} else {
				cue.next=last.next;
				last.next=cue;
			}
		}
	}
	
	public function remove( value:T ) :Void {
		var l=null;
		var cue=first;
		while( cue!=null ) {
			if( cue.value == value ) {
				if( l!=null ) {
					l.next = cue.next;
				} else {
					first = cue.next;
				}
			}
			l=cue;
			cue=cue.next;
		}
	}
	
	public function toArray() {
		var r = new Array<T>();
		var cue = first;
		while( cue != null ) {
			r.push(cue.value);
			cue = cue.next;
		}
		return r;
	}
	
	public function dump() {
		trace("Schedule dump: ");
		var cue = first;
		while( cue != null ) {
			trace("@"+(Math.round(cue.time*100)/100)+": "+cue.value);
			cue = cue.next;
		}
	}
}
