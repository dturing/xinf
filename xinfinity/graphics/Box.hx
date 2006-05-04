package xinfinity.graphics;

import xinf.geom.Rectangle;

class Box extends Group {
    public function new() {
    }
    
    private function _render() :Void {
        var w = width;
        var h = height;
        
      //  style.color._render();
        GL.Color4f( 1., 1., 1., 1. );
        GL.Begin( GL.QUADS );
            GL.Vertex3f( w , 0., 0. );
            GL.Vertex3f( w , h , 0. );
            GL.Vertex3f( 0., h , 0. );
            GL.Vertex3f( 0., 0., 0. );
        GL.End();
        
        super._render();
    }
}
