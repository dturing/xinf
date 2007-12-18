/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno.js;

import js.Dom;

class JSTextFormat extends xinf.erno.TextFormat {
    static var measure:js.HtmlDom;

    override public function apply( to:js.HtmlDom ) :Void {
        to.style.fontFamily = if( family=="sans" ) "Bitstream Vera Sans, Arial, sans-serif" else family;
        to.style.fontStyle = if( italic ) "italic" else "normal";
        to.style.fontWeight = if( bold ) "bold" else "normal";
        to.style.fontSize = size;
    }


    public function new( ?family:String,  ?size:Float, ?bold:Bool, ?italic:Bool ) :Void {
        super( family, size, bold, italic );
        
		if( measure==null ) {
			measure = js.Lib.document.createElement("div");
			measure.style.position="absolute";
		    measure.style.bottom="-200";
			measure.style.background="#fff";
			js.Lib.document.body.appendChild( measure );
		}
    }
    
    
    override public function textSize( text:String ) :{ x:Float, y:Float } {
        assureLoaded();
        apply( measure ); // FIXME: move to load(), for flash also (assigning the format to measure)?
		measure.innerHTML = text.split("\n").join("<br/>");
        return {x:1.*measure.offsetWidth,y:1.*measure.offsetHeight};
    }

    override public function load() :Void {
    }
}
