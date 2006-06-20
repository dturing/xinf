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

class TestShell {
    public static var mTests = [
        tests.primitives.Pane,
        tests.primitives.Text
    ];    
    
    public static var nTest:Int;
    public static var cTest:TestCase;
    public static var testName:String;
    public static var testFeedback:Bool;

    public static function main() :Void {
        testName = null;
        testFeedback = null;
        
        #if neko
           testName="";
           var t = untyped __dollar__loader.args[0];
           untyped testName.__s = t;
           trace("test: "+testName );
        #else js
            // find initialization params
            var test:String = js.Lib.window.location.search;
            if( test.length>0 ) {
                test = test.substr(1,test.length-1);

                // set the test name for js          
                testName = test;
                
                // set the test name for flash
                var embed = js.Lib.document.getElementById("swfEmbed");
                if( embed != null ) {
                    untyped embed.SetVariable("runTest",test);
                }
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
        
        var root = org.xinf.ony.Root.getRoot();
        org.xinf.event.EventDispatcher.addGlobalEventListener( org.xinf.event.Event.ENTER_FRAME, testStep);
        org.xinf.ony.Root.getRoot().run();
    }

    public static function testStep( e:org.xinf.event.Event ) :Void {
        var nextTest:String = null;
        
        #if flash
            if( untyped flash.Lib._root.runTest != null ) {
                nextTest = untyped flash.Lib._root.runTest;
                untyped flash.Lib._root.runTest = null;
            }
            if( untyped flash.Lib._root.testFeedback != null ) {
                testFeedback = true;
            }
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
                    trace("Run test "+nextTest );
                    cTest = Reflect.createInstance( testClass, [ org.xinf.ony.Root.getRoot() ] );
                }
            }
            testName = null;
        }
    }
}
