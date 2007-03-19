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

import xinf.ony.Application;
import xinf.event.MouseEvent;
import xinf.erno.Runtime;
import xinf.erno.Renderer;

class Sketch extends xinf.ony.Object {
    var first:{x:Float,y:Float};
    var sketch:Array<{x:Float,y:Float}>;
    
    public function new( first:{x:Float,y:Float} ) :Void {
        super();
        this.first = first;
        sketch = new Array<{x:Float,y:Float}>();
    }

    public function append( p:{x:Float,y:Float} ) :Void {
        sketch.push(p);
        scheduleRedraw();
    }

    public function drawContents( g:Renderer ) :Void {
        g.setStroke(0,0,0,1,3);

        #if js
            for( i in sketch )
                g.rect( i.x, i.y, 1, 1 );
        #else true
            g.startShape();
            g.startPath(first.x, first.y);
            for( i in sketch ) {
                g.lineTo( i.x, i.y );
            }
            g.endPath();
            g.endShape();
        #end
    }
}

class Sketcher extends xinf.ony.Container<xinf.ony.Object> {
    public function new() :Void {
        super();
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
    }
    
    function onMouseDown( e:MouseEvent ) :Void {
        var self = this;
        var sketch = new Sketch({x:1.*e.x, y:1.*e.y});
        attach( sketch );

        var mv = Runtime.addEventListener( MouseEvent.MOUSE_MOVE, function(e) {
                sketch.append( self.globalToLocal( {x:1.*e.x, y:1.*e.y} ) );
            } );
        Runtime.addEventListener( MouseEvent.MOUSE_UP, function(e) {
                Runtime.removeEventListener( MouseEvent.MOUSE_MOVE, mv );
            } );
    }

    public function drawContents( g:Renderer ) :Void {
        g.setFill(1,1,1,1);
        g.rect(0,0,size.x,size.y);
    }
}

class App extends Application {
    public function new() :Void {
        super();
        
        var sketcher = new Sketcher();
        root.attach( sketcher );
        sketcher.resize( root.size.x, root.size.y );
        xinf.erno.Runtime.addEventListener( 
            xinf.event.GeometryEvent.STAGE_SCALED, function(e) {
                sketcher.resize( e.x, e.y );
            });
    }
    
    public static function main() :Void {
        new App().run();
    }
}
