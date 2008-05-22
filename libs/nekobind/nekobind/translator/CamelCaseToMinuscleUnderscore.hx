/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package nekobind.translator;

class CamelCaseToMinuscleUnderscore extends Translator {
	public function new() :Void {
		// this constructor is needed!
		super();
	}
	public function translate( src:String ) :String {
		var dst = new StringBuf();
		var l = src.toLowerCase();
		var lastWasCapital:Bool = false;
		for( i in 0...src.length ) {
			var c = src.charAt(i);
			if( l.charAt(i) != c ) {
				if( !lastWasCapital )
					dst.add("_");
				dst.add( l.charAt(i) );
				lastWasCapital=true;
			} else {
				dst.add(c);
				lastWasCapital=false;
			}
		}
		return dst.toString();
	}
}
