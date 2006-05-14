package org.xinf.inity;

import org.xinf.geom.Rectangle;
import org.xinf.style.Border;
import org.xinf.style.Pad;

class Box extends Group {
    public function new() {
        super();
    }

    private function _renderGraphics() :Void {
        var border:Border = style.border;
        var padding:Pad = style.padding;
            
        var b:Float = border.thickness.px();
        
        var w:Float = style.width.px()-1;   // w,h are not really width/height here,
        var h:Float = style.height.px()-1;  // but right,bottom!
        var x:Float = 0;
        var y:Float = 0;
        
      // background
        var c = style.background;
        GL.Color4f( c.r/0xff, c.g/0xff, c.b/0xff, c.a/0xff );
        GL.Begin( GL.QUADS );
            GL.Vertex3f( x, y, 0. );
            GL.Vertex3f( w, y, 0. );
            GL.Vertex3f( w, h, 0. );
            GL.Vertex3f( x, h, 0. );
        GL.End();
        
      // border
        if( b > 0 ) {
            GL.LineWidth( b );
            b /= 2;
            b-=0.5;
            var c = border.color;
            GL.Color4f( c.r/0xff, c.g/0xff, c.b/0xff, c.a/0xff );
            GL.Begin( GL.LINE_STRIP );
                GL.Vertex3f( x+b, y+b, 0. );
                GL.Vertex3f( w-b, y+b, 0. );
                GL.Vertex3f( w-b, h-b, 0. );
                GL.Vertex3f( x+b, h-b, 0. );
                GL.Vertex3f( x+b, y+b, 0. );
            GL.End();
            GL.PointSize( border.thickness.value );
            GL.Begin( GL.POINTS );
                GL.Vertex3f( w-b, y+b, 0. );
                GL.Vertex3f( w-b, h-b, 0. );
                GL.Vertex3f( x+b, h-b, 0. );
                GL.Vertex3f( x+b, y+b, 0. );
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

        // FIXME: this duplicates stuff in _renderGraphics
        var border:Border = style.border;
        var padding:Pad = style.padding;
        var b:Float = border.thickness.px();
        var w:Float = style.width.px();   // w,h are not really width/height here,
        var h:Float = style.height.px();  // but right,bottom!

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
