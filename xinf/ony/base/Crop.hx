package xinf.ony.base;
import xinf.ony.base.Implementation;

class Crop extends GroupImpl {

    public var width(default,set_width):Float;
    public var height(default,set_height):Float;

    private function set_width(v:Float) {
        width=v; redraw(); return width;
    }
    private function set_height(v:Float) {
        height=v; redraw(); return height;
    }

    public function new() :Void {
        super();
        width=height=0;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        width = getFloatProperty(xml,"width");
        height = getFloatProperty(xml,"height");
    }

}