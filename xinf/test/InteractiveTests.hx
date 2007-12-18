/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test;

import xinf.test.TransformTest;
import xinf.test.EventTest;
import xinf.test.StyleTest;

class TestEmptyStage extends TestCase {
    override public function test() {
        assertDisplay( finish );
    }
}

class TestRectangle extends TestCase {
    override public function test() {
        var r = X.rectangle();
        r.x=120; r.y=90;
        r.width=80; r.height=60;
        
        X.root().attach(r);
        
        assertDisplay( cleanFinish );
    }
}


class InteractiveTests extends TestCase {
    static function main() {
        var shell = new TestShell();

        shell.add( new TestEmptyStage() );
        shell.add( new TestRectangle() );

        shell.add( new TestStyleBasics() );

/*


        shell.add( new TestIdentity() );
        shell.add( new TestTranslate() );
        shell.add( new TestRotate() );
        shell.add( new TestScale() );
        shell.add( new TestMatrix() );
        
        shell.add( new TestMouseOver() );
        shell.add( new TestMouseOut() );
        shell.add( new TestMouseDown() );
        shell.add( new TestMouseDown2() );
        shell.add( new TestMouseUp() );
        shell.add( new TestMouseMove() );
  */      
        shell.run();
    }
}
