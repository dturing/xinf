/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;
import xinf.ul.Interface;
import xinf.ul.Component;

class Global extends Interface {
	
	static var global:Global;
	
	static function getGlobal() {
		if( global==null ) {
			global=new Global({ width:300, height:300 });
			global.layout = xinf.ul.layout.FlowLayout.Vertical5;
			global.addStyleClass("global");
			xinf.ony.Root.appendChild( global.getElement() );
			Root.addEventListener( GeometryEvent.STAGE_SCALED, global.onStageScaled );
		}
		return global;	
	}
	
	function onStageScaled( e:GeometryEvent ) {
		trace(e);
		size = prefSize;
		position = { x:e.x-size.x, y:(e.y-size.y)/2 };
	}
	
	public static function addNumeric( name:String, v:Float, min:Float, max:Float, ?step:Float, ?f:Float->Void ) {
		if( v==null ) v=min;
		if( step==null ) step=(max-min)/100;
		var s = new Slider( min, max, step );
		add( s, name, v, f );
	}
	
	public static function add<T>( widget:ValueWidget<T>, name:String, v:T, f:T->Void ) {
		widget.value = v;
		if( f!=null )
			widget.addEventListener( ValueEvent.VALUE, function(e:ValueEvent<Dynamic>) {
				f( e.value );
			});
		
		var g = getGlobal();
		var l = new Label(name);
		g.appendChild(l);
		g.appendChild(widget);
		widgets.set(name,widget);
	}

	public static function setValue<T>( name:String, value:T ) {
		var widget = widgets.get(name);
		if( widget!=null ) {
			widget.value = value;
		}
	}
	
}

