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

import xinf.event.FrameEvent;

import xinf.erno.Runtime;
import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;
import xinf.geom.Types;
import xinf.geom.Matrix;

class RenderTest {
    private var position:TPoint;
    private var size:TPoint;
    private var id:Int;
    
    public function new( g:Renderer, position:TPoint, size:TPoint ) :Void {
        this.position = position;
        this.size = size;
        id = Runtime.runtime.getNextId();
    }
    
    public function show( g:Renderer ) :Void {
        g.showObject(id);
    }
    
    public function render( g:Renderer ) :Void {
        g.setTranslation( id, position.x, position.y );
        g.startObject(id);
            try {
                renderContents(g,size);
            } catch( e:Dynamic ) {
                g.setFill( 1,0,0,1 );
                g.setStroke( 0,0,0,0, 0 );
                g.rect(0,0,size.x,size.y);
                try {
                    trace("Exception testing "+this+": "+e+"\n Stack Trace:\n"+haxe.Stack.toString( haxe.Stack.exceptionStack() ) );
                } catch( f:Dynamic ) {
                    // getting the stack didnt work out...
                    trace("Exception testing "+this+": "+e+", "+f );
                }
            }
        g.endObject();
    }

    public function renderDirect( g:Renderer ) :Void {
        g.startObject(id);
        g.setTranslation( id, position.x, position.y );
            try {
                renderContents(g,size);
            } catch( e:Dynamic ) {
                g.setFill( 1,0,0,1 );
                g.setStroke( 0,0,0,0, 0 );
                g.rect(0,0,size.x,size.y);
                try {
                    trace("Exception testing "+this+": "+e+"\n Stack Trace:\n"+haxe.Stack.toString( haxe.Stack.exceptionStack() ) );
                } catch( f:Dynamic ) {
                    // getting the stack didnt work out...
                    trace("Exception testing "+this+": "+e );
                }
            }
        g.endObject();
    }

    private function renderContents( g:Renderer, size:TPoint ) :Void {
        throw("unimplemented render test: "+this );
    }
    
    public function toString() :String {
        return Type.getClassName( Type.getClass(this) );
    }
}

class ColorStripes extends RenderTest {
    private static var colors = [
            Color.rgba(1,1,1,1),
            Color.rgba(1,1,0,1),
            Color.rgba(0,1,1,1),
            Color.rgba(0,1,0,1),
            Color.rgba(1,0,1,1),
            Color.rgba(1,0,0,1),
            Color.rgba(0,0,1,1),
            Color.rgba(0,0,0,1)
            ];
            
    private function renderContents( g:Renderer, size:TPoint ) :Void {
        var x=0.;
        var unit=size.x/colors.length;
        for( c in colors ) {
            g.setFill( c.r, c.g, c.b, c.a );
            g.rect( x, 0, unit, size.y );
            x+=unit;
        }
    }
}

class GrayStripes extends RenderTest {
    private function renderContents( g:Renderer, size:TPoint ) :Void {
        var unit=size.x/8;
        for( i in 0...8 ) {
            var c=(i+1)/10;
            g.setFill( c, c, c, 1 );
            g.rect( i*unit, 0, unit, size.y );
        }
    }
}

class GrayChecker extends RenderTest {
    private function renderContents( g:Renderer, size:TPoint ) :Void {
        var d = 13;
        var unit={ x:size.x/d, y:size.y/d };
        var set=true;
        for( y in 0...d ) {
            for( x in 0...d ) {
                if( (x+y)%2 == 0 ) {
                    g.setFill( 1,1,1,.6 );
                    g.rect( x*unit.x, y*unit.y, unit.x, unit.y );
                } else {
                    g.setFill( 1,1,1,.3 );
                    g.rect( x*unit.x, y*unit.y, unit.x, unit.y );
                }
                set = !set;
            }
        }
    }
}

class AlphaStripes extends RenderTest {
    private function renderContents( g:Renderer, size:TPoint ) :Void {
        var unit=size.x/8;
        for( i in 0...4 ) {
            var c=1-((i+1)/5);
            g.setFill( 0, 0, 0, c );
            g.rect( i*unit, 0, unit, size.y );
        }
        for( i in 0...4 ) {
            var c=(i+1)/5;
            g.setFill( 1, 1, 1, c );
            g.rect( (4*unit)+(i*unit), 0, unit, size.y );
        }
    }
}

