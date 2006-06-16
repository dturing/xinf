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

import neko.Socket;

class TestServer {
    public static var port:Int = 33000;
    
    private var lastTestNr:Int;
    private var testName:String;
    private var testStatusOK:Int;
    private var testStatusFAIL:Int;
    private var testShots:Int;
    
    public function testCall( msg:String ) :Void {
        trace("testCall: "+msg );
    }
    
    public static function main() :Void {
        var server = new TestServer();
        server.run();
    }
    
    public function new() :Void {
        lastTestNr = 0;
        testStatusOK = testStatusFAIL = testShots = 0;
    }
    
    public function run() :Void {
        var host = Socket.localhost();
        
        trace("Running xinf xtest server on "+host+":"+port );
        
        var socket:Socket = new Socket();
        socket.bind( Socket.resolve(host), port );
        socket.listen(1);
        socket = socket.accept();
        
        trace("client connected");
        
        var line:String;
        while( true ) {
            line = socket.readLine();
            if( !processResponse(line.substr(0,line.length-1)) ) 
                return;
        }
    }
    
    public function processResponse( line:String ) :Bool {
        var r = line.split("|");
        var testNr:Int;
        var name:String;
        var status:String;
        try {
            testNr = Std.parseInt( r[0] );
            name = r[1];
            status = r[2];
        } catch( e:Dynamic ) {
            throw("invalid test response: "+line+", exception "+e );
        }
        
        if( testNr > lastTestNr ) {
            finishCurrentTest();
            lastTestNr = testNr;
        }
        else if( testNr < lastTestNr ) {
            finishAll();
            return false;
        }
        
        testName = name;
        
        if( status=="OK" ) {
            testStatusOK++;
        } else if( status=="FAIL" ) {
            testStatusFAIL++;
        } else if( status=="SHOOT" ) {
            shoot();
        } else {
            throw("invalid test status: '"+status+"' in test #"+testNr+" "+testName );
        }
                
//        trace("testResponse: test #"+testNr+", '"+name+"', "+status+", "+message );

        return true;
    }

    public function shoot() :Void {
        trace("should make screenshot for test #"+lastTestNr+" "+testName );
    }
    
    public function finishCurrentTest() :Void {
        trace("test #"+lastTestNr+" "+testName+" finished: "+testStatusFAIL+" of "+(testStatusOK+testStatusFAIL)+" failed, "+testShots+" shots taken." );
        testStatusOK = testStatusFAIL = testShots = 0;
    }

    public function finishAll() :Void {
        trace("all finished");
    }
}
