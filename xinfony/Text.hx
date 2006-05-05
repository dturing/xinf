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
            _clip.createTextField( 
                "theTextField", _clip.getNextHighestDepth(), 0, 0, 100, 100 );
            
            _textField = _clip.theTextField;
            _textField.autoSize = true;
            _textField.background = true;
        #else js
            _div.style.border = "1px solid #000000";
//            _div.style.textAlign = "center";
//            _div.style.verticalAlign = "middle";
        #end
        }
    }

    public function applyStyle( style:Style ) {
        #if flash
            _textField.textColor = Colors.toInt( style.color );
            _textField.backgroundColor = Colors.toInt( style.backgroundColor );
            _textField.border = ( style.border > 0 );
            _textField.borderColor = Colors.toInt(style.borderColor);
        #else js
            _div.style.color = Colors.toString(style.color);
            _div.style.background = Colors.toString(style.backgroundColor);
            _div.style.border = style.border+"px solid "+Colors.toString(style.borderColor);
        #end
    }
    
    private function setText( t:String ) :String {
        _text = t;
        #if flash
            untyped _textField.text = _text;
        #else js
            untyped _div.innerHTML = _text.split("\n").join("<br/>");
        #end
        return _text;
    }
    private function getText() :String {
        return _text;
    }
}
