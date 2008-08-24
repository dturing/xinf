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
		size = prefSize;
		position = { x:e.x-size.x, y:(e.y-size.y)/2 };
	}
	
	public static function add<T>( c:Component ) {
		var g = getGlobal();
		g.appendChild(c);
	}

}

