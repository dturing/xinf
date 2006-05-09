package xinfony;

import xinf.geom.Point;

class Text extends Box {
    public property text( getText, setText ) :String;
    private var _text:String;
    
    public property autoSize( default, default ) :Bool;
    
    #if flash
        private var _textField:flash.TextField;
    #end
    
    public function new( name:String ) {
        super(name);
        autoSize = true;
        
        untyped {
        #if flash
            _e.createTextField( 
                "theTextField", _e.getNextHighestDepth(), 0, 0, 100, 100 );
            
            _textField = _e.theTextField;
            _textField.autoSize = true;
            
            var format:flash.TextFormat = new flash.TextFormat();
            format.size = 12;
            format.font = "Bitstream Vera Sans";
            _textField.setNewTextFormat( format );
        #else js
            _e.style.cursor="default";
            _e.style.overflow="hidden";
        #end
        }
    }
    
    #if neko
    private function createPrimitive() : xinfinity.graphics.Object {
        return new xinfinity.graphics.Text();
    }
    #end

    public function styleChanged() {
        if( autoSize ) calcSize();
    
        super.styleChanged();
        #if flash
            var b:Float = style.border.thickness.px();
            _textField._x = style.padding.left.px() + b -2;
            _textField._y = style.padding.top.px() + b -1;
            _textField.textColor = style.color.toInt();
        #else js
            if( autoSize ) {
                _e.style.width = null;
                _e.style.height = null;
            }
        #end
    }
    
    private function setText( t:String ) :String {
        _text = t;
        #if flash
            untyped _textField.text = _text;
        #else js
            untyped _e.innerHTML = _text.split("\n").join("<br/>");
        #else neko
            cast(_e,xinfinity.graphics.Text).text = _text;
        #end
        if( autoSize ) calcSize();
        return _text;
    }
    private function getText() :String {
        return _text;
    }
    
    private function calcSize() :Void {
        #if neko
            var s:Point = cast(_e,xinfinity.graphics.Text).getTextExtends();
            style.width = Math.round(s.x);
            style.height = Math.round(s.y);
        #else flash
            style.width = _textField._width-3;
            style.height = _textField._height-3;
        #end
    }
}