class ShapeRenderTest extends RenderTest {
    private function renderContents( g:Renderer, size:TPoint ) :Void {
        g.setFill( 0, 0, 0, 1 );
        g.setStroke( 0, 0, 0, 0, 0 );
        g.rect( 0, 0, size.x, size.y );
        
        g.setFill( 0,0,0,0 );
        g.setStroke( 1, 1, 1, 1, 2. );
        renderShape( g, size );
    }

    private function renderShape( g:Renderer, size:TPoint ) :Void {
    }
}

class Cross extends ShapeRenderTest {
    private function renderShape( g:Renderer, size:TPoint ) :Void {
        g.startShape();
            g.startPath( size.x/4, size.y/2 );
                g.lineTo( (size.x/4)*3, size.y/2 );
            g.endPath();
            g.startPath( size.x/2, size.y/4 );
                g.lineTo( size.x/2, (size.y/4)*3 );
            g.endPath();
        g.endShape();
    }
}

class Quadratic extends ShapeRenderTest {
    private function renderShape( g:Renderer, size:TPoint ) :Void {
        g.startShape();
            g.startPath( size.x/8, size.y/3 );
            g.quadraticTo( (size.x/2), size.y, (size.x/8)*7, size.y/3 );
            g.endPath();
        g.endShape();
    }
}

class Cubic extends ShapeRenderTest {
    private function renderShape( g:Renderer, size:TPoint ) :Void {
        g.startShape();
            g.startPath( size.x/8, size.y/2 );
            g.cubicTo( size.x/3, 0, (size.x/3)*2, size.y, (size.x/8)*7, size.y/2 );
            g.endPath();
        g.endShape();
    }
}

class Circle extends ShapeRenderTest {
    private function renderShape( g:Renderer, size:TPoint ) :Void {
        g.circle( size.x/2, size.y/2, size.y/4 );
    }
}

class AnimatedTest extends RenderTest {
    var innerId:Int;
    var g:Renderer;
    
    public function new( g:Renderer, position:TPoint, size:TPoint ) :Void {
        super( g, position, size );
        innerId = Runtime.runtime.getNextId();
        g.setTranslation(innerId,0,0);
        this.g = g;
        createAnimated( innerId, size.x/6, size.x/6 );
        Runtime.addEventListener( FrameEvent.ENTER_FRAME, step );
    }

    private function step( e:FrameEvent ) :Void {
        renderAnimated(innerId, e.frame);
        Runtime.runtime.changed();
    }
    
    private function createAnimated( id:Int, ex:Float, ey:Float ) :Void {
        var inner = Runtime.runtime.getNextId();
        g.startObject(inner);
        g.setFill( 0,0,0,.7 );
        g.rect( -ex/2, -ey/2, ex, ey );
        g.endObject();
    
        g.startObject(id);
            g.setFill( 1,1,1,.7 );
            g.rect( -ex, -ey, ex*2, ey*2 );
            g.showObject( inner );
        g.endObject();
    }
    
    private function renderAnimated( id:Int, frame:Int ) :Void {
    }
    
    private function renderContents( g:Renderer, size:TPoint ) :Void {
        g.setFill( 0, 0, 0, 1 );
        g.rect( 0, 0, size.x, size.y );
        g.showObject(innerId);
    }

}

class Twist extends AnimatedTest {

    private function renderAnimated( id:Int, frame:Int ) :Void {
        var n = (frame/2);
        var s = size.x/16;
        var center = { x:(size.x/2)-(s/2), y:(size.y/2)-(s/2) };
        var extent = { x:size.x/6, y:size.x/6 };
    
        g.setTranslation( id,
                    center.x + (Math.cos(n/2)*extent.x), 
                    center.y + (Math.sin(n)*extent.y) );
    }
}

class Rotate extends AnimatedTest {
    var matrix:xinf.geom.Matrix;
    public function new( g:Renderer, position:TPoint, size:TPoint ) :Void {
        super( g, position, size );
        matrix = new xinf.geom.Matrix().setIdentity();
    }
    
    private function renderAnimated( id:Int, frame:Int ) :Void {
        matrix.setTranslation( size.x/2, size.y/2 );
        matrix.setRotation( frame/10 );
        g.setTransform( id, matrix.tx, matrix.ty, matrix.a, matrix.b, matrix.c, matrix.d );
    }
}

class Scale extends AnimatedTest {
    var matrix:xinf.geom.Matrix;
    public function new( g:Renderer, position:TPoint, size:TPoint ) :Void {
        super( g, position, size );
        matrix = new xinf.geom.Matrix().setIdentity();
    }
    
