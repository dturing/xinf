/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.type;

enum Align {
	Min;
	Mid;
	Max;
}

enum PreserveAspectRatio {
	Defer( o:PreserveAspectRatio );
	Meet( o:PreserveAspectRatio );

	None;
	Preserve( x:Align, y:Align );
}
