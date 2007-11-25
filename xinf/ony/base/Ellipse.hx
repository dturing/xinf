package xinf.ony.base;
import xinf.ony.base.Implementation;

class Ellipse extends ElementImpl {

	public var cx(default,set_cx):Float;
	public var cy(default,set_cy):Float;
	public var rx(default,set_rx):Float;
	public var ry(default,set_ry):Float;

    function set_cx(v:Float) {
        cx=v; redraw(); return cx;
    }
    function set_cy(v:Float) {
        cy=v; redraw(); return cy;
    }
    function set_rx(v:Float) {
        rx=v; redraw(); return rx;
    }
    function set_ry(v:Float) {
        ry=v; redraw(); return ry;
    }

    public function new() :Void {
        super();
        cx=cy=0;
        rx=ry=0;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        cx = getFloatProperty(xml,"cx");
        cy = getFloatProperty(xml,"cy");
        rx = getFloatProperty(xml,"rx");
        ry = getFloatProperty(xml,"ry");
    }

}