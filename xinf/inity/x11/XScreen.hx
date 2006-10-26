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

import xinf.erno.Runtime;
import xinf.event.FrameEvent;

class XScreen extends xinf.ony.Image {
    private var display:Dynamic;
    private var damage:Dynamic;
    public var vfb:XBitmapData;
    private var screen:Int;

    public function new( server:String, _screen:Int ) {
        screen = _screen;
        var displayName = server+"."+screen;
        display = X.OpenDisplay(untyped displayName.__s);
        
        if( !X.IsValid(display) ) {
            throw( "Could not open X display "+displayName );
        } 
        
        if( !X.HaveDamageExtension(display) ) {
            throw( "No XDamage extension on display "+displayName );
        }
        
        damage = X.DamageCreate( display, X.RootAsDrawable(display,screen), X.DamageReportBoundingBox );
        vfb = new XBitmapData( display, screen );
        super( vfb );
        
        Runtime.addEventListener( FrameEvent.ENTER_FRAME, processEvents );
        
    }

    public function processEvents( e:FrameEvent ) :Void {
        X.Sync( display, 0 );
        X.Flush( display );

        while( X.Pending( display ) != 0 ) {
            var xev = X.NextEventVolatile(display);

           // FIXME: dont handle *all* events, although we should get only DamageNotifys
                var e = X.CastDamageEvent(xev);
                var _r = X.DamageNotifyEvent_area_get( e );
                var r = { 
                        x: X.Rectangle_x_get(_r),
                        y: X.Rectangle_y_get(_r),
                        width: X.Rectangle_width_get(_r),
                        height: X.Rectangle_height_get(_r)
                    };
               // trace("DAMAGE "+r );
                
                vfb.update( r.x, r.y, r.width, r.height );
				scheduleRedraw();

                X.DamageSubtract( display, damage, 0, 0 );
        }
    }
}
