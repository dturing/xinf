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

import xinf.value.Value;
import xinf.ul.layout.ComponentValue;
import xinf.ul.layout.HorizontalBox;

class Test extends Label {
    
    public function new( t:String ) :Void {
        super( t );
        addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
        addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
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
                padding: { l:5, t:5, r:5, b:3 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,.5),
                background: Color.rgba(1,1,1,.3),
            });
            
        xinf.style.StyleSheet.defaultSheet.add(
            [ "Grid" ], {
                padding: { l:5, t:5, r:5, b:3 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,.5),
                background: Color.rgba(1,0,0,.5),
            });
        xinf.style.StyleSheet.defaultSheet.add(
            [ "CompactGrid" ], {
                padding: { l:5, t:5, r:5, b:3 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,.5),
                background: Color.rgba(0,1,0,.5),
            });
        xinf.style.StyleSheet.defaultSheet.add(
            [ "base" ], {
                padding: { l:5, t:5, r:5, b:3 },
                border: { l:1, t:1, r:1, b:1 },
                color: Color.rgba(1,1,1,0),
                background: Color.rgba(1,0,0,.5),
            });
        xinf.style.StyleSheet.defaultSheet.add(
            [ ":over" ], {
                padding: { l:5, t:5, r:5, b:3 },
                color: Color.rgba(1,1,1,1),
                background: Color.rgba(1,1,1,.4),
            });
            
/*
        var xPadding = Value.constant(5);
        var yPadding = Value.constant(5);

        var c3 = new Pane();
        c3.moveTo( 20, 20 );
        c3.resize( 30, 30 );
        c3.addStyleClass("base");
        var x:Value = xPadding;
        var y:Value = yPadding;
        for( t in ["one","two","three"] ) { //,"four","five","six","seven","eight","nine","ten"] ) {
            var p = new Test(t);
            p.constraints.setX( x );
            p.constraints.setY( y );
//            trace("Test("+t+").constraints: "+p.constraints);
            x = Value.sum( xPadding, p.constraints.getEast() );
            y = Value.sum( yPadding, p.constraints.getSouth() );
            c3.attach(p);
        }
        c3.constraints.setWidth( x );
        c3.constraints.setHeight( y );
        trace("base constraints: "+c3.constraints );
        root.attach(c3);
*/
        var c = new HorizontalBox();
        c.resize( 10, 2 );
        c.addStyleClass("base");
        var align=0.;
        for( t in ["one","two","three"] ) { //,"four","five","six","seven","eight","nine","ten"] ) {
            var p = new Test(t);
            c.add(p,align);
            align+=.5;
        }
        c.moveTo( 20, 20 );
        root.attach(c);
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
