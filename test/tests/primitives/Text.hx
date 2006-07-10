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
import xinf.ony.ScrollEvent;

class Text extends TestCase {
    var children:List<xinf.ony.Text>;
    var last:xinf.ony.Text;
    
    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, .999 );
        var testElement:xinf.ony.Text;
        children = new List<xinf.ony.Text>();
        
        var y:Float=0;
        
        for( i in 0...4 ) {
            testElement = new xinf.ony.Text( "test", this );
            testElement.setForegroundColor( new xinf.ony.Color().fromRGBInt( 0 ) );
            testElement.bounds.setPosition( 10, 10+y );
            testElement.setFontSize( 11 + (i*4) );
            testElement.text = "the quick brown fox\njumps over the lazy dog\n";
            
            y+=testElement.bounds.height;
            children.push(testElement);
        }

        testElement = new xinf.ony.Text( "test", this );
        testElement.setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0 ) );
        testElement.setForegroundColor( new xinf.ony.Color().fromRGBInt( 0xffffff ) );
        testElement.bounds.setPosition( 10, 10+y );
        testElement.setFontSize( 11 + (3*4) );
        testElement.text = "the quick brown fox\njumps over the lazy dog";
        last = testElement;
        
        var t = new xinf.ony.Text("glyph", this );
        t.setForegroundColor( new xinf.ony.Color().fromRGBInt( 0x0000ff ) );
        t.bounds.setPosition( 220, -20 );
        t.setFontSize( 128 );
        t.text = "a";
        
        var sb = new xinf.ul.VScrollbar("param", this );
        sb.bounds.setPosition( 310, 0 );
        sb.addEventListener( ScrollEvent.SCROLL_TO, changeParam );

        screenshotFrame1();
    }
    
    public function changeParam( e:ScrollEvent ) :Void {
        var factor = .8+(e.value/2.5);
        var i = 0;
        for( child in children ) {
            var sz = Math.round( (10+((3-i)*4)) * factor * 100)/100;
            child.text = "Hamburgefons "+sz;
            child.setFontSize( sz );
            i++;
        }
        last.text = ""+Math.round(factor*100)+"%";
    }
}
