package org.xinf.display;

import org.xinf.display.DisplayObjectContainer;
import org.xinf.render.IRenderer;

class Stage extends DisplayObjectContainer {
    public var renderer : IRenderer;
    
    public function new( r:IRenderer ) {
        super();
        stage = this;
        root = this;
        renderer = r;
    }
        
    public function Render() {
        renderer.startFrame();
        _render(renderer);
        renderer.endFrame();
    }
}
