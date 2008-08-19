/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.ul.ValueEvent;

/**
	Slider (numeric entry) element.
**/

class ValueWidget<T> extends Widget {
	
	private var _value:T;
	public var value(get_value,set_value):T;
	
	function get_value() :T {
		return _value;
	}
	
	function set_value( v:T ) :T {
		if( v != _value ) {
			_value=v;
			postEvent( new ValueEvent<T>( untyped ValueEvent.VALUE, _value ) ); //FIXME somehow, this should work w/o untyped
		}
		return _value;
	}
	
}
