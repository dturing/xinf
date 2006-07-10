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


import xinf.ony.Element;

class TestCase extends xinf.ony.Pane {
    public static var logger:TestLogger;
    
    private var targetEquality:Float;
    
    public function new( parent:Element, _targetEquality:Float ) :Void {
        super( "test", parent );
        targetEquality = _targetEquality;
        bounds.setSize(320,240);
    }
    
    public function screenshotFrame1() :Void {
        var shoot:Dynamic;
        var self = this;
        shoot = function (e:xinf.ony.FrameEvent) {
            if( e.frame == 1 ) {
                if( logger != null ) logger.screenshot(self,self.targetEquality,TestShell.runNextTest);
                xinf.event.Global.removeEventListener( xinf.ony.FrameEvent.ENTER_FRAME, shoot );
            }
        };
        xinf.event.Global.addEventListener( xinf.ony.FrameEvent.ENTER_FRAME, shoot );
    }
}
