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
import xinf.erno.Coord2d;

class RenderTest {
	private var position:Coord2d;
	private var size:Coord2d;
	private var id:Int;
	
	public function new( g:Renderer, position:Coord2d, size:Coord2d ) :Void {
		this.position = position;
		this.size = size;
		id = g.getNextId();
	}
	
	public function show( g:Renderer ) :Void {
		g.showObject(id);
	}
	
	public function render( g:Renderer ) :Void {
		g.startObject(id);
			g.translate( position.x, position.y );
			try {
				renderContents(g,size);
			} catch( e:Dynamic ) {
				g.setFill( Color.RED );
				g.setStroke( null, 0 );
				g.rect(0,0,size.x,size.y);
				trace("Exception testing "+this+": "+e+"\n Stack Trace:\n"+haxe.Stack.toString( haxe.Stack.exceptionStack() ) );
			}
		g.endObject();
	}
	
	private function renderContents( g:Renderer, size:Coord2d ) :Void {
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
			
	private function renderContents( g:Renderer, size:Coord2d ) :Void {
		var x=0.;
		var unit=size.x/colors.length;
		for( c in colors ) {
			g.setFill( c );
			g.rect( x, 0, unit, size.y );
			x+=unit;
		}
	}
}

class GrayStripes extends RenderTest {
	private function renderContents( g:Renderer, size:Coord2d ) :Void {
		var unit=size.x/8;
		for( i in 0...8 ) {
			var c=(i+1)/10;
			g.setFill( Color.rgba( c, c, c, 1 ) );
			g.rect( i*unit, 0, unit, size.y );
		}
	}
}

class AlphaStripes extends RenderTest {
	private function renderContents( g:Renderer, size:Coord2d ) :Void {
		var unit=size.x/8;
		for( i in 0...4 ) {
			var c=1-((i+1)/5);
			g.setFill( Color.rgba( 0, 0, 0, c ) );
			g.rect( i*unit, 0, unit, size.y );
		}
		for( i in 0...4 ) {
			var c=(i+1)/5;
			g.setFill( Color.rgba( 1, 1, 1, c ) );
			g.rect( (4*unit)+(i*unit), 0, unit, size.y );
		}
	}
}

class ShapeRenderTest extends RenderTest {
	private function renderContents( g:Renderer, size:Coord2d ) :Void {
		g.setFill( Color.rgba( 0, 0, 0, 1 ) );
		g.setStroke( null, 0 );
		g.rect( 0, 0, size.x, size.y );
		
		g.setFill( null );
		g.setStroke( Color.rgba( 1, 1, 1, 1 ), 2. );
		renderShape( g, size );
	}

	private function renderShape( g:Renderer, size:Coord2d ) :Void {
	}
}

class Cross extends ShapeRenderTest {
	private function renderShape( g:Renderer, size:Coord2d ) :Void {
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
	private function renderShape( g:Renderer, size:Coord2d ) :Void {
		g.startShape();
			g.startPath( size.x/8, size.y/3 );
			g.quadraticTo( (size.x/2), size.y, (size.x/8)*7, size.y/3 );
			g.endPath();
		g.endShape();
	}
}

class Cubic extends ShapeRenderTest {
	private function renderShape( g:Renderer, size:Coord2d ) :Void {
		g.startShape();
			g.startPath( size.x/8, size.y/2 );
			g.cubicTo( size.x/3, 0, (size.x/3)*2, size.y, (size.x/8)*7, size.y/2 );
			g.endPath();
		g.endShape();
	}
}

class Circle extends ShapeRenderTest {
	private function renderShape( g:Renderer, size:Coord2d ) :Void {
		g.circle( size.x/2, size.y/2, size.y/4 );
	}
}

class Info extends RenderTest {
	private function renderContents( g:Renderer, size:Coord2d ) :Void {
		g.setFill( Color.rgba( 0, 0, 0, 1 ) );
		g.setStroke( null, 0 );
		g.rect(0,0,size.x,size.y);

		g.setFill( Color.rgba( 1,1,1,1 ) );
		g.setFont( "_sans", Roman, Normal, size.y/2. );
		g.text( 0, size.y/4, "xinferno 0.0.0" );
	}
}


class Twist extends RenderTest {
	var innerId:Int;
	var g:Renderer;
	
	public function new( g:Renderer, position:Coord2d, size:Coord2d ) :Void {
		super( g, position, size );
		innerId = g.getNextId();
		this.g = g;
		Runtime.addEventListener( FrameEvent.ENTER_FRAME, step );
	}

	private function step( e:FrameEvent ) :Void {
		var n = (e.frame/2);
		var s = 4;
		var center = { x:(size.x/2)-(s/2), y:(size.y/2)-(s/2) };
		var extent = { x:size.x/4, y:size.y/4 };
		g.startObject(innerId);
			g.setFill( Color.rgba( 1, 1, 1, 1 ) );
			g.rect(	center.x + (Math.cos(n/2)*extent.x), 
					center.y + (Math.sin(n)*extent.y),
					s, s );
		g.endObject();
		Runtime.runtime.changed();
	}
	
	private function renderContents( g:Renderer, size:Coord2d ) :Void {
		g.setFill( Color.rgba( 0, 0, 0, 1 ) );
		g.rect( 0, 0, size.x, size.y );
		g.showObject(innerId);
	}

}

class App {
	public static function renderTestCard( g:Renderer, size:Coord2d ) {
		var rootSize = size;
		if( size.x>size.y ) {
			size.x = (size.y/3)*4;
		} else {
			size.y = (size.x/4)*3;
		}
		var unit={ x:size.x/10, y:size.y/10 };

		var tests = [
			new ColorStripes( g, {x:0.,y:0.}, {x:unit.x*8,y:unit.y*5} ),
			new GrayStripes( g, {x:0.,y:unit.y*5}, {x:unit.x*8,y:unit.y} ),
			new AlphaStripes( g, {x:0.,y:unit.y*6}, {x:unit.x*8,y:unit.y} ),
			
			new Cross( g, {x:0.,y:unit.y*7}, {x:unit.x,y:unit.y} ),
			new Quadratic( g, {x:unit.x,y:unit.y*7}, {x:unit.x,y:unit.y} ),
			new Cubic( g, {x:unit.x*2,y:unit.y*7}, {x:unit.x,y:unit.y} ),
			new Circle( g, {x:unit.x*3,y:unit.y*7}, {x:unit.x,y:unit.y} ),
			
			new Twist( g, {x:unit.x*4,y:unit.y*7}, {x:unit.x,y:unit.y} ),
			new Info( g, {x:unit.x*5,y:unit.y*7}, {x:unit.x*3,y:unit.y} ),
			];
			
		for( test in tests ) test.render( g );

		var id=g.getNextId();
		g.startObject(g.getRootId());
			g.translate( ((rootSize.x-size.x)/2) + unit.x, ((rootSize.y-size.y)/2) + unit.y );
			for( test in tests ) test.show( g );
		g.endObject();
	
	}
	
	public static function main() :Void {
		try {
			Runtime.init();
			var g:Renderer = Runtime.renderer;
			
			renderTestCard( g, { x:320., y:240. } );

			Runtime.run();
		} catch(e:Dynamic) {
			trace(e); //+haxe.Stack.toString( haxe.Stack.exceptionStack() ) );
		}
	}
}
