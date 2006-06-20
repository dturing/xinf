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


import org.xinf.ony.Element;

class TestCase extends org.xinf.ony.Pane {
    public static var logger:TestLogger;
    
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
        var frame:Int=0;
        shoot = function (e:org.xinf.event.Event) {
            if( frame++ == 1 ) {
                if( logger != null ) logger.screenshot(self,self.targetEquality,TestShell.runNextTest);
                org.xinf.event.EventDispatcher.removeGlobalEventListener( org.xinf.event.Event.ENTER_FRAME, shoot );
            }
        };
        org.xinf.event.EventDispatcher.addGlobalEventListener( org.xinf.event.Event.ENTER_FRAME, shoot );
    }
}
