package org.xinf.inity;

import org.xinf.style.Border;
import org.xinf.style.Pad;

class Bitmap extends Group {
    private var data:BitmapData;

    public function new( _data:BitmapData ) {
        super();
        data = _data;
    }

    private function _renderGraphics() :Void {
        var border:Border = style.border;
        var padding:Pad = style.padding;
            
        var b:Float = border.thickness.px();
        
        var w:Float = style.width.px()+padding.left.px()+padding.right.px();   // w,h are not really width/height here,
        var h:Float = style.height.px()+padding.top.px()+padding.bottom.px();  // but right,bottom!
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
        if( border.thickness.value > 0 ) {
            GL.LineWidth( border.thickness.value );
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
    }
    
    private function _render() :Void {
        _renderGraphics();
        super._render();
    }

    private function _renderSimple() :Void {
        var w = style.width.px();
        var h = style.height.px();

        // FIXME: this duplicates stuff in _renderGraphics (and Box.hx, for that matter)
        var border:Border = style.border;
        var padding:Pad = style.padding;
        var b:Float = border.thickness.px();
        var w:Float = style.width.px()+b+b+padding.left.px()+padding.right.px();   // w,h are not really width/height here,
        var h:Float = style.height.px()+b+b+padding.top.px()+padding.bottom.px();  // but right,bottom!

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
