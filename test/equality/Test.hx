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

class TestServerConnection {
    private var cnx:haxe.remoting.AsyncConnection;
    private var testNumber:Int;
    
    public function new() :Void {
        var URL = "http://localhost:2000/server/Server.n";
        cnx = haxe.remoting.AsyncConnection.urlConnect(URL);
        cnx.onError = function(err) { trace("Error : "+Std.string(err)); };        
        testNumber = 0;
    }    
    
    public function screenshot( testName:String, targetEquality:Float ) :Void {
        var runtime:String =
            #if neko
                "neko"
            #else js
                "js"
            #else flash
                "fp"
            #end
            ;
            
        try {
            cnx.Server.result.call([ testName, testNumber++, true, targetEquality, runtime ], replyReceived );
        } catch( e:Dynamic ) {
            trace("couldnt call server: "+e );
        }
    }
    
    private function replyReceived(d:Dynamic) :Void {
        var s = "{ ";
        for( field in Reflect.fields(d) ) {
            s+=field+":"+Reflect.field(d,field)+" ";
        }
        s+="}";
        trace("reply: "+s );
    }
}

class Test {
    static function main() {
        var server = new TestServerConnection();
        var root = org.xinf.ony.Root.getRoot();

        var sq = new org.xinf.ony.Pane( "testPane", root );
        sq.setBackgroundColor( new org.xinf.ony.Color().fromRGBInt( 0xff0000 ) );
        sq.bounds.setPosition( 10, 10 );
        sq.bounds.setSize( 100, 100 );


        var test:Dynamic;
        test = function (e:org.xinf.event.Event) {
            trace("frame 1: "+untyped sq._p);
            server.screenshot("basic",1.0);
            org.xinf.event.EventDispatcher.removeGlobalEventListener( org.xinf.event.Event.ENTER_FRAME, test );
        };
        org.xinf.event.EventDispatcher.addGlobalEventListener( org.xinf.event.Event.ENTER_FRAME, test );
    
        org.xinf.ony.Root.getRoot().run();
    }
}
