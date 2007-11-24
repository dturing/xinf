
package xinf.ony;

import xinf.erno.ImageData;

interface Image implements Element {

    var x(default,set_x):Float;
    var y(default,set_y):Float;
    var width(default,set_width):Float;
    var height(default,set_height):Float;

    var href(default,set_href):String;
    var bitmap(default,set_bitmap):ImageData;
	
}
