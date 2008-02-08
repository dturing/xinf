/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

import xinf.traits.EnumTrait;

class RotateMotionTrait extends EnumTrait<RotateMotion> {

    public function new() {
        super( RotateMotion, null, RotateMotion.Fixed(0) );
    }

	override public function parse( value:String ) :Dynamic {
		if( value=="auto" ) return RotateMotion.Auto;
		if( value=="auto-reverse" ) return RotateMotion.AutoOffset(Math.PI);
		return RotateMotion.Fixed( (Std.parseFloat(value)/180)*Math.PI );
    }
	
}
