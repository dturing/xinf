/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package nekobind.translator;

class Capitalize extends Translator {
	public function new() :Void {
		// this constructor is needed!
		super();
	}
	override public function translate( src:String ) :String {
		var dst = src.charAt(0).toUpperCase() + src.substr(1,src.length);
		return dst;
	}
}
