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

package xinf.x11;

class XinfTest extends xinf.ony.Pane {
    var screen :Array<XForward>;
    var info :Array<xinf.ony.Text>;
    var frame :Int;

    public function new( parent:xinf.ony.Element ) :Void {
        super( "XinfTest", parent );
        
        frame = 0;
        
        setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0x0000ff ) );
        var w=320; var h=240;
        bounds.setSize( w+(w/2), h );
        
        screen = new Array<XForward>();
        info = new Array<xinf.ony.Text>();
        for( i in 0...3 ) {
            screen[i] = new XForward(":1",i,this);
            screen[i].bounds.setPosition( 0, 0 );
            screen[i].bounds.setSize( w, h );
            if( i>0 )
                screen[i].bitmap.alpha = .3;
            
            var mini = new xinf.ony.Wrapper( "mini_screen"+i, this, 
                    new xinf.inity.Bitmap( screen[i].vfb ) );
            mini.bounds.setPosition( w, i*h/4 );
            mini.bounds.setSize( w/4, h/4 );
            
            info[i] = new xinf.ony.Text( "info"+i, this );
            info[i].bounds.setPosition( w+(w/4)+5, i*h/4 );
            info[i].setTextColor( new xinf.ony.Color().fromRGBInt( 0xffffff ) );
            info[i].text = screen[i].name;
        }
        
        xinf.event.EventDispatcher.addGlobalEventListener( xinf.event.Event.ENTER_FRAME, this.onEnterFrame );
    }
    
    public function onEnterFrame( e:xinf.event.Event ) :Void {
        frame++;
        var e:Float;
        if( (frame % 25) == 0 ) {
            for( i in 1...3 ) {
                e = X.image_compare( screen[i].vfb.data, screen[0].vfb.data, 320*240 );
                e = Math.round((1.-e)*10000)/100;
                info[i].text = screen[i].name+"\n"+e+"%";
                    
            }
        }
    }

    static function main() {
        var root = xinf.ony.Root.getRoot();
        
        new XinfTest( root );
        
        root.run();
    }
}
