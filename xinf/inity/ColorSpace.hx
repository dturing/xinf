/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.inity;

enum ColorSpace {
	RGB;
	RGBA;
	BGR;
	BGRA;
	GRAY;
	ALPHA;
	Other(depth:Int,channels:Int);
}

class ColorSpaceTools {
	
	public static function defaultBytesPerRow( cs:ColorSpace, width:Int ) :Int {
		return
			switch( cs ) {
				case RGB,BGR:
					width*3;
				case RGBA,BGRA:
					width*4;
				case GRAY,ALPHA:
					width;
				case Other(d,c):
					return (d*Math.ceil(c/8)*width);
			}
	}
	
}
