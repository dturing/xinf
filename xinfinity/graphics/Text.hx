package xinfinity.graphics;

import xinfinity.font.Font;
import xinf.geom.Point;

class Text extends Box {
    // FIXME this loads the font for each text item, eeew!
    private static var _font:Font = new FontReader("/home/dan/.fonts/vera.ttf").getFont();

    public property text( _getText, _setText ) : String;
    private var _text:String;
    public property length( _getLength, null ) : Int;
    public var fontSize:Float;

    public function new() {
        super();
        _text = "";
        fontSize = 12;
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
    
    public function getTextExtends() : Point {
        var w:Float = .0;
        var maxW:Float = .0;
        var lines:Int = 1;
        for( i in 0..._text.length ) {
            var c = _text.charCodeAt(i);
            if( c == 10 ) { // \n
                lines++;
                if( w > maxW ) maxW = w;
                w = .0;
            } else {
                var g = _font.getGlyph(c);
                if( g != null ) {
                    w += g.advance * fontSize;
                }
            }
        }
        if( w > maxW ) maxW = w;
        return( new Point( maxW, (_font.height * fontSize * lines) ) );
    }
    
    private function _renderGraphics() :Void {
        var lines:Int = 0;

        super._renderGraphics();
        
    // text
        GL.PushMatrix();
        var c = style.color;
        GL.Color4f( c.r/0xff, c.g/0xff, c.b/0xff, c.a/0xff );

        var b = style.border.thickness.px();
        GL.Translatef( style.padding.left.px() + b, 
                       style.padding.top.px() + b, .0 );

        GL.Scalef( fontSize, fontSize, 1.0 );
        GL.Translatef( .0, _font.ascender, .0 );
        
        GL.PushMatrix();
        
        for( i in 0..._text.length ) {
            var c = _text.charCodeAt(i);
            if( c == 10 ) { // \n
                GL.PopMatrix();
                GL.PushMatrix();
                lines++;
                GL.Translatef( .0, _font.height*lines, .0 );
            } else {
                var g = _font.getGlyph(c);
                if( g != null ) {
                    g.render();
                }
            }
        }

        GL.PopMatrix();
        
        GL.PopMatrix();
    }
}
