
package xinf.ony;

interface Path implements Element {

    var segments(default,set_segments) :Iterable<PathSegment>;

}
