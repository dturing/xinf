/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Native extends Object {
    private var p:NativeObject;

    public function new( p:NativeObject ) :Void {
        super();
        this.p=p;
    }
    
    public function drawContents( g:Renderer ) :Void {
        if( p!=null ) {
            g.native(p);
        }
    }
}
