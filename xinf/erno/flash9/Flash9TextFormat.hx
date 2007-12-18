/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.flash9;

class Flash9TextFormat extends xinf.erno.TextFormat {
    var measure:flash.text.TextField;

    public function new( ?family:String,  ?size:Float, ?bold:Bool, ?italic:Bool ) :Void {
        super( family, size, bold, italic );
        
        var tf = new flash.text.TextField();
        tf.selectable = false;
        tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
        measure = tf;
    }
    
    override public function textSize( text:String ) :{ x:Float, y:Float } {
        assureLoaded();
        measure.defaultTextFormat = format;
        measure.text = text;
        return {x:measure.width,y:measure.height};
    }

    override public function load() :Void {
        format = new flash.text.TextFormat();
        format.font = family;
		if( format.font=="" ) format.font="_sans"; // FIXME
        format.size = size;
		if( format.size<=0 ) format.size=12; // FIXME
        format.leftMargin = 0;
    }
}
