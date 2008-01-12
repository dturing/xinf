/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test;

import x11.Display;

/**
    A neko remoting server for TestShell to connect to.
    Takes screenshot on given X display with netpbm.
    Linux-only, needs elaborate environment. See test/Makefile.
**/
class TestServer {
    
    public static var displayName = ":10.0";
    public static var resultDir = "results";
    
    static function assureResultDir() {
        // assure result directory exists
        if( !neko.FileSystem.exists( resultDir ) ) {
            neko.FileSystem.createDirectory( resultDir );
        }
        if( !neko.FileSystem.isDirectory( resultDir ) ) {
            throw( "test result directory '"+resultDir+"' exists but is not a directory" );
        }
    }
    
    static function startRun( suite:String, platform:String ) {
		var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write(
            "<testrun  date=\""+ DateTools.format( Date.now(), "%Y-%m-%d %H:%M:%S" )+"\""
            +" suite=\""+suite+"\""
			+" platform=\""+platform+"\""
			+">\n");
        out.close();
    }

    static function endRun() {
        var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write("</testrun>\n");
        out.close();
    }

    static function startTest( testName:String ) {
        var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write("<case name=\""+testName+"\">\n");
        out.close();
    }

    static function result( pass:Bool, message:String ) :Void {
        var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write(
            "\t<result pass=\""+pass 
            +"\">"+message
            +"</result>\n"
		+"</case>\n");
        out.close();
    }

    static function info( message:String ) :Void {
        var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write(
            "\t<info>"+message+"</info>\n");
        out.close();
    }

    static function shoot( testName:String, suite:String, platform:String, width, height ) :Float {
        var baseName = resultDir+"/"+testName+"-";
        var img = baseName+platform+".pnm";
        var diff = baseName+platform+"-diff.pnm";
		var refDir = "static/"+suite+"/pnm";
		var ref = refDir+"/"+testName+".pnm";

        if( width==null ) width=480;
        if( height==null ) height=360;

        // make screenshot
        //var exitCode = neko.Sys.command("xwd -display "+displayName+" -nobdrs -root | xwdtopnm | pnmcut -left 1 -top 1 -width "+width+" -height "+height+" | pnmscale -xysize 160 120 > "+img );
		var exitCode = neko.Sys.command("xwd -display "+displayName+" -nobdrs -root | xwdtopnm | pnmcut -left 1 -top 1 -width "+width+" -height "+height+" > "+img );
		if( exitCode != 0 ) throw("Could not take screenshot.");

        if( neko.FileSystem.exists( ref ) ) {
           // compare to reference
            exitCode = neko.Sys.command("pamarith -difference "+ref+" "+img+" > "+diff );
            if( exitCode == 0 ) exitCode = neko.Sys.command("pamsumm -mean -normalize -brief "+diff+" > /tmp/xinftest-diff");
            if( exitCode != 0 ) {
//				info("Could not compare reference image. Wrong Size?");
				return 0.;
			}
          
            var eq = 1.0 - Std.parseFloat( neko.io.File.getContent("/tmp/xinftest-diff") );
            
            // convert images to png
            neko.Sys.command("pnmtopng -compression 7 "+img+" > "+baseName+platform+".png");
            neko.Sys.command("pnmtopng -compression 7 "+diff+" > "+baseName+platform+"-diff.png");
            return eq;
        } else {
//            info("reference image '"+ref+"' does not exist");
        }
        return -1.;
    }
    
    static function mouseMove( x:Int, y:Int ) {
        var dpy = Display.openDisplay( displayName );
        if( !dpy.hasTestFakeExtension() ) throw("need XTest extension to fake input events");
        dpy.testFakeMotionEvent( 0, x+1, y+1, 0 );
    }

    static function mouseButton( button:Int, press:Bool ) {
        var dpy = Display.openDisplay( displayName );
        if( !dpy.hasTestFakeExtension() ) throw("need XTest extension to fake input events");
        dpy.testFakeButtonEvent( button, press, 0 );
    }

    static function main() {
        assureResultDir();
        var r = new neko.net.RemotingServer();
        r.addObject( "test", TestServer );
        if( r.handleRequest() ) return;
        
        // else, emit result.xml
        neko.Web.setHeader("Content-type", "text/xml");
        neko.Lib.print("<?xml version=\"1.0\"?>\n<?xml-stylesheet type=\"text/xsl\" href=\"static/results.xsl\"?>\n<results>\n");
        neko.Lib.print( neko.io.File.getContent( resultDir+"/results.xml" ) );
        neko.Lib.print("</results>\n");
    }
}
