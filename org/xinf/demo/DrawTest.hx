package org.xinf.demo;

import org.xinf.display.Graphics;
import org.xinf.display.Font;
import org.xinf.render.IRenderer;
import org.xinf.geom.Point;

class DrawTest extends Square {
    public var font:Font;
    public var cached:Bool;

    public function new() {
        super( "DrawTest", .0, .0, 320, 240, .0, 0xffffff );
        var fr = new FontReader("/home/dan/.fonts/textra.ttf");
        font = fr.getFont();
        cached = false;
    }
    
    private function draw( c:Int, a:Float ) {
        graphics.clear();
        graphics.beginFill( c, a );
/*        
        graphics.moveTo( .1, .1 );
        graphics.lineTo( .3, .2 );
        graphics.lineTo( .3, .4 );
        graphics.lineTo( .0, .4 );
        graphics.lineTo( .1, .1 );
        */
    /*
        
        graphics.lineTo( 0, .5 );
//        graphics.cubicTo( new Point(.2, .7), new Point(.4, .3), new Point(.6, .5) );
        graphics.quadraticTo( new Point(.25, .75), new Point(.5, .5) );
        graphics.lineTo( .5, 0 );
        graphics.lineTo( 0, 0 );
        */
        graphics.endFill();
    }

    public function _render_cache( r:IRenderer ) {
        if( !cached ) {
            for( i in 62...128 ) {
                var g:Glyph = font.getGlyph(i);
                if( g != null ) {
                    g._cache(r);
                }
                cached = true;
            }
        }
        super._render_cache(r);
    }
    
    private function _render( r:IRenderer ) {
        super._render(r);
        
        r.pushMatrix();
        r.matrix( transform.matrix );
        
        r.translate(15,200);
        
        //graphics._render(r);
        
        r.pushMatrix();
        for( i in 65...91 ) {
            var g = font.getGlyph(i);
            if( g != null ) {
                g._render(r);
            }
        }
        r.popMatrix();

        r.pushMatrix();
        r.translate( 0,30 );
        for( i in 97...123 ) {
            var g = font.getGlyph(i);
            if( g != null ) {
                g._render(r);
            }
        }
        r.popMatrix();

        r.popMatrix();
    }
}