    private function createAnimated( id:Int, ex:Float, ey:Float ) :Void {
        super.createAnimated( id, .5, .5 );
    }

    private function renderAnimated( id:Int, frame:Int ) :Void {
        matrix.setTranslation( size.x/2, size.y/2 );
        matrix.setScale( Math.sin(frame/10)*size.x, Math.cos(frame/7)*size.y );
        g.setTransform( id, matrix.tx, matrix.ty, matrix.a, matrix.b, matrix.c, matrix.d );
    }
}

class Info extends RenderTest {
    var g:Renderer;
    var l:Dynamic;
    
    public function new( g:Renderer, position:TPoint, size:TPoint ) :Void {
        super( g, position, size );
        this.g = g;
    }
    
    private function renderContents( g:Renderer, size:TPoint ) :Void {
        var text = "xinferno "+xinf.Version.version;
        var textSize = TextFormat.getDefault().textSize( text );
        var pad = 7;
        size = { x:textSize.x+(2*pad), y:textSize.y+(2*pad) };
        var ofs = -size.x/2;
        g.setFill( 0, 0, 0, 1 );
        g.rect( ofs, 0, size.x, size.y );
        
        g.setFill( 1, 1, 1, 1 );
        g.text( ofs+pad, pad, "xinferno "+xinf.Version.version, TextFormat.getDefault() );
    }

}

class App {
    public static function renderTestCard( g:Renderer, size:TPoint ) {
        var rootSize = size;
        if( size.x>size.y ) {
            size.x = (size.y/3)*4;
        } else {
            size.y = (size.x/4)*3;
        }
        var unit={ x:size.x/10, y:size.y/10 };

        var tests = [
            new GrayChecker( g, {x:-unit.x,y:-unit.y}, {x:size.x,y:size.y} ),
 
            new Cross( g, {x:0.,y:unit.y*7}, {x:unit.x,y:unit.y} ),
            new ColorStripes( g, {x:0.,y:0.}, {x:unit.x*8,y:unit.y*5} ),
            new GrayStripes( g, {x:0.,y:unit.y*5}, {x:unit.x*8,y:unit.y} ),
            new AlphaStripes( g, {x:0.,y:unit.y*6}, {x:unit.x*8,y:unit.y} ),
            
            new Quadratic( g, {x:unit.x,y:unit.y*7}, {x:unit.x,y:unit.y} ),
            new Cubic( g, {x:unit.x*2,y:unit.y*7}, {x:unit.x,y:unit.y} ),
            new Circle( g, {x:unit.x*3,y:unit.y*7}, {x:unit.x,y:unit.y} ),
            new Twist( g, {x:unit.x*4,y:unit.y*7}, {x:unit.x,y:unit.y} ),
            new Rotate( g, {x:unit.x*5,y:unit.y*7}, {x:unit.x,y:unit.y} ),
            new Scale( g, {x:unit.x*6,y:unit.y*7}, {x:unit.x,y:unit.y} ),
            
            new Info( g, {x:(size.x*.5)-unit.x,y:size.y*.25}, {x:0.,y:0.} ),
            ];
            
        var id=Runtime.runtime.getNextId();
        
        g.setTranslation( id, ((rootSize.x-size.x)/2) + unit.x, ((rootSize.y-size.y)/2) + unit.y );
        g.startObject(id);
            for( test in tests ) test.show( g );
        g.endObject();

        for( test in tests ) test.render( g );

        g.startNative(Runtime.runtime.getDefaultRoot());
            g.showObject(id);
        g.endNative();


        Runtime.runtime.addEventFilter( function(e:Dynamic):Bool {
            if( e.type != FrameEvent.ENTER_FRAME 
                && e.type != xinf.event.MouseEvent.MOUSE_MOVE ) trace("Event: "+e);
            return true;
        } );
    }
    
    public static function main() :Void {
    
        try {
            var g:Renderer = Runtime.renderer;
            
            renderTestCard( g, { x:320., y:240. } );

            Runtime.runtime.run();
        /* direct renderer -- use .renderDirect, above
            renderTestCard( g, { x:320., y:240. } );
        //    untyped g.writeToPNG("/tmp/test.png");
        */
        } catch(e:Dynamic) {
            try {
                trace(e+"\n"+haxe.Stack.toString( haxe.Stack.exceptionStack() ) );
            } catch(f:Dynamic) {
                trace(e);
            }
        }
    }
}
