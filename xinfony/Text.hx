package xinfony;

class Text extends Box {
    public property text( getText, setText ) :String;
    private var _text:String;
    
    #if flash
        private var _textField:flash.TextField;
    #end
    
    public function new( name:String ) {
        super(name);
        untyped {
        #if flash
            _e.createTextField( 
                "theTextField", _e.getNextHighestDepth(), 0, 0, 100, 100 );
            
            _textField = _e.theTextField;
            _textField.autoSize = true;
        #else js
            _e.style.cursor="default";
        #end
        }
    }
    
    #if neko
    private function createPrimitive() : xinfinity.graphics.Object {
        return new xinfinity.graphics.Text();
    }
    #end

    public function styleChanged() {
        super.styleChanged();
        #if flash
            var b:Float = style.border.thickness.px();
            _textField._x = style.padding.left.px() + b -2;
            _textField._y = style.padding.top.px() + b -1;
            _textField.textColor = style.color.toInt();
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
        return _text;
    }
    private function getText() :String {
        return _text;
    }
}
