/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.traits.EnumTrait;
import xinf.ony.PathParser;
import xinf.ony.type.PathSegment;
import xinf.geom.Transform;
import xinf.geom.TransformList;
import xinf.geom.Rotate;
import xinf.geom.Translate;
import xinf.anim.type.CalcMode;
import xinf.anim.tools.FlatPath;
import xinf.anim.tools.FlatPathIterator;
import xinf.anim.tools.PacedPathIterator;
import xinf.anim.type.RotateMotion;
import xinf.anim.type.RotateMotionTrait;

class AnimateMotion extends TimedAttributeSetter {

	static var TRAITS = {
		calcMode: new EnumTrait<CalcMode>( CalcMode, CalcMode.Paced ),
		path: new StringTrait(),
		rotate: new RotateMotionTrait(),
	//	keyPoints: new FloatListTrait(),
	//	keyTimes: new FloatListTrait(),
	};

	public var calcMode(get_calc_mode,set_calc_mode):CalcMode;
	function get_calc_mode() :CalcMode { return getTrait("calcMode",CalcMode); }
	function set_calc_mode( v:CalcMode ) :CalcMode { return setTrait("calcMode",v); }

	public var path(get_path,set_path):String;
	function get_path() :String { return getStyleTrait("path",String); }
	function set_path( v:String ) :String { setStyleTrait("path",v); return v; }

	public var rotate(get_rotate,set_rotate):RotateMotion;
	function get_rotate() :RotateMotion { return getTrait("rotate",RotateMotion); }
	function set_rotate( v:RotateMotion ) :RotateMotion { return setTrait("rotate",v); }

	var originalValue:Transform;
	var iterator:FlatPathIterator;
	var transform:Transform;
	
	function createIterator() {
		var segments:Iterable<PathSegment> = null;
		for( child in childNodes ) {
			if( Std.is( child, MPath ) ) {
				var mpath:MPath = cast(child);
				segments = mpath.getPath().segments;
			}
		}
		if( segments==null && path!=null )
			segments = PathParser.simplify(new PathParser().parse(path));
			
		if( segments==null ) return;
		var flat = new FlatPath(); flat.flatten(segments);
		var step = flat.length() / (simpleDuration*25);
		iterator = new PacedPathIterator( flat, step );
	}
	
	override function start( t:Float ) {
		if( peer==null ) throw("cannot create animation function, no peer set.");
		attributeName="transform";
		originalValue = cast(getFromTarget());
		createIterator();
		super.start(t);
	}
	
	override function frozen( t:Float ) {
		if( (t-started)%simpleDuration==0 ) {
			var r = 0.;
			switch( rotate ) {
				case Fixed(rot):
					r=rot;
				case Auto:
					r = iterator.finalRotation();
				case AutoOffset(rot):
					r = iterator.finalRotation()+rot;
			}
			var cur = iterator.finalPoint();
			transform = new TransformList([
					new Rotate( r ),
					new Translate( cur.x, cur.y ),
					originalValue
				]);
		}
		setOnTarget( transform ); 
	}

	override function step( t:Float ) {
		if( !super.step(t) ) return false;
		if( iterator==null ) return false;
		if( !iterator.hasNext() ) iterator.reset();

		var r = 0.;
		switch( rotate ) {
			case Fixed(rot):
				r=rot;
			case Auto:
				r = iterator.rotation();
			case AutoOffset(rot):
				r = iterator.rotation()+rot;
		}

		var cur = iterator.next();
		
		transform = new TransformList([
				new Rotate( r ),
				new Translate( cur.x, cur.y ),
				originalValue
			]);
		setOnTarget(transform);
		
		return true;
	}

}
