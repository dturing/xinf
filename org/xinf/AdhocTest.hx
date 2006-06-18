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

package org.xinf;

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

import org.xinf.ul.ListModel;
import org.xinf.ony.Color;

class Foo extends org.xinf.ony.Text {
    public function new( name:String, parent:org.xinf.ony.Element ) {
        super( name, parent );
        text = "Hello,\nWorld.";
        autoSize = false;
        
        for( event in [ Event.MOUSE_DOWN, Event.MOUSE_UP,
                        Event.MOUSE_OVER, Event.MOUSE_OUT ] ) {
            addEventListener( event, handleEvent );
        }
    }
    
    public function handleEvent( e:Event ) : Void {
        trace( name+": "+e.type );
        var t:String = name+"\n"+e.type+"\n";
        text = t;
    }
    
}

/**
    Informal xinf Test (used during development).
**/
class AdhocTest {
    static var container:org.xinf.ony.Element;
    
    static function main() {
        
        var root = org.xinf.ony.Root.getRoot();

        var cbg = new org.xinf.ony.Color();
        cbg.fromRGBInt( 0xeeeeee );
        
        var cont = new org.xinf.ony.Pane("container", root);
        cont.setBackgroundColor( cbg );
        cont.bounds.setPosition( 10, 10 );
        cont.bounds.setSize( 300, 200 );
        container = cont;

/* listbox test
        var model = new SimpleListModel();
        for( i in 0...50 ) {
            model.addItem( "ListItem "+i );
        }
        
        var list = new org.xinf.ul.ListBox("listTest", cont, model );
        list.bounds.setSize( 100, 200 );
*/

/* crop test
        var a = new Foo( "crop1", cont );
        a.bounds.setPosition( 120, 25 );
        a.bounds.setSize( 150, 150 );
        a.crop = true;
        a.setBackgroundColor( new Color().fromRGBInt( 0xffaaaa ) );

        var b = new Foo( "tooBig1", a );
        b.bounds.setPosition( -50, -50 );
        b.bounds.setSize( 250, 150 );
        b.setBackgroundColor( new Color().fromRGBInt( 0xaaffaa ) );

        var c = new Foo( "crop2", b );
        c.crop = true;
        c.bounds.setPosition( 75, 75 );
        c.bounds.setSize( 100, 100 );
        c.setBackgroundColor( new Color().fromRGBInt( 0xaaaaff ) );

        var d = new Foo( "tooBig2", c );
        d.bounds.setPosition( -25, -25 );
        d.bounds.setSize( 150, 50 );
        d.setBackgroundColor( new Color().fromRGBInt( 0xffffaa ) );

        var e = new Foo( "tooBig_fail", a );
        e.bounds.setPosition( -25, -25 );
        e.bounds.setSize( 200, 45 );
        e.setBackgroundColor( new Color().fromRGBInt( 0xff0000 ) );
*/

/* labels
        var bg = new org.xinf.ony.Color();
        bg.fromRGBInt( 0x336699 );
        var fg = new org.xinf.ony.Color();
        fg.fromRGBInt( 0xffffff );
        
            for( i in 0...10 ) {
                var box = new org.xinf.ul.Label("label"+i, cont);
                box.bounds.setPosition( 10, i*40 );
                box.text = "Hello "+i;
                list.addChild( box );
            }

        var slider = new org.xinf.ul.VScrollbar( "test", cont );
*/


/* images test */

        var p2 = new org.xinf.ony.Pane("testPane", cont );
        p2.setBackgroundColor( new Color().fromRGBInt( 0x333388 ) );
        p2.bounds.setSize( 340, 260 );
        p2.bounds.setPosition( 10, 10 );

        var i = new org.xinf.ony.Image("testImg",p2,"assets/test.jpg");
            i.bounds.setPosition( 10, 10 );
        var i3 = new org.xinf.ony.Image("testImg3",p2,"assets/test.png");
        i3.bounds.setPosition( 120, 10 );
 
        
/* decorator test, simulate a button */
/*
        var deco = new org.xinf.ul.Decorator("deco",cont);
        var test = new org.xinf.ony.Text("test button text", deco );
        deco.setChild( test );
        test.text = "Hello";
        deco.bounds.setPosition(20,20);
*/
//        GL.BindTexture( GL.TEXTURE_2D, 1 );
//        GL.BindTexture( GL.TEXTURE_2D, 5 );

        var frame:Int = 0;
        org.xinf.event.EventDispatcher.addGlobalEventListener( Event.ENTER_FRAME, function (e:Event) {
//            trace("enter_frame");
//            untyped org.xinf.ony.Root.getRoot()._p.changed();
            frame++;
           //  i2.bounds.setSize( Math.sin(frame/25)*100, Math.sin(frame/25)*100 );
        } );

        org.xinf.ony.Root.getRoot().run();
    }
}
