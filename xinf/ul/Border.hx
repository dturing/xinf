/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

class Border {
	public var l:Float;
	public var t:Float;
	public var r:Float;
	public var b:Float;
	
	public function new( ?l:Float, ?t:Float, ?r:Float, ?b:Float ) :Void {
		this.l = if(l!=null) l else 0.;
		this.t = if(t!=null) t else this.l;
		this.r = if(r!=null) r else this.l;
		this.b = if(b!=null) b else this.t;
	}
}