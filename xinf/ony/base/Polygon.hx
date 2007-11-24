
package xinf.ony;

import xinf.geom.Types;

interface Polygon implements Element {

    var points(default,set_points):Iterable<TPoint>;

}
