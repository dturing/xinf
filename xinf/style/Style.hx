package xinf.style;

import xinf.style.Sides;
import xinf.style.Border;

signature Style {
	var padding :Sides<Float>;
	var border :SidesAndCorners<BorderStyle>;
	var background :xinf.ony.Color;
	var color :xinf.ony.Color;
}
