package org.xinf.inity;

class Bitmap extends Group {
    private var data:BitmapData;

    public function new( _data:BitmapData ) {
        super();
        data = _data;
    }

    private function _renderGraphics() :Void {
            
        var b:Float = 1; // FIXME border.thickness.px();
        
        var w:Float = bounds.width;   // w,h are not really width/height here,
        var h:Float = bounds.height;  // but right,bottom!
        var x:Float = 0;
        var y:Float = 0;
        
      // image
        //var c = style.background;
        //GL.Color4f( c.r/0xff, c.g/0xff, c.b/0xff, c.a/0xff );
        GL.Color4f( 1., 1., 1., 1. );
        GL.PushMatrix();
        GL.Translatef( b, b, 0 );
        data.render( w, h, 0, 0, 1, 1 );
        GL.PopMatrix();
        
      // border (dups Box.hx)
      /*
        if( b > 0 ) {
            GL.LineWidth( b );
            var c = border.color;
            GL.Color4f( c.r/0xff, c.g/0xff, c.b/0xff, c.a/0xff );
            GL.Begin( GL.LINE_STRIP );
                GL.Vertex3f( x, y, 0. );
                GL.Vertex3f( w, y, 0. );
                GL.Vertex3f( w, h, 0. );
                GL.Vertex3f( x, h, 0. );
                GL.Vertex3f( x, y, 0. );
            GL.End();
            GL.PointSize( border.thickness.value );
            GL.Begin( GL.POINTS );
                GL.Vertex3f( w, y, 0. );
                GL.Vertex3f( w, h, 0. );
                GL.Vertex3f( x, h, 0. );
                GL.Vertex3f( x, y, 0. );
            GL.End();
        }
        */
    }
    
    private function _render() :Void {
        _renderGraphics();
        super._render();
    }

    private function _renderSimple() :Void {
        var w = bounds.width;
        var h = bounds.height;

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
