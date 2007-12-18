/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test;

import xinf.ony.Element;
import xinf.geom.Transform;
import xinf.geom.Matrix;

class TransformTest extends TestCase {
    override public function test() {
        var r = X.rectangle();
        
        r.x=120; r.y=90;
        r.width=80; r.height=60;
        
        X.root().attach(r);
        doTransform( r );
        
        assertDisplay( cleanFinish );
    }
    
    public function doTransform( e:Element ) {
    }
}

class TestIdentity extends TransformTest {
    override public function doTransform( e:Element ) {
        e.transform = new Identity();
    }
}

class TestTranslate extends TransformTest {
    override public function doTransform( e:Element ) {
        e.transform = new Translate( 80, 60 );
    }
}

class TestRotate extends TransformTest {
    public function new() {
        super();
        expectFailure("js");
    }
    override public function doTransform( e:Element ) {
        e.transform = new Rotate( Math.PI/8 );
    }
}

class TestScale extends TransformTest {
    public function new() {
        super();
        expectFailure("js");
    }
    override public function doTransform( e:Element ) {
        e.transform = new Scale( 1.5, 1.5 );
    }
}

class TestMatrix extends TransformTest {
    public function new() {
        super();
        expectFailure("js");
    }
    override public function doTransform( e:Element ) {
        e.transform = new Matrix().translate(-160,-120).scale(.5,.5).rotate(Math.PI/4).translate(160,120);
    }
}

