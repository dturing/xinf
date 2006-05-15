package org.xinf.x11;

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

class XScreen extends org.xinf.ony.Wrapper {
    private var display:Dynamic;
    private var damage:Dynamic;
    private var vfb:XBitmapData;
    private var bitmap:org.xinf.inity.Group;
    private var screen:Int;

    public function new( server:String, _screen:Int ) {
        screen = _screen;
        var displayName = server+"."+screen;
        display = X.OpenDisplay(untyped displayName.__s);
        
        if( !X.IsValid(display) ) {
            throw( "Could not open X display "+displayName );
        } 
        
        if( !X.HaveDamageExtension(display) ) {
            throw( "No XDamage extension on display "+name );
        }
        
        damage = X.DamageCreate( display, X.RootAsDrawable(display,screen), X.DamageReportBoundingBox );
        vfb = new XBitmapData( display, screen );
        bitmap = new org.xinf.inity.Bitmap( vfb );
        super( displayName, new org.xinf.ony.impl.x.XPrimitive( bitmap ) );
        
        EventDispatcher.addGlobalEventListener( Event.ENTER_FRAME, processEvents );
    }

    public function processEvents( e:Event ) :Void {
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
                bitmap.changed();

                X.DamageSubtract( display, damage, 0, 0 );
        }
    }
}
