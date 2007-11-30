package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;

class Circle extends ElementImpl {

    public var cx(default,set_cx):Float;
    public var cy(default,set_cy):Float;
    public var r(default,set_r):Float;

    function set_cx(v:Float) {
        cx=v; redraw(); return cx;
    }
    function set_cy(v:Float) {
        cy=v; redraw(); return cy;
    }
    function set_r(v:Float) {
        r=v; redraw(); return r;
    }

	override public function getBoundingBox() : TRectangle {
		return { l:cx-r, t:cy-r, r:cx+r, b:cy+r };
	}

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        cx = getFloatProperty(xml,"cx");
        cy = getFloatProperty(xml,"cy");
        r = getFloatProperty(xml,"r");
    }

}