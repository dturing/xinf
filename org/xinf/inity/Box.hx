package org.xinf.inity;

import org.xinf.geom.Rectangle;
import org.xinf.style.Color;
import org.xinf.style.Border;

class Box extends Group {
    public function new() {
        super();
    }

    private function _renderBorder( x:Float, y:Float, w:Float, h:Float, style:String, width:Float, color:Color ) :Void {
        if( style != null && style != "none" ) {
            GL.LineWidth( width );
            GL.PointSize( width );
            var b:Float = width/2;
            var c = color;
            
            GL.Color4f( c.r/0xff, c.g/0xff, c.b/0xff, c.a/0xff );
            GL.Begin( GL.LINES );
                GL.Vertex3f( x, y, 0. );
                GL.Vertex3f( w, h, 0. );
            GL.End();
            GL.Begin( GL.POINTS );
                GL.Vertex3f( x, y, 0. );
                GL.Vertex3f( w, h, 0. );
            GL.End();
        }
    }
    
    private function _renderGraphics() :Void {
        var b:Float = 0;
        
        if( style.marginLeft == null ) 
            trace("ZERO MARGIN: "+style.marginLeft+", in "+this.owner );
        var x:Float = style.marginLeft -.5;
        var y:Float = style.marginTop -.5;
        
        var w:Float = bounds.width - style.marginRight;    // w,h are not really width/height here,
        var h:Float = bounds.height - style.marginBottom;  // but right,bottom!
        
      // background
        var c = style.backgroundColor;
        if( c != null ) { // FIXME
            GL.Color4f( c.r/0xff, c.g/0xff, c.b/0xff, c.a/0xff );
        }
        GL.Begin( GL.QUADS );
            GL.Vertex3f( x, y, 0. );
            GL.Vertex3f( w, y, 0. );
            GL.Vertex3f( w, h, 0. );
            GL.Vertex3f( x, h, 0. );
        GL.End();
        
      // border
//        _renderBorder( x, y, x, h, style.borderStyleLeft, style.borderWidthLeft, style.borderColorLeft );
//        _renderBorder( w, y, w, h, style.borderStyleRight, style.borderWidthRight, style.borderColorRight );
        _renderBorder( x, y, w, y, style.borderStyleTop, style.borderWidthTop, style.borderColorTop );
//        _renderBorder( x, h, w, h, style.borderStyleBottom, style.borderWidthBottom, style.borderColorBottom );
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
