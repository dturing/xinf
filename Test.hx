import org.xinf.SDLPlayer;
import org.xinf.display.Stage;
import org.xinf.geom.Point;
import org.xinf.demo.Square;
import org.xinf.demo.DrawTest;
import org.xinf.media.Video;

class Test {
    static function main() {
        
        var player = new SDLPlayer(320,240);
        var root = player.root;
        
        var s0 = new Square("zero",160,120,10,10,.0,0xffee33);
        root.addChild( s0 );

//        var vid = new Video();
//        root.addChild( vid );

        
        var test = new DrawTest();
        root.addChild( test );
    
        var p:Point;
                
        /* 
        // circle of squares
        var n:Int = 180;
        for( a in 0...n ) {
            var rad =  (a/(n/2))*Math.PI;
            var angle = (rad/Math.PI)*180;
            p = Point.polar( .5, rad );
            s0.addChild( new Square( angle+"°", p.x, p.y, -angle ) );
        }
        */

        
        // square grid
        
        var n:Int=10;
        for( x in -n...n ) {
            for( y in -n...n ) {
                s0.addChild( new Square( x+"/"+y, (x/n)*320, (y/n)*240, 31, 23, 0, 0x888888 ) );
                //, (Math.sin(x/n)*Math.cos(y/n))*360 ) );
            }
        }
        
        
        gst.Object._init();
                
//        vid.start();
                
        while( player.iterate() ) {
            // check for OpenGL errors
            var e:Int = GL.GetError();
            if( e > 0 ) {
                throw( "OpenGL error "+GLU.ErrorString(e) );
            }
            
            // FIXME: proper timing, neko idle func?
            neko.Sys.sleep(0.02);
            
        }
    }
}
