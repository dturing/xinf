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

package tests.style;

class StyledElement extends TestCase {
    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

        var sq = new xinf.style.StyledElement( "testStyledElement", this );
		sq.autoSize = false;
        sq.bounds.setPosition( 10, 10 );
        sq.bounds.setSize( 90, 20 );
		
		var sq = new xinf.style.StyledElement( "testStyledElement2", this );
        sq.bounds.setPosition( 110, 10 );
		var t = new xinf.ony.Pane("testT", sq );
		t.setBackgroundColor( new xinf.ony.Color().fromRGBInt(0xaaaaff) );
		sq.setChild(t);
		t.bounds.setSize( 76, 12 );
		
		var s = "";
		var y=40;
		for( str in [ "foo", "bar", "        baz" ] ) {
			s+=" "+str;
			var sq = new xinf.style.StyledElement( "test_"+s, this );
			sq.bounds.setPosition( 10, y );
			y+=30;
			
			var t = new xinf.ony.Text("testT_"+s, sq );
			t.text = s;
			sq.setChild(t);
		}

        screenshotFrame1();
    }
}
