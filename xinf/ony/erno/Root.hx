/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.event.GeometryEvent;
import xinf.erno.Runtime;

/**
    Root represents the Runtime-default root Object, i.e., the Stage in Flash,
    the Document in JS, or the (main) Window in Xinfinity.
    <p>
        Root is  an <a href="Embed.html">Embed</a> Object that uses the 
        Runtime's default root to embed its display hierarchy. It also watches
        for STAGE_SCALED events to update it's size.
    </p>
**/
class Root extends Embed {
    
    /**
        Constructor; creates a new Root. This should only ever be called once
        for every Application (if you need multiple Roots, use <a href="Embed.html">Embed</a>).
        There is nothing checking this, so take care. If you instantiate an
        <a href="Application.html">Application</a>, the Root will be created for you,
        access it with Application.root.
    **/
    public function new() :Void {
        super( Runtime.runtime.getDefaultRoot() );
        Runtime.addEventListener( GeometryEvent.STAGE_SCALED, stageScaled );
    }

    private function stageScaled( e:GeometryEvent ) :Void {
//        resize(e.x,e.y);
    }
    
}
