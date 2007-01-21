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

class Test extends Label {
    
    public function new( t:String ) :Void {
        super( t );
        text = "#"+t;
        addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
        addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
    }
    
    public function onMouseOver( e:MouseEvent ) {
        text+="::over";
        addStyleClass(":over");
    }
    public function onMouseOut( e:MouseEvent ) {
        text=text.split("::")[0];
        removeStyleClass(":over");
    }
    public function toString() :String {
        return( "#"+_id );
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
                background: Color.rgba(0,0,1,.3),
                minWidth:100, minHeight:100,
            });
        xinf.style.StyleSheet.defaultSheet.add(
            [ ":over" ], {
                padding: { l:5, t:5, r:5, b:3 },
                color: Color.rgba(1,1,1,1),
                background: Color.rgba(1,1,1,.4),
            });
        
        var c = new Label("base");
        c.addStyleClass("base");
        c.moveTo(10,10);
  //      c.resize( 200, 200 );
        root.attach(c);
/*        
        var c2 = new CompactGrid(3,3);
        for( t in ["1", "two","three, tri, drei","4","five\n.5","six","7\nor\nso","eight","nine"] ) {
            var p = new Test(t);
            p.resize(20,15);
            c2.add(p);
        }
        c.add(c2);
*/

        var c3 = new Test("c3");
        c3.addStyleClass("base");
        var x:Value = Value.sum( c3.constraints.getX(), Value.constant(10) );
        for( t in ["one","two","three","four","five","six","seven","eight","nine","ten"] ) {
            var p = new Test(t);
       //     trace("x constraint:" +p.constraints.getX());
       //     trace("Test("+t+").constraints: "+p.constraints);
            p.constraints.getX().set( new ComponentXSetter( p, x ) );
            x = p.constraints.getEast();
            c3.attach(p);
        }
        c3.constraints.getEast().set(x);
        c.attach(c3);
        
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
