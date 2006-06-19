/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

class TestMain {
    static function getTestNames() :Dynamic {
        return[ 
            { name:"TestPane" }, 
            { name:"Test2" } ];
    }

    static function main() {
    
        var test = neko.Web.getParams().get("test");
        var runtime = neko.Web.getParams().get("runtime");
    
        if( neko.Web.getClientHeader("X-Haxe-Remoting") != null ) {
            
            // remoting request: return a list of test case names
            // TODO: unused, untested.
            
            var r = new haxe.remoting.Server();
            r.addObject("TestMain",TestMain);
            r.handleRequest();
            
        } else if( test != null ) {
            if( runtime != null ) {
                var t = new haxe.Template( Std.resource(runtime+".html") );
                neko.Lib.print( t.execute( {
                    test : test
                } ) );
            } else {
                var t = new haxe.Template( Std.resource("test.html") );
                neko.Lib.print( t.execute( {
                    test : test
                } ) );
            }
        } else {
            var t = new haxe.Template( Std.resource("index.html") );
            neko.Lib.print( t.execute( {
                tests : getTestNames()
            } ) );
        }
    }
}
