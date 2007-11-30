package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;

class Line extends ElementImpl {

    public var x1(default,set_x1):Float;
    public var y1(default,set_y1):Float;
    public var x2(default,set_x2):Float;
    public var y2(default,set_y2):Float;

    private function set_x1(v:Float) {
        x1=v; redraw(); return x1;
    }
    private function set_y1(v:Float) {
        y1=v; redraw(); return y1;
    }
    private function set_x2(v:Float) {
        x2=v; redraw(); return x2;
    }
    private function set_y2(v:Float) {
        y2=v; redraw(); return y2;
    }

    public function new() :Void {
        super();
        x1=y1=x2=y2=0;
    }

	override public function getBoundingBox() : TRectangle {
		return { l:x1, t:y1, r:x2, b:y2 };
	}

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x1 = getFloatProperty(xml,"x1");
        y1 = getFloatProperty(xml,"y1");
        x2 = getFloatProperty(xml,"x2");
        y2 = getFloatProperty(xml,"y2");
    }

}
