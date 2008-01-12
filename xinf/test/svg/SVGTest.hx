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
        super();
        if( targetEq==null ) targetEq=.96;
        this.targetEquality=targetEq;
        this.interactive=interactive;
    }

    override public function test() {
    
		// we're not using Document.load to catch the exception.. hmm..
	
		var self=this;
		var turl = new xinf.xml.URL(url);
		turl.fetch( function(data) {
			try {
				Document.instantiate( data, turl, null, function(doc:Svg) {
					Root.appendChild( doc );
					if( !self.interactive ) {
						self.runAtNextFrame( function() {
							self.assertDisplay(doc.width, doc.height, function( eq:Float ) {
								self.result( eq>self.targetEquality, "Eq: "+eq, self.cleanFinish );
							} );
						} );
					} // else just loop on...    
				}, Svg );
			} catch( e:Dynamic ) {
				self.result( false, "Exception: "+e, function() { self.cleanFinish(); } );
			}
		}, function( error ) {
			throw(error);
		} );
    }

    override public function toString() :String {
		if( url==null ) return "[uninitialized]";
        return( url.split("/").pop().split(".").shift() );
    }
}
