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

import xinf.event.MouseEvent;
import xinf.erno.Color;
import xinf.ony.Application;
import xinf.ul.Pane;
import xinf.ul.Label;

import xinf.ul.layout.SpringLayout;
import xinf.ul.layout.Constraints;
import xinf.ul.layout.Spring;
import xinf.ul.layout.SpringUtilities;

class Test extends Label {
    
    public function new( t:String ) :Void {
        super( t );
        text = _id+" "+text;
    }
    
}

class App extends Application {
    
    public function new() :Void {
        super();
        xinf.style.StyleSheet.defaultSheet.add(
            [ "Test" ], {
                padding: { l:0, t:0, r:0, b:0 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,.5),
                background: Color.rgba(1,0,0,.5),
            } );
        
        var c = new Test("base");
        c.resize(100,100);
        c.moveTo(10,10);
        
        var p1 = new Test("one");
        //p1.resize(70,20);

        var p2 = new Test("twoonetwo");
        //p2.resize(50,50);
/*
        for( t in ["two","three","four","five","six","seven","eight","nine"] ) {
            var p = new Test(t);
            p.resize(20,15);
            c.attach(p);
        }
*/
        var l = new SpringLayout();
        
        var pad = Spring.constant(15);
        l.putConstraint( West, p1, pad, West, c );
        l.putConstraint( North, p1, pad, North, c );
        l.putConstraint( West, p2, pad, East, p1 );
        l.putConstraint( North, p2, pad, South, p1 );
        l.putConstraint( East, c, pad, East, p2 );
        l.putConstraint( South, c, pad, South, p2 );
        
        l.getConstraints( p1 ).setWidth( 
            Spring.max(
                new WidthSpring(p1),
                l.getConstraints( p2 ).getWidth()
            ) );
        
        //SpringUtilities.makeCompactGrid( c, l, 3, 3, 5, 20, 5, 5 );
            
        c.attach(p2);
        c.attach(p1);
        l.layoutContainer( c );
        root.attach(c);
    }
    
    public static function main() :Void {
        try {
            new App().run();
        } catch( e:Dynamic ) {
            try {
                trace("Exception: "+e+"\n"+haxe.Stack.toString(haxe.Stack.exceptionStack()) );
            } catch( f:Dynamic ) {
                trace("Exception tracing exception: "+e+" /// "+f );
            }
        }
    }
}
