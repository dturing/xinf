
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
    public static var refDir = "static/svg/pnm";
    
    static function assureResultDir() {
        // assure result directory exists
        if( !neko.FileSystem.exists( resultDir ) ) {
            neko.FileSystem.createDirectory( resultDir );
        }
        if( !neko.FileSystem.isDirectory( resultDir ) ) {
            throw( "test result directory '"+resultDir+"' exists but is not a directory" );
        }
    }
    
    static function startRun( platform:String ) {
        var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write(
            "<testrun date=\""+ DateTools.format( Date.now(), "%Y-%m-%d %H:%M:%S" )
            +"\" platform=\""+platform
            +"\">\n");
        out.close();
    }

    static function endRun() {
        var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write("</testrun>\n");
        out.close();
    }

    static function result( testNumber:Int, testName:String, platform:String, pass:Bool, message:String, expectFail:Bool, imageUrl:String ) :Void {
        var exp = if( expectFail!=null ) { ""+expectFail; } else { "false"; }
        var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write(
            "<result test=\""+testName
            +"\" nr=\""+testNumber
            +"\" platform=\""+platform
            +"\" pass=\""+pass
            +"\" expect-fail=\""+exp+"\"" );
        if( imageUrl!=null ) {
            out.write(" image=\""+imageUrl+"\"" );
        }
        out.write(
            ">"+message
            +"</result>\n");
        out.close();
    }

    static function info( testName:String, platform:String, message:String ) :Void {
        var out = neko.io.File.append( resultDir+"/results.xml", false );
        out.write(
            "<info test=\""+testName
            +"\" platform=\""+platform
            +"\">"+message
            +"</info>\n");
        out.close();
    }

    static function shoot( testNumber:Int, testName:String, platform:String, width, height, targetEquality:Float, expectFail:Bool ) :Float {
        var baseName = resultDir+"/"+testName+"-";
        var img = baseName+platform+".pnm";
        var diff = baseName+platform+"-diff.pnm";
        var ref = refDir+"/basic-"+testName+".pnm";

        if( width==null ) width=160;
        if( height==null ) height=120;

        // make screenshot
        var exitCode = neko.Sys.command("xwd -display "+displayName+" -nobdrs -root | xwdtopnm | pnmcut -left 1 -top 1 -width "+width+" -height "+height+" | pnmscale -xysize 160 120 > "+img );
        if( exitCode != 0 ) throw("Could not take screenshot.");

        if( neko.FileSystem.exists( ref ) ) {
            // compare to reference
            exitCode = neko.Sys.command("pamarith -difference "+ref+" "+img+" > "+diff );
            if( exitCode != 0 ) throw("Could not compare reference image.");
            exitCode = neko.Sys.command("pamsumm -mean -normalize -brief "+diff+" > /tmp/xinftest-diff");
            if( exitCode != 0 ) throw("Could not compare reference image.");
            
            var eq = 1.0 - Std.parseFloat( neko.io.File.getContent("/tmp/xinftest-diff") );
            
            
            // convert images to png
            neko.Sys.command("pnmtopng -compression 7 "+img+" > "+baseName+platform+".png");
            neko.Sys.command("pnmtopng -compression 7 "+diff+" > "+baseName+platform+"-diff.png");
            
            result( testNumber, testName, platform, eq>=targetEquality, ""+eq, expectFail, baseName+platform+".png" );
            return eq;
        } else {
            info(testName,platform,"reference "+ref+" no existe");

            /*
        } else {
            // copy as reference
            neko.Sys.command("cp "+img+" "+ref );
            neko.Sys.command("pnmtopng -compression 7 "+ref+" > "+baseName+"reference.png");
            
            result( testNumber, testName, platform, false, "reference image generated", true, baseName+"reference.png" );
            return -2.;
            */
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
