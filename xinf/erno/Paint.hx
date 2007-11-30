package xinf.erno;

import xinf.geom.Transform;

typedef TGradientStop = {
	color :Color,
	offset :Float
}

enum SpreadMethod {
	PadSpread;
	ReflectSpread;
	RepeatSpread;
}

enum Paint {
	None;
	URLReference( url:String );
	SolidColor( r:Float, g:Float, b:Float, a:Float );
	PLinearGradient( stops:Iterable<TGradientStop>, x1:Float, y1:Float, x2:Float, y2:Float, spread:SpreadMethod );
	PRadialGradient( stops:Iterable<TGradientStop>, cx:Float, cy:Float, r:Float, fx:Float, fy:Float, spread:SpreadMethod );
//	Pattern( ... );
}
