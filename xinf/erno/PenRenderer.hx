/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.erno.Renderer;
import xinf.type.Paint;
import xinf.type.CapsStyle;
import xinf.type.JoinStyle;

/**
    A Pen structure keeps the style with which to draw graphic objects
    for a <a href="PenStackRenderer.html">PenStackRenderer</a>. There should
    be no need to use this structure, except if you implement
    your own Renderer that derives from PenStackRenderer.
**/
class Pen {
    /**
        current fill color, may be [null].
    **/
    public var fill :Paint;
    
	public var stroke:Paint;
	public var width:Float;
	public var caps:CapsStyle;
	public var join:JoinStyle;
	public var miterLimit:Float;
	public var dashArray:Iterable<Float>;
	public var dashOffset:Float;

    /**
        current font family, a comma-separated list of official font family names or
        "_sans" for the default sans-serif font (sth. like "Bitstream Vera Sans, Arial, _sans").
        The order of the given font families determines the priority with which to choose
        the font.
    **/
    public var fontFace:String;
    
    /**
        wether the current font should be italic
    **/
    public var fontItalic:Bool;
    
    /**
        wether the current font should be bold
    **/
    public var fontBold:Bool;

    /**
        the current font size, in units of the current coordinate system.
    **/
    public var fontSize:Float;
    
    /**
        constructor, initializes a new Pen structure with default values.
    **/
    public function new() :Void {
        fontFace = "_sans";
        fontSize = 11.0;
        fontItalic = fontBold = false;
    }
    
    /**
        return a new Pen structure with the same properties as this Pen.
    **/
    public function clone() :Pen {
        var p = new Pen();
        
		p.fill = fill;
        
		p.stroke = stroke;
		p.width = width;
		p.caps = caps;
		p.join = join;
		p.miterLimit = miterLimit;
		p.dashArray = dashArray;
		p.dashOffset = dashOffset;
		
        p.fontFace = fontFace;
        p.fontItalic = fontItalic;
        p.fontBold = fontBold;
        p.fontSize = fontSize;
		
        return p;
    }
}


/**
    A PenStackRenderer implements the <i>style part</i> of the 
    <a href="Renderer.html">Renderer</a> interface ([setFill], [setStroke] and [setFont]),
    maintaining a stack of <a href="Pen.html">Pen</a> structures.
    <p>
        Renderers deriving from this should use [pushPen] and [popPen] at the begin
        and end of an object definition. They can access the current Pen from the [pen]
        member variable.
    </p>
**/
// FIXME: does this actually have to be a stack? i dont think so...
class PenRenderer extends BasicRenderer {
    
    private var pen:Pen;

    public function new() :Void {
        super();
        pen = new Pen();
    }
    
    /**
        the implementation of the Renderer setFill method, sets the fillColor of the
        current pen.
    **/
    override public function setFill( ?paint:Paint ) :Void {
		pen.fill = paint;
    }
    
    /**
        the implementation of the Renderer setStroke method, sets the strokeColor and
        strokeWidth of the current pen.
    **/
    override public function setStroke( ?paint:Paint, width:Float, ?caps:CapsStyle, ?join:JoinStyle, ?miterLimit:Float, ?dashArray:Iterable<Float>, ?dashOffset:Float ) :Void {
		pen.stroke = paint;
		pen.width = width;
		pen.caps = caps;
		pen.join = join;
		pen.miterLimit = miterLimit;
		pen.dashArray = dashArray;
		pen.dashOffset = dashOffset;
    }
    
    /**
        the implementation of the Renderer setFont method, sets the fontFace,
        fontSlant, fontWeight and fontSize of the current pen.
    **/
    override public function setFont( face:String, italic:Bool, bold:Bool, size:Float ) {
        pen.fontFace = face;
        pen.fontItalic = italic;
        pen.fontBold = bold;
        pen.fontSize = size;
    }
    
}
