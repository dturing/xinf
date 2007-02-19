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
import xinf.ul.Application;
import xinf.ul.Pane;
import xinf.ul.Label;
import xinf.ul.RootComponent;
import xinf.ul.Container;

import xinf.ul.layout.BorderLayout;
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
        trace("over "+this );
    }
    public function onMouseOut( e:MouseEvent ) {
        text=text.split("::")[0];
        removeStyleClass(":over");
        trace("out "+this );
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
                minWidth: 100, minHeight: 50,
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


/*        
        var l = new SpringLayout();
        c.layout = l;
        
        var p1 = new Test("one");
        var p2 = new Test("twoonetwo");

        
        var pad = Spring.constant(1);
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

        c.attach(p2);
        c.attach(p1);
 */        

        for( t in ["one","two","three","four","five","six","seven","eight","nine"] ) {
            c.attach(new Test(t));
        }

        var layout = new xinf.ul.layout.SpringLayout();
        c.layout = layout;
        SpringUtilities.makeCompactGrid( c, layout, 3, 3, 5, 5 );
            
        container.attach(c);
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
