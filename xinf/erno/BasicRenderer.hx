/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.erno.Renderer;
import xinf.geom.Matrix;

/**
    BasicRenderer implements all functions
    of the $xinf.erno.Renderer$ interface to throw exceptions.
    It is used as a base class for other renderers (some, like JSRenderer,
    throw exceptions for functions that they cannot satisfy, like startShape()).
**/
class BasicRenderer implements Renderer {
    
    public function new() :Void {
    }
    
    private function unimplemented( ?func:String ) :Void {
        trace("unimplemented: "+func );
    }

    // erno Instruction protocol
    
    public function startNative( o:NativeContainer ) :Void {
        unimplemented("startNative");
    }
    
    public function endNative() :Void {
        unimplemented("endNative");
    }
    
    public function startObject( id:Int ) :Void {
        unimplemented("startObject");
    }
    
    public function endObject() :Void {
        unimplemented("endObject");
    }

    public function destroyObject( id:Int ) :Void {
		unimplemented("freeObject");
	}

    public function showObject( id:Int ) :Void {
        unimplemented("showObject");
    }

    public function setTransform( id:Int, x:Float, y:Float, a:Float, b:Float, c:Float, d:Float ) :Void {
        unimplemented("setTransform");
    }
    
    public function setTranslation( id:Int, x:Float, y:Float ) :Void {
        unimplemented("setTranslation");
    }
    
    public function clipRect( w:Float, h:Float ) :Void {
        unimplemented("clipRect");
    }

	public function setFill( ?paint:Paint ) :Void {
		unimplemented("setFill");
	}
    
    public function setStroke( ?paint:Paint, width:Float, ?caps:Int, ?join:Int, ?miterLimit:Float, ?dashArray:Array<Int>, ?dashOffset:Int ) :Void {
		unimplemented("setStroke");
	}
        
    public function startShape() :Void {
        unimplemented("startShape");
    }
    
    public function endShape() :Void {
        unimplemented("endShape");
    }
    
    public function startPath( x:Float, y:Float) :Void {
        unimplemented("startPath");
    }
    
    public function endPath() :Void {
        unimplemented("endPath");
    }
    
    public function close() :Void {
        unimplemented("close");
    }
    
    public function lineTo( x:Float, y:Float ) :Void {
        unimplemented("lineTo");
    }
    
    public function quadraticTo( x1:Float, y1:Float, x:Float, y:Float ) :Void {
        unimplemented("quadraticTo");
    }
    
    public function cubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float ) :Void {
        unimplemented("cubicTo");
    }

    public function arcTo( x1:Float, y1:Float, rx:Float, ry:Float, rotation:Float, largeArc:Bool, sweep:Bool, x:Float, y:Float ) :Void {
        unimplemented("arcTo");
    }

    public function rect( x:Float, y:Float, w:Float, h:Float ) :Void {
        unimplemented("rect");
    }

    public function roundedRect( x:Float, y:Float, w:Float, h:Float, rx:Float, ry:Float ) :Void {
        unimplemented("roundedRect");
    }

    public function ellipse( x:Float, y:Float, rx:Float, ry:Float ) :Void {
        unimplemented("ellipse");
    }
    
    public function text( x:Float, y:Float, text:String, format:TextFormat ) :Void {
        unimplemented("text");
    }  
    
    public function image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } ) :Void {
        unimplemented("image");
    }
    
    public function native( o:NativeObject ) :Void {
        unimplemented("native");
    }
    
}
