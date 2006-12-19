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

package xinf.inity.http;

class URL {
    public var protocol:String;
    public var host:String;
    public var port:Int;
    public var path:String;
    // fragments (#foo) and GET parameters (?foo=bar) are just part of the path (for now)
    
    public function new( s:String ) :Void {
        parse(s);
    }
    
    private function parse( s:String ) :Void {
        var r:EReg = ~/([a-z]+):\/\/([a-z\.]+)(:([0-9]+))?(.*)/;
        if( r.match( s ) ) {
            protocol = r.matched(1);
            host = r.matched(2);
            port = Std.parseInt(r.matched(4));
            if( port==0 ) {
                switch(protocol) {
                    case "http": port=80;
                    case "https": port=443;
                    case "ftp": port=21;
                    default: port=0;
                }
            }
            path = r.matched(5);
        } else {
            throw("Not a URL: "+s );
        }
    }
    
    public function toString() :String {
        return( protocol+"://"+host+":"+port+path );
    }
}
