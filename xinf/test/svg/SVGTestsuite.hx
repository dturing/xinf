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
        var doc:Document;
        doc = Document.load( url, function(d:Document) {
                if( !self.interactive ) {
                    self.runAtNextFrame( function() {
					self.assertDisplay( self.cleanFinish, doc.width, doc.height, self.targetEquality );
                    } );
                } // else just loop on...    
            } );
        Root.attach( doc );
    }

    override public function toString() :String {
        return( url.split("/").pop().split(".").shift() );
    }
}


class SVGTestsuite {
    static function main() {
        var shell = new TestShell();
        var base="http://localhost:2000/static/svg/svg/";
        
        var runOnly:String;
        
        #if neko
            if( neko.Sys.args().length==1 ) {
                runOnly = neko.Sys.args()[0];
            }
        #end
        
        if( runOnly!=null ) {
            #if neko
            shell.add( new SVGTest( "file://"+runOnly ) );
            #end
        } else {
            // FIXME: the first test never works...

			shell.add( new SVGTest( base+"shapes-intro-01-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-rect-01-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-rect-02-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-line-01-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-polygon-01-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-polyline-01-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-ellipse-01-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-ellipse-02-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-circle-01-t.svg" ) );
            shell.add( new SVGTest( base+"shapes-circle-02-t.svg" ) );
            
            shell.add( new SVGTest( base+"paths-data-01-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-02-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-04-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-05-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-06-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-07-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-08-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-09-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-10-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-12-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-13-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-14-t.svg" ) );
            shell.add( new SVGTest( base+"paths-data-15-t.svg" ) );

            shell.add( new SVGTest( base+"render-elems-01-t.svg" ) );
            shell.add( new SVGTest( base+"render-elems-02-t.svg" ) );
            shell.add( new SVGTest( base+"render-elems-03-t.svg" ) );
            shell.add( new SVGTest( base+"render-elems-06-t.svg" ) );
            shell.add( new SVGTest( base+"render-elems-07-t.svg" ) );
            shell.add( new SVGTest( base+"render-elems-08-t.svg" ) );
            shell.add( new SVGTest( base+"render-groups-01-b.svg" ) );
            shell.add( new SVGTest( base+"render-groups-03-t.svg" ) );
            
            shell.add( new SVGTest( base+"struct-group-01-t.svg" ) );
            shell.add( new SVGTest( base+"struct-group-02-b.svg" ) );
		//  currentColor
      //      shell.add( new SVGTest( base+"struct-group-03-t.svg" ) );
           

            shell.add( new SVGTest( base+"coords-coord-01-t.svg" ) );
			shell.add( new SVGTest( base+"coords-coord-02-t.svg" ) );
            shell.add( new SVGTest( base+"coords-trans-01-b.svg" ) );
            shell.add( new SVGTest( base+"coords-trans-02-t.svg" ) );
            shell.add( new SVGTest( base+"coords-trans-03-t.svg" ) );
            shell.add( new SVGTest( base+"coords-trans-04-t.svg" ) );
            shell.add( new SVGTest( base+"coords-trans-05-t.svg" ) );
            shell.add( new SVGTest( base+"coords-trans-06-t.svg" ) );

			// fails in flash as images are not loaded when shot is taken.
            shell.add( new SVGTest( base+"struct-image-01-t.svg" ) );
            shell.add( new SVGTest( base+"struct-image-02-b.svg" ) );
			
            // reference image is 240x180...
            // shell.add( new SVGTest( base+"struct-image-03-t.svg" ) );
            // inline data handling
            //shell.add( new SVGTest( base+"struct-image-04-t.svg" ) );
            shell.add( new SVGTest( base+"struct-image-05-b.svg" ) );
            shell.add( new SVGTest( base+"struct-image-06-t.svg" ) );
            shell.add( new SVGTest( base+"struct-image-07-t.svg" ) );
            shell.add( new SVGTest( base+"struct-image-08-t.svg" ) );
            shell.add( new SVGTest( base+"struct-image-09-t.svg" ) );
            shell.add( new SVGTest( base+"struct-image-10-t.svg" ) );
	
	
            shell.add( new SVGTest( base+"painting-fill-01-t.svg" ) );
            // currentColor
			// shell.add( new SVGTest( base+"painting-fill-02-t.svg" ) );
            shell.add( new SVGTest( base+"painting-fill-03-t.svg" ) );
            shell.add( new SVGTest( base+"painting-fill-04-t.svg" ) );
            shell.add( new SVGTest( base+"painting-fill-05-b.svg" ) );
            shell.add( new SVGTest( base+"painting-render-01-b.svg" ) );
            shell.add( new SVGTest( base+"painting-stroke-02-t.svg" ) );
            shell.add( new SVGTest( base+"painting-stroke-03-t.svg" ) );
            shell.add( new SVGTest( base+"painting-stroke-04-t.svg" ) );
            shell.add( new SVGTest( base+"painting-stroke-07-t.svg" ) );
			
            shell.add( new SVGTest( base+"styling-css-01-b.svg" ) );
            shell.add( new SVGTest( base+"styling-css-02-b.svg" ) );
            // /*comment*/ in CSS
			// shell.add( new SVGTest( base+"styling-css-03-b.svg" ) );
            shell.add( new SVGTest( base+"styling-css-05-b.svg" ) );
            shell.add( new SVGTest( base+"styling-css-06-b.svg" ) );
            // GradientStop color "inherit"
			// shell.add( new SVGTest( base+"styling-inherit-01-b.svg" ) );
			// !important
            // shell.add( new SVGTest( base+"styling-pres-01-t.svg" ) );
    }
        
        shell.run();
    }
}