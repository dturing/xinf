package xinf.ony;

class Rectangle extends Element {

    public var x(default,set_x):Float;
    public var y(default,set_y):Float;
    public var width(default,set_width):Float;
    public var height(default,set_height):Float;
    public var rx(default,set_rx):Float;
    public var ry(default,set_ry):Float;

    private function set_x(v:Float) {
        x=v; return x;
    }
    private function set_y(v:Float) {
        y=v; return y;
    }
    private function set_width(v:Float) {
        width=v; return width;
    }
    private function set_height(v:Float) {
        height=v; return height;
    }
    private function set_rx(v:Float) {
        rx=v; return rx;
    }
    private function set_ry(v:Float) {
        ry=v; return ry;
    }

    public function new() :Void {
	trace("Rectangle");
        super();
        x=y=width=height=0;
        rx=ry=0.;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x = getFloatProperty(xml,"x");
        y = getFloatProperty(xml,"y");
        width = getFloatProperty(xml,"width");
        height = getFloatProperty(xml,"height");
        
        if( xml.exists("rx") ) rx = getFloatProperty(xml,"rx");
        if( xml.exists("ry") ) ry = getFloatProperty(xml,"ry");
    }
}