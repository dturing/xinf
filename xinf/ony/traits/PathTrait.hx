/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.traits;

import xinf.traits.TypedTrait;
import xinf.ony.type.PathSegment;
import xinf.ony.PathParser;

class PathTrait extends TypedTrait<List<PathSegment>> {

	public function new() {
		super( new List<PathSegment>() );
	}

    override public function parse( value:String ) :Dynamic {
		var d = PathParser.simplify(
				new PathParser().parse(value));
		return d;
    }

	override public function getDefault() :Dynamic {
		return new List<PathSegment>();
	}

}
