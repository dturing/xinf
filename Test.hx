import org.xinf.SDLPlayer;
import org.xinf.display.Stage;
import org.xinf.render.GLRenderer;
import org.xinf.demo.Square;

class Test {
    
    
    static function main() {
        var renderer = new GLRenderer();

        var root = new Stage(renderer);
        var player = new SDLPlayer(root);

        var s0 = new Square("zero",0.0,0.0);
        root.addChild( s0 );

        s0.addChild( new Square( "one", -.5, 0.0 ) );
        s0.addChild( new Square( "two", 0.0, .5 ) );
        s0.addChild( new Square( "three", .5, 0.0 ) );
        s0.addChild( new Square( "four", 0.0, -.5 ) );
    
        
        player.run();
    }
}
