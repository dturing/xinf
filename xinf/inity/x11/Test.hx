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

package xinf.inity.x11;

import xinf.ony.Application;

class Test extends Application {
    var screen :Array<XForward>;

	public function new() :Void {
		super();
                
        screen = new Array<XForward>();
//        info = new Array<xinf.ony.Text>();
        for( i in 0...1 ) {
            screen[i] = new XForward(":1",i);
            screen[i].moveTo( 0, 0 );
            screen[i].resize( 320, 240 );
			/*
            if( i>0 )
                screen[i].bitmap.alpha = .3;
				*/
			root.attach( screen[i] );
            
			/*
            var mini = new xinf.ony.Wrapper( "mini_screen"+i, this, 
                    new xinf.inity.Bitmap( screen[i].vfb ) );
            mini.bounds.setPosition( w, i*h/4 );
            mini.bounds.setSize( w/4, h/4 );
            
            info[i] = new xinf.ony.Text( "info"+i, this );
            info[i].bounds.setPosition( w+(w/4)+5, i*h/4 );
            info[i].setTextColor( new xinf.ony.Color().fromRGBInt( 0xffffff ) );
            info[i].text = screen[i].name;
			*/
        }
        
//        xinf.event.EventDispatcher.addGlobalEventListener( xinf.event.Event.ENTER_FRAME, this.onEnterFrame );
    }
/*    
    public function onEnterFrame( e:xinf.event.Event ) :Void {
        frame++;
        var e:Float;
        if( (frame % 25) == 0 ) {
            for( i in 1...2 ) {
                e = X.image_compare( screen[i].vfb.data, screen[0].vfb.data, 320*240 );
                e = Math.round((1.-e)*10000)/100;
                info[i].text = screen[i].name+"\n"+e+"%";
                    
            }
        }
    }
*/

	public static function main() :Void {
		new Test().run();
	}
}
