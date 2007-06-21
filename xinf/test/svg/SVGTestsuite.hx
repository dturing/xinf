package xinf.test.svg;

import xinf.test.TestCase;
import xinf.test.TestShell;
import xinf.geom.Transform;

class SVGTest extends TestCase {

    var interactive:Bool;
    var data:String;
    var targetEquality:Float;

    public function new( data:String, ?targetEq:Float, ?interactive:Bool ) {
        this.data=data;
        if( targetEq==null ) targetEq=.96;
        this.targetEquality=targetEq;
        this.interactive=interactive;
        super();
    }

    public function testSVG( data:String ) {
        var doc = X.document();
        var x = Xml.parse( data );
        doc.fromXml( x.firstElement() );
        X.root().attach( doc );
   
        if( !interactive ) {
            var self=this;
            runAtNextFrame( function() {
                self.assertDisplay( self.cleanFinish, doc.width, doc.height, self.targetEquality );
            } );
        } // else just loop on...    
    }

    override public function test() {
        testSVG(data);
    }

}

class HttpSVGTest extends SVGTest {
    public var url:String;
    
    public function new( url:String, ?interactive:Bool ) {
        this.url=url;
        super( null, interactive );
    }
    
    override public function test() {
        var rq = new haxe.Http(url);
        var self=this;
        rq.onError = function(e) {
            throw(e);
        }
        rq.onData = function(d) {
            self.testSVG(d);
        }
        rq.request( false );
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
            shell.add( new SVGTest( neko.io.File.getContent(runOnly), true ) );
            #end
        } else {
            // FIXME: the first test never works...
            shell.add( new SVGTest( "<svg/>") );
            
           /* 
            shell.add( new HttpSVGTest( base+"shapes-intro-01-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-rect-01-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-rect-02-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-line-01-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-polygon-01-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-polyline-01-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-ellipse-01-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-ellipse-02-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-circle-01-t.svg" ) );
            shell.add( new HttpSVGTest( base+"shapes-circle-02-t.svg" ) );
          */ 
            
            shell.add( new HttpSVGTest( base+"paths-data-01-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-02-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-04-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-05-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-06-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-07-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-08-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-09-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-10-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-12-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-13-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-14-t.svg" ) );
            shell.add( new HttpSVGTest( base+"paths-data-15-t.svg" ) );
        }
        
        shell.run();
    }
}