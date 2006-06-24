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

package tests.primitives;

class Text extends TestCase {
    var testElement:xinf.ony.Text;
    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, .999 );
        
        var y:Float=0;
        
        for( i in 0...4 ) {
            testElement = new xinf.ony.Text( "test", this );
            testElement.setTextColor( new xinf.ony.Color().fromRGBInt( 0 ) );
            testElement.bounds.setPosition( 10, 10+y );
            testElement.setFontSize( 10 + (i*4) );
            testElement.text = "the quick brown fox\njumps over the lazy dog";
            y+=testElement.bounds.height;
        }

        testElement = new xinf.ony.Text( "test", this );
        testElement.setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0 ) );
        testElement.setTextColor( new xinf.ony.Color().fromRGBInt( 0xffffff ) );
        testElement.bounds.setPosition( 10, 10+y );
        testElement.setFontSize( 10 + (3*4) );
        testElement.text = "the quick brown fox\njumps over the lazy dog";
        
        var t = new xinf.ony.Text("glyph", this );
        t.setTextColor( new xinf.ony.Color().fromRGBInt( 0x0000ff ) );
        t.bounds.setPosition( 220, -20 );
        t.setFontSize( 128 );
        t.text = "a";
        screenshotFrame1();
    }
}
