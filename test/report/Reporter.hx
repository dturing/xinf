class Reporter {
    private static var testDir="../results";
    private static var refDir="../reference";
    private static var runtimes = ["fp","js","neko"];
    
    static function main() {
        var resultImages = neko.FileSystem.readDir( testDir );
        var results:Dynamic = { 
                runDate:Date.now().toString(),
                tests:new Array<Dynamic>()
            }
        
        var tests = new Array<String>();
        for( i in resultImages ) {
            var j = i.split(":");
            var test = j[0]+":"+j[1];
            tests.remove( test ); // if it exists...
            tests.push( test );
        }
        
        for( test in tests ) {
            var ref:String = refDir+"/"+test+".pnm";
            var imgs = new Array<String>();
            for( runtime in runtimes ) {
                var img = testDir+"/"+test+":"+runtime+".pnm";
                if( !neko.FileSystem.exists(img) ) {
                    throw("result image "+img+" doesn't exist.");
                }
                imgs.push( img );
            }
            if( !neko.FileSystem.exists(ref) ) {
                trace("Warning: Reference image for "+test+" does not exists, creating.");
                neko.Sys.command("cp "+imgs[0]+" "+ref );
                neko.Sys.command("cat "+ref+" | pnmtopng > "+refDir+"/"+test+".png 2>/dev/null" );
            }
            
            // TODO: target equality is defined in test...
            var runtimeResults = { name:test, targetEq:1000 };
            for( runtime in runtimes ) {
                var img = testDir+"/"+test+":"+runtime+".pnm";
                var diff = testDir+"/"+test+":"+runtime+".diff.pnm";

                // compare
                neko.Sys.command("pamarith -difference "+img+" "+ref+" > "+diff );
                neko.Sys.command("pamsumm -mean -normalize -brief "+diff+" > /tmp/xinftest-diff");
                var eq = 1.0 - Std.parseFloat( neko.File.getContent("/tmp/xinftest-diff") );
                eq *= 1000;
                
                // convert image and diff image to png
                var png = testDir+"/"+test+":"+runtime+".png";
                var pngdiff = testDir+"/"+test+":"+runtime+".diff.png";
                neko.Sys.command("cat "+img+" | pnmtopng > "+png+" 2>/dev/null" );
                neko.Sys.command("cat "+diff+" | pnmtopng > "+pngdiff+" 2>/dev/null" );
                
                Reflect.setField( runtimeResults, runtime, eq );
            }
            results.tests.push( runtimeResults );
        }
        
        var t = new haxe.Template( Std.resource("report.html") );
        var f = neko.File.write( "report.html", false );
        f.write( t.execute( results ) );
        f.close();
    }
}
