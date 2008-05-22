/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.magic;

enum MagicType {
	Numeric( from:Float, to:Float, ?initial:Float );
	Textual( ?initial:String );
	Switch( ?initial:Bool );
}
