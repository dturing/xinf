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

import neko.net.Host;
import neko.net.Socket;

class HttpRequest {
    var socket:Socket;
    public function new() :Void {
    }
    
    public function request( url:URL ) :{ code:Int, headers:Hash<String>, data:String } {
        socket = new Socket();
        socket.setTimeout(60);
        
        socket.connect( new Host(url.host), url.port );
        socket.output.write("GET "+url.path+" HTTP/1.0\r\n\r\n" );
        
        var input = socket.input;
        var response = input.readLine();
        var r = response.split(" ");
        var code = Std.parseInt( r[1] );
        
        var headers = new Hash<String>();
        var line:String;
        while( (line=input.readLine()) != "" ) {
            var l = line.split(": ");
            if( l.length < 2 ) throw("invalid server reply header: "+line );
            headers.set( l[0], l[1] );
        }
        
        var data:String = input.readAll();
        return( { code:code, headers:headers, data:data } );
    }
}
