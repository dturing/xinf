import org.xinf.SDLPlayer;
import org.xinf.display.Stage;
import org.xinf.render.GLRenderer;
import org.xinf.demo.Square;
import org.xinf.geom.Point;

class Test {
    
    
    static function main() {
        var renderer = new GLRenderer();

        var root = new Stage(renderer);
        var player = new SDLPlayer(root);

        var s0 = new Square("zero",.0,.0,.0);
        root.addChild( s0 );
/*
        s0.addChild( new Square( "one", -.5, 0.0 ) );
        s0.addChild( new Square( "two", 0.0, .5 ) );
        s0.addChild( new Square( "three", .5, 0.0 ) );
        s0.addChild( new Square( "four", 0.0, -.5 ) );
*/    
        var p:Point;
        /*
        var n:Int = 180;
        for( a in 0...n ) {
            var rad =  (a/(n/2))*Math.PI;
            var angle = (rad/Math.PI)*180;
            p = Point.polar( .5, rad );
            s0.addChild( new Square( angle+"°", p.x, p.y, -angle ) );
        }
        */
        
        var n:Int=5;
        for( x in -n...n ) {
            for( y in -n...n ) {
                s0.addChild( new Square( x+"/"+y, x/n, y/n, .0 ) );
            }
        }
    
        
        player.run();
    }
}
