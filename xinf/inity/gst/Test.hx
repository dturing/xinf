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

package xinf.inity.gst;

import xinf.erno.Runtime;
import xinf.ony.Root;

class Test {
    public static function main() :Void {
        Runtime.init();

        var root = new Root();
        
        var video = new Video("videotestsrc");
        video.resize(320,240);
        root.attach( video );
        
        
/*
        var i = new Image("/alpha/images/testbild/testbild2320.png");
        i.moveTo( 120, 10 );
        root.attach( i );
*/        
        Runtime.run();
    }
}
