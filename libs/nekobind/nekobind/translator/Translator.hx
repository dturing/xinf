/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package nekobind.translator;

import nekobind.translator.CamelCaseToMinuscleUnderscore;
import nekobind.translator.Capitalize;

class Translator {
	public function new() :Void {
	}
	
	public function translate( src:String ) :String {
		return src;
	}
	
	public static function getTranslator( name:String ) :Translator {
		var r:Translator;
		try {
			var c = Type.resolveClass( "nekobind.translator."+name );
			r = Type.createInstance( c, [ ] );
		} catch( e:Dynamic ) {
			throw("// WARNING: cannot instantiate translator '"+name+"': "+e);
		}
		if( r==null ) r = new Translator();
		return r;
	}
}
