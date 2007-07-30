/* 
   nekobind - nekovm-C binding generator
   Copyright (c) 2006, Daniel Fischer.
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

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
