package xinfony.style;

import xinfony.Color;

class Style {
    public property color(default,default):Color;
    public property backgroundColor(default,default):Color;
    public property border(default,default):Int;
    public property borderColor(default,default):Color;
    
    public function new( fg:Color, bg:Color, b:Int, bc:Color ) {
        color = fg;
        backgroundColor = bg;
        border = b;
        borderColor = bc;
    }
}
