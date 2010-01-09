/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Native extends Element {
	private var p:NativeObject;

	public function new( p:NativeObject, ?traits:Dynamic ) :Void {
		super(traits);
		this.p=p;
	}
	
	override function drawContents( g:Renderer ) :Void {
		if( p!=null ) {
			g.native(p);
		}
	}
}
