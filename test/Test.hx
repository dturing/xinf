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
    
}

class Test {
    static function main() {
        
        var server = new TestServerConnection();
        
        var root = org.xinf.ony.Root.getRoot();

        var cbg = new org.xinf.ony.Color();
        cbg.fromRGBInt( 0xeeeeee );
        
        var cont = new org.xinf.ony.Pane("container", root);
        cont.setBackgroundColor( cbg );
        cont.bounds.setPosition( 10, 10 );
        cont.bounds.setSize( 300, 200 );


        org.xinf.ony.Root.getRoot().run();
    }
}
