package xinfinity.graphics;

import xinf.geom.Rectangle;

class Box extends Group {
    public function new() {
        super();
        width = 100;
        height = 100;
    }

    private var _width:Float;
    private var _height:Float;
    private function _getWidth() : Float {
        return _width;
    }
    private function _setWidth(w:Float) : Float {
        _width=w; return w;
    }
    private function _getHeight() : Float {
        return _height;
    }
    private function _setHeight(h:Float) : Float {
        _height = h; return h;
    }
    
    private function _renderGraphics() :Void {
        var w = width;
        var h = height;

      //  style.color._render();
        GL.Color4f( 1., 1., 1., .5 );
        GL.Begin( GL.QUADS );
            GL.Vertex3f( w , 0., 0. );
            GL.Vertex3f( w , h , 0. );
            GL.Vertex3f( 0., h , 0. );
            GL.Vertex3f( 0., 0., 0. );
        GL.End();
    }
    
    private function _render() :Void {
        _renderGraphics();
        super._render();
    }

    private function _renderSimple() :Void {
        _renderGraphics();
        super._renderSimple();
    }
}
