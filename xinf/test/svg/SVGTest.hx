/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test.svg;

import xinf.test.TestCase;
import xinf.test.TestShell;
import Xinf;

class SVGTest extends TestCase {

    var interactive:Bool;
    var url:String;
    var targetEquality:Float;

    public function new( url:String, ?targetEq:Float, ?interactive:Bool ) {
        this.url=url;
        if( targetEq==null ) targetEq=.96;
        this.targetEquality=targetEq;
        this.interactive=interactive;
        super();
    }

    override public function test() {
        var self=this;

		Document.load( url, function(doc:Svg) {
			Root.appendChild( doc );
			if( !self.interactive ) {
				self.runAtNextFrame( function() {
					var svg = cast( doc, xinf.ony.Svg );
					self.assertDisplay(svg.width, svg.height, function( eq:Float ) {
						self.result( eq>self.targetEquality, "Eq: "+eq, self.cleanFinish );
					} );
				} );
			} // else just loop on...    
		}, Svg );
    }

    override public function toString() :String {
        return( url.split("/").pop().split(".").shift() );
    }
}
