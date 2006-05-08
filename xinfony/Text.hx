package xinfony;

class Text extends Element {
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
                "theTextField", _clip.getNextHighestDepth(), 0, 0, 100, 100 );
            
            _textField = _e.theTextField;
            _textField.autoSize = true;
            _textField.background = true;
        #else js
//            _e.style.border = "1px solid #000000";
        #end
        }
    }
    
    #if neko
    private function createPrimitive() : xinfinity.graphics.Object {
        return new xinfinity.graphics.Text();
    }
    #end

    public function applyStyle( style:xinfony.style.Style ) {
        #if flash
            _textField.textColor = style.color.toInt();
            _textField.backgroundColor = style.background.toInt();
            _textField.border = ( style.border.thickness.px() > 0 );
            _textField.borderColor = style.border.color.toInt();
        #else js
            _e.style.color = style.color.toString();
            _e.style.background = style.background.toString();
            _e.style.border = style.border.toString();
        #else neko
            _e.style = style;
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
