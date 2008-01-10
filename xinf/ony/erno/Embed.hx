/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

/**
    A Root-like Object, embeds a Xinfony display hierarchy
    into a Runtime-native Object.
**/
class Embed extends Group {
    
    private var root:NativeContainer;
    
    /**
        Constructor. Pass in a NativeContainer (a DisplayObjectContainer
        for Flash, a HtmlDom for JS, or a GLObject for Xinfinity); this Object
        will aquire it and use it as the root for this display hierarchy.
    **/
    public function new( o:NativeContainer ) :Void {
        super();
        root = o;
    }

    /**
        redraws the Object. This redefines the contents of the NativeContainer
        you passed to the constructor.
    **/
    override public function draw( g:Renderer ) :Void {
        g.startNative( root );
        for( child in mChildren ) {
			if( untyped child.xid!=null )
				g.showObject( untyped child.xid );
        }
        g.endNative();
    }
}
