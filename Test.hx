import org.xinf.SDLPlayer;
import org.xinf.display.Stage;
import org.xinf.render.GLRenderer;
import org.xinf.geom.Point;
import org.xinf.demo.Square;
import org.xinf.demo.DrawTest;

class Test {
    static function main() {
        
        var renderer = new GLRenderer();

        var root = new Stage(renderer);
        var player = new SDLPlayer(root);

/*
        var s0 = new Square("zero",.0,.0,.0);
        root.addChild( s0 );
*/
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
            s0.addChild( new Square( angle+"�", p.x, p.y, -angle ) );
        }
        */

        /*
        // square grid
        
        var n:Int=2;
        for( x in -n...n+1 ) {
            for( y in -n...n+1 ) {
                s0.addChild( new Square( x+"/"+y, x/n, y/n, (Math.sin(x/n)*Math.cos(y/n))*360 ) );
            }
        }
        */
        
//        s0.addChild( new org.xinf.media.Video() );
        while( player.iterate() ) {
            // check for OpenGL errors
            var e:Int = GL.GetError();
            if( e > 0 ) {
                throw( "OpenGL error "+GLU.ErrorString(e) );
            }
            
            // FIXME: proper timing, neko idle func?
            neko.Sys.sleep(0.04);
            
        }
    }
}
