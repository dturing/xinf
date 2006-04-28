package org.xinf.demo;

import org.xinf.display.DisplayObjectContainer;
import org.xinf.display.Graphics;
import org.xinf.display.Font;
import org.xinf.render.IRenderer;
import org.xinf.geom.Point;

class DrawTest extends DisplayObjectContainer {
    public property graphics(default,null):Graphics;
    
    public var font:Font;

    public function new() {
        super();
        graphics = new Graphics();
        var fr = new FontReader("/home/dan/.fonts/vera.ttf");
        font = fr.getFont();

        graphics.clear();
        graphics.beginFill( 0xffffff, .7 );
        graphics.lineTo( 0, .5 );
//        graphics.cubicTo( new Point(.2, .7), new Point(.4, .3), new Point(.6, .5) );
        graphics.quadraticTo( new Point(.25, .75), new Point(.5, .5) );
        graphics.lineTo( .5, 0 );
        graphics.lineTo( 0, 0 );
        graphics.endFill();
    }
    
    private function _render( r:IRenderer ) {
        
        r.pushMatrix();
        r.matrix( transform.matrix );
        
        //graphics._render(r);
        var g:Glyph = font.getGlyph(97);
        if( g == null ) throw("glyph not found" );
        
      //  trace("glyph: "+g );
        g._render(r);

        g = font.getGlyph(98);
        g._render(r);
        
        r.popMatrix();
        
        super._render(r);
    }
}
