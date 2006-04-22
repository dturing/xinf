package org.xinf.display;

import org.xinf.display.DisplayObjectContainer;
import org.xinf.display.Graphics;
import org.xinf.render.IRenderer;

class Sprite extends DisplayObjectContainer {
    public property graphics(default,null):Graphics;

    public function new() {
        super();
        graphics = new Graphics();
    }
    
    private function _render( r:IRenderer ) {
        r.pushMatrix();
        r.matrix( transform.matrix );
        graphics._render(r);
        r.popMatrix();
        
        super._render(r);
    }
}
