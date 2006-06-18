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

package test;


class TestServerConnection {
    private var cnx:haxe.remoting.AsyncConnection;
    
    public function new() :Void {
        var URL = "http://localhost/~dan/xinf/server.n";
        cnx = haxe.remoting.AsyncConnection.urlConnect(URL);
        cnx.onError = function(err) { trace("Error : "+Std.string(err)); };        
    }    
    
    public function checkpoint( msg:String ) :Void {
        cnx.Server.checkpoint.call([ {message:msg} ],replyReceived);
    }
    
    private function replyReceived(d:Dynamic) :Void {
        trace("reply: "+d );
    }
}

class Test {
    static function main() {
        
        var server = new TestServerConnection();
        var root = org.xinf.ony.Root.getRoot();


        server.checkpoint("hello");


        org.xinf.ony.Root.getRoot().run();
    }
}
