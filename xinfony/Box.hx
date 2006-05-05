package xinfony;

import xinfony.Color;

class Box extends Element {
    private var bg:Color;
    private var borderColor:Color;
    private var border:Int;
    private var width:Int;
    private var height:Int;
    
    public function new( name:String ) {
        super(name);
        bg = rgb(0xff,0xff,0xff);
        borderColor = rgb(0,0,0);
        border = 1;
        width=height=10;
    }
    
    public function setBackground( c:Color ) {
        bg = c;
        draw();
    }
    public function setSize( w:Int, h:Int ) {
        width = w;
        height = h;
        draw();
    }

    private function draw() {
        #if flash
            untyped {
            _clip.beginFill( Colors.toInt(bg), 100 );
            _clip.lineStyle( border, Colors.toInt(borderColor), 100, true, "", "", "", 0 );
            _clip.moveTo( 0, 0 );
            _clip.lineTo( width, 0 );
            _clip.lineTo( width, height );
            _clip.lineTo( 0, height );
            _clip.lineTo( 0, 0 );
            _clip.endFill();
            }
        #else js
            untyped {
            _div.style.width=width-(border);
            _div.style.height=height-(border);
            _div.style.background = Colors.toString(bg);
            _div.style.border = ""+border+"px solid "+Colors.toString(borderColor);
            }
        #end
    }
}
