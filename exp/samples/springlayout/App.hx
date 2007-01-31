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

import xinf.erno.Runtime;
import xinf.event.FrameEvent;

class Test extends Label {
    public function new( t:String ) :Void {
        super( t );
        addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
        addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
    }

    override public function moveTo( x:Float, y:Float ) :Void {
        super.moveTo(x,y);
    }
    override public function drawContents( g:xinf.erno.Renderer ) :Void {
        super.drawContents( g );
    }
    
    public function onMouseOver( e:MouseEvent ) {
        text+="::over";
        addStyleClass(":over");
    }
    public function onMouseOut( e:MouseEvent ) {
        text=text.split("::")[0];
        removeStyleClass(":over");
    }
    public function onMouseDown( e:MouseEvent ) {
        text+="\npressed";
    }
    public function toString() :String {
        return( "\""+text+"\""  );
    }
}

class App extends Application {
    
    public function new() :Void {
        super();

        xinf.style.StyleSheet.defaultSheet.add(
            [ "Test" ], {
                padding: { l:5, t:5, r:5, b:5 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,.5),
                background: Color.rgba(1,1,1,.3),
            });
            
        xinf.style.StyleSheet.defaultSheet.add(
            [ "Grid" ], {
                padding: { l:5, t:5, r:5, b:5 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,.5),
                background: Color.rgba(1,0,0,.5),
            });
        xinf.style.StyleSheet.defaultSheet.add(
            [ "CompactGrid" ], {
                padding: { l:5, t:5, r:5, b:5 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,.5),
                background: Color.rgba(0,1,0,.5),
            });
        xinf.style.StyleSheet.defaultSheet.add(
            [ "base" ], {
                padding: { l:5, t:5, r:5, b:5 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,0),
                background: Color.rgba(1,0,0,.5),
            });
        xinf.style.StyleSheet.defaultSheet.add(
            [ ":over" ], {
                padding: { l:5, t:5, r:5, b:5 },
                color: Color.rgba(1,1,1,1),
                background: Color.rgba(1,1,1,.4),
            });
            
        var c = new Pane();
        c.addStyleClass("base");
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
        c.layout = l;
        
        var pad = Spring.constant(1);
        l.putConstraint( West, p1, pad, West, c );
        l.putConstraint( North, p1, pad, North, c );
        l.putConstraint( West, p2, pad, East, p1 );
        l.putConstraint( North, p2, pad, South, p1 );
        l.putConstraint( East, c, pad, East, p2 );
        l.putConstraint( South, c, pad, South, p2 );

        /*
        l.getConstraints( p1 ).setWidth( 
            Spring.max(
                new WidthSpring(p1),
                l.getConstraints( p2 ).getWidth()
            ) );
        */
        //SpringUtilities.makeCompactGrid( c, l, 3, 3, 5, 20, 5, 5 );
            
        c.attach(p2);
        c.attach(p1);
        
        root.attach(c);

        
        #if debug
            xinf.erno.Runtime.addEventListener( xinf.event.FrameEvent.ENTER_FRAME, function( e ) {
                    xinf.value.Value.dumpCounter();
                } );
        #end
    }
    
    public static function main() :Void {
        try {
            new App().run();
        } catch( e:Dynamic ) {
            try {
                var stack = haxe.Stack.exceptionStack();
                var s = if( stack != null ) {
                            haxe.Stack.toString(stack);
                        } else "[could not get stack]";
                trace("Exception: "+e+"\n"+s );
            } catch( f:Dynamic ) {
                trace("Exception tracing exception: "+e+" /// "+f );
            }
        }
    }
}
