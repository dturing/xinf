/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.erno.Renderer;

/**
    this Enum defines the <a href="Renderer.html">Renderer</a> interface
    as enum values. It is currently unused, but will be reborn someday.
    
enum Instruction {
    
    StartObject( id:Int );
    EndObject();
    ShowObject( id:Int );

    Translate( x:Float, y:Float );
    Scale( x:Float, y:Float );
    Rotate( angle:Float );
    Transform( matrix:Matrix );
    ClipRect( w:Float, h:Float );

    SetFill( c:Color );
    SetStroke( c:Color, width:Float );
    SetFont( face:String, slant:FontSlant, weight:FontWeight, size:Float );

    StartShape();
    EndShape();
    StartPath( x:Float, y:Float);
    EndPath();
    Close();
    LineTo( x:Float, y:Float );
    QuadraticTo( x1:Float, y1:Float, x:Float, y:Float );
    CubicTo( v:Array<Float> ); // hargl, neko! 6 parameters mess up the enum.
    
    Rect( x:Float, y:Float, w:Float, h:Float );
    Circle( x:Float, y:Float, r:Float );
    Text( text:String, ?style:FontStyle );
    Image( img:ImageData, inRegion:{ x:Float, y:Float, w:Float, h:Float }, outRegion:{ x:Float, y:Float, w:Float, h:Float } );
    
    Native( o:Dynamic );
}
**/

