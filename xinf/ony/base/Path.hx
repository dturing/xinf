package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.ony.PathSegment;
import xinf.ony.PathParser;

class Path extends ElementImpl {

    public var segments(default,set_segments):Iterable<PathSegment>;

    private function set_segments(v:Iterable<PathSegment>) {
        segments=v; redraw(); return segments;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( xml.exists("d") ) {
            segments = new PathParser().parse(xml.get("d"));
        }
    }

}
