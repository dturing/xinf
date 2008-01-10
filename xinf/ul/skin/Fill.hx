/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.style;

import xinf.erno.Renderer;

interface Fill {
    public function draw( g:Renderer, s:{x:Float,y:Float} ) :Void;
}
