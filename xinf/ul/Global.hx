/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;
import xinf.ul.Interface;
import xinf.ul.Component;
import xinf.ul.ValueEvent;
import xinf.ul.widget.Label;
import xinf.ul.widget.LineEdit;
import xinf.ul.widget.Slider;
import xinf.ul.widget.CheckBox;
import xinf.ul.layout.GridLayout;

class Global extends Interface {
	
	static var global:Global;
	
	static function getGlobal() {
		if( global==null ) {
			global=new Global({ width:300, height:300 });
			global.layout = new GridLayout( 2, 3,3, true );
			global.addStyleClass("global");
			xinf.ony.Root.appendChild( global.getElement() );
			Root.addEventListener( GeometryEvent.STAGE_SCALED, global.onStageScaled );
		}
		return global;	
	}
	
	function onStageScaled( e:GeometryEvent ) {
		trace(e);
		size = prefSize;
		position = { x:e.x-size.x, y:e.y-size.y };
	}
	
	public static function addNumeric( name:String, v:Float, min:Float, max:Float, ?step:Float, ?f:Float->Void ) {
		if( v==null ) v=min;
		if( step==null ) step=(max-min)/100;
		var s = new Slider( min, max, step );
		s.value = v;
		if( f!=null )
			s.addEventListener( ValueEvent.VALUE, function(e) {
				f( untyped e.value ); // FIXME
			});
		
		append( name, s );
	}

	public static function setValue<T>( name:String, value:T ) {
		throw("nyi");
	}

	static function append( name:String, c:Component ) {
		var g = getGlobal();
		var l = new Label(name);
//		l.addStyleClass("global");
		g.appendChild(l);
		
//		c.addStyleClass("global");
		g.appendChild(c);
	}
	
}

