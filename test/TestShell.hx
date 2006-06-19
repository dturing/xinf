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
import tests.TestPane;

class TestShell {
    public static var mTests = [
        tests.TestPane
    ];    
    
    public static var nTest:Int;
    public static var cTest:TestCase;

    public static function main() :Void {
        var root = org.xinf.ony.Root.getRoot();

         org.xinf.event.EventDispatcher.addGlobalEventListener( org.xinf.event.Event.ENTER_FRAME, testStep);
        
        org.xinf.ony.Root.getRoot().run();
    }

    public static function testStep( e:org.xinf.event.Event ) :Void {
        if( nTest == null ) nTest=0;
        else nTest++;
        
        if( cTest != null ) {
            cTest.destroy();
            cTest = null;
        }
        
        if( nTest < mTests.length ) {
            var testClass = mTests[nTest];
            trace("Run test #"+nTest );
            cTest = Reflect.createInstance( testClass, [ org.xinf.ony.Root.getRoot() ] );
        } else if( nTest == mTests.length ) {
        
        }
    }
}
