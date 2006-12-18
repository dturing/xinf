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

package nekobind;

class CGlobalFinder {
    public static function find( names:Array<String>, settings:Settings ) :Hash<Int> {
        // create the C source file
        var tmpName = "_nekobind_cGlobals";
        var srcName = tmpName+".c";
        var src = neko.io.File.write( srcName, false );
        
        src.write( settings.cHeader );
        src.write( "\n\nint main() {\n");
            for( name in names ) {
                src.write("\tprintf(\""+name+"=%i\\n\", "+settings.globalFinderPrefix+name+" );\n");
            }
        src.write( "\treturn 0;\n}\n" );
        src.close();
        
        // compile
        var cmd = "cc -o "+tmpName+" "+settings.globalFinderCCFlags+" "+srcName;
        if( neko.Sys.command( cmd ) != 0 ) {
            throw("Error compiling cGlobalFinder. Command: "+cmd);
        }
        
        // run
        if( neko.Sys.command("./"+tmpName+" > "+tmpName+".values") != 0 ) {
            throw("Error running cGlobalFinder");
        }
        
        // load output
        var dst = neko.io.File.getContent( tmpName+".values" ).split("\n");
        var globals = new Hash<Int>();
        for( g in dst ) {
            var h = StringTools.trim(g).split("=");
            if( h.length==2 )
                globals.set( h[0], Std.parseInt(h[1]) );
        }
        
        // clean up
        neko.FileSystem.deleteFile( tmpName );
        neko.FileSystem.deleteFile( srcName );
        neko.FileSystem.deleteFile( tmpName+".values" );
    
        return globals;
    }
}
