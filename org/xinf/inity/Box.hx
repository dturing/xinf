package org.xinf.inity;

class Box extends Group {
    public function new() {
        super();
    }

    private function _renderGraphics() :Void {
        var b:Float = 0;
        
        var x:Float = -.5;
        var y:Float = -.5;
        
        var w:Float = bounds.width;    // w,h are not really width/height here,
        var h:Float = bounds.height;   // but right,bottom!
        
      // background
        GL.Color4f( bgColor.r, bgColor.g, bgColor.b, bgColor.a );
        GL.Begin( GL.QUADS );
            GL.Vertex3f( x, y, 0. );
            GL.Vertex3f( w, y, 0. );
            GL.Vertex3f( w, h, 0. );
            GL.Vertex3f( x, h, 0. );
        GL.End();
    }
    
    private function _render() :Void {
        _renderGraphics();
        super._render();
    }

    private function _renderSimple() :Void {
        // FIXME: this duplicates stuff in _renderGraphics
        var w:Float = bounds.width;   // w,h are not really width/height here,
        var h:Float = bounds.height;  // but right,bottom!

      //  background
        GL.Begin( GL.QUADS );
            GL.Vertex3f( w , 0., 0. );
            GL.Vertex3f( w , h , 0. );
            GL.Vertex3f( 0., h , 0. );
            GL.Vertex3f( 0., 0., 0. );
        GL.End();
        
        super._renderSimple();
    }
}
