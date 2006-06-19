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
        var URL = "http://localhost:2000/collect/Collector.n";
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
            cnx.Collector.result.call([ testName, testNumber++, true, targetEquality, runtime ], replyReceived );
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

import org.xinf.ony.Element;

class TestCase extends org.xinf.ony.Pane {
    static var server = new TestServerConnection();
    
    private var description:String;
    private var targetEquality:Float;
    
    public function new( parent:Element, _name:String, _desc:String, _targetEquality:Float ) :Void {
        super( _name, parent );
        description=_desc;
        targetEquality = _targetEquality;
    }
    
    public function screenshotFrame1() :Void {
        var shoot:Dynamic;
        var self = this;
        shoot = function (e:org.xinf.event.Event) {
            TestCase.server.screenshot(self.name,self.targetEquality);
            org.xinf.event.EventDispatcher.removeGlobalEventListener( org.xinf.event.Event.ENTER_FRAME, shoot );
        };
        org.xinf.event.EventDispatcher.addGlobalEventListener( org.xinf.event.Event.ENTER_FRAME, shoot );
    }
    
    public static function main() :Void {
        trace("TestCase main");
    }
}
