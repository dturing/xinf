/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.ul.ValueEvent;

class ValueWidget<T> extends Widget {
	
	private var _value:T;
	public var value(get_value,set_value):T;
	
	#if flash
	function get_value() :Dynamic {
	#else
	function get_value() :T {
	#end
		return _value;
	}
	
	function set_value( v:T ) :T {
		if( v != _value ) {
			_value=v;
			postEvent( new ValueEvent<T>( untyped ValueEvent.VALUE, _value ) ); //FIXME somehow, this should work w/o untyped
		}
		return _value;
	}
	
	public function addValueListener( f:T->Void ) :Dynamic {
		return addEventListener( untyped ValueEvent.VALUE, function(e) {
			f(e.value); } );
	}
	
}

