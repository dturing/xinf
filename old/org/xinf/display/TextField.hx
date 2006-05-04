package org.xinf.display;

import org.xinf.render.IRenderer;
import org.xinf.display.Font;

/*
    *minimal* TextField implementation, will only show text, in hardcoded TTF.
*/

class TextField extends InteractiveObject {
    public property text( _getText, _setText ) : String;
    private var _text:String;
    public property length( _getLength, null ) : Int;
    
    private static var _font:Font = new FontReader("/home/dan/.fonts/textra.ttf").getFont();
    
    public function new() {
        super();
        _text="";
        
        trace("Font name: "+_font.family_name );
    }
    
    private function _getLength() : Int {
        return _text.length;
    }
    
    private function _setText( t:String ) : String {
        _text = t;
        changed();
        return t;
    }

    private function _getText() : String {
        return _text;
    }
    
    public function _render_cache( r:IRenderer ) {
        if( _changed ) {
            for( i in 32...127 ) {
                var g:Glyph = _font.getGlyph(i);
                if( g != null ) {
                    g._cache(r);
                } else {
                    trace("no glyph #"+i );
                }
            }
        }        
        super._render_cache(r);
    }
    private function _render( r:IRenderer ) {
        var lines:Int = 0;
        var lineHeight:Float = _font.height * 50;
            
        r.pushMatrix();
        r.matrix( transform.matrix );
        r.setColor( 1, 1, 1, 1 );
        r.scale( 24, 24 );
        
        r.pushMatrix();
        
    //    r.translate(15,200);

        for( i in 0..._text.length ) {
            var c = _text.charCodeAt(i);
            if( c == 10 ) { // \n
                r.popMatrix();
                r.pushMatrix();
                lines++;
                r.translate( 0, lineHeight*lines );
            } else {
                var g = _font.getGlyph(c);
                if( g != null ) {
                    g._render(r);
                }
            }
        }
        
        r.popMatrix();
        r.popMatrix();
        super._render(r);
    }
}
