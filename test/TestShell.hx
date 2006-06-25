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

import TestLogger;
import TestCase;

class TestShell {
    public static var mTests = [
        tests.primitives.Pane,
        tests.primitives.Text,
        tests.primitives.Image,
        tests.xinful.Scrollbar,
        tests.xinful.Listbox,
        tests.xinful.Dropdown,
        tests.xinful.Skin
    ];    
    
    public static var nTest:Int;
    public static var cTest:TestCase;
    public static var testName:String;
    public static var testFeedback:Bool;

    public static function main() :Void {
        testName = null;
        testFeedback = null;


        var root = xinf.ony.Root.getRoot();
        xinf.event.EventDispatcher.addGlobalEventListener( xinf.event.Event.ENTER_FRAME, testStep);
        
        #if neko
            testName="";
            var t = untyped __dollar__loader.args[0];
            if( t == null ) {
                testName=null;
                runNextTest();
                testFeedback=true;
            } else
               untyped testName.__s = t;
        #else js
            // find initialization params
            var test:String = js.Lib.window.location.search;
            if( test.length>0 ) {
                test = test.substr(1,test.length-1).split(":")[0];

                // set the test name for js          
                testName = test;
                
                // set the test name for flash
                var embed = js.Lib.document.getElementById("swfEmbed");
                if( embed != null ) {
                    untyped embed.SetVariable("runTest",test);
                }
            } else {
                testName = "tests.primitives.Pane";
                testFeedback=true;
            }
        
            // produce test dropdown box
            var select = js.Lib.document.getElementById("newTest");
            if( select != null ) {
                for( testClass in mTests ) {
                    var test = untyped testClass.__name__.join(".");
                    var o = js.Lib.document.createElement("option");
                    o.appendChild( untyped js.Lib.document.createTextNode( test ) );
                    if( test == testName ) o.setAttribute("selected","true");
                    select.appendChild(o);
                }
                untyped select.onchange = function(e:Dynamic) {
                    var test = js.Lib.document.getElementById("newTest").value;
                    js.Lib.document.location="?"+test;
                }
                
                untyped select.focus();
            }
            
            if( js.Lib.document.getElementById("FlashVersion") != null ) {
                js.Lib.document.getElementById("FlashVersion").innerHTML = 
                    untyped navigator.plugins["Shockwave Flash"].description;
                js.Lib.document.getElementById("JSVersion").innerHTML = 
                    untyped navigator.appName + " " + untyped navigator.appVersion;
            }                    
        #end

        xinf.ony.Root.getRoot().run();
    }

    public static function runNextTest() :Void {
        if( nTest == null ) nTest=0;
        else nTest++;
        
        if( nTest >= mTests.length ) {
            trace("Tests Finished.");
            if( TestCase.logger != null ) {
                TestCase.logger.finished( finished );
            }
            #if neko
                xinf.event.EventDispatcher.postGlobalEvent( xinf.event.Event.QUIT, null );
            #end
        } else {
            testName = untyped mTests[nTest].__name__.join(".");
            trace("next: "+testName );
        }
    }
    
    public static function finished() :Void {
        #if js
            js.Lib.window.close();
        #else flash
            flash.Lib.fscommand("quit", "" );
        #end
    }
    
    public static function testStep( e:xinf.event.Event ) :Void {
        var nextTest:String = null;
        
        #if flash
            if( untyped flash.Lib._root.runTest != null ) {
                nextTest = untyped flash.Lib._root.runTest;
                untyped flash.Lib._root.runTest = null;
            }
            if( untyped flash.Lib._root.testFeedback != null ) {
                testFeedback = untyped flash.Lib._root.testFeedback;
                TestCase.logger = if( testFeedback ) new TestServerConnection(); else null;
            }
        #else true
            TestCase.logger = if( testFeedback ) new TestServerConnection(); else null;
        #end
        
        if( testName != null ) {
            nextTest = testName;
            testName = null;
        }
        
        if( nextTest != null ) {
            if( cTest != null ) {
                cTest.destroy();
                cTest = null;
            }
            
            for( testClass in mTests ) {
                var t = untyped testClass.__name__.join(".");
                if( nextTest == t ) {
//                    trace("Run test "+nextTest+", log to "+TestCase.logger );
                    cTest = Reflect.createInstance( testClass, [ xinf.ony.Root.getRoot() ] );
                }
            }
            testName = null;
        }
    }
}
