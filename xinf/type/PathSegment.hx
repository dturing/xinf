/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */

package xinf.type;

enum PathSegment {
    MoveTo( x:Float, y:Float );
    Close;
    LineTo( x:Float, y:Float );
    CubicTo( x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float );
    QuadraticTo( x1:Float, y1:Float, x:Float, y:Float );
    ArcTo( rx:Float, ry:Float, rotation:Float, largeArc:Bool, sweep:Bool, x:Float, y:Float );
}
