/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

class ParallelTimeContainer extends TimeContainer {

	public function new( ?traits:Dynamic ) {
		super(traits);
	}
	
	override function step( time:Float ) :Bool {
		trace("step par "+this+": "+time );
		return super.step(time);
	}

}
