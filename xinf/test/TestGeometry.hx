package xinf.test;

import xinf.geom.Types;
import xinf.geom.Transform;

class TestGeometry extends haxe.unit.TestCase {
    public function testIdentity() {
        var t = new Identity();
        assertEquals( 0., t.getTranslation().x );
        assertEquals( 0., t.getTranslation().y );
        assertEquals( 0., t.getScale().x );
        assertEquals( 0., t.getScale().y );
        assertEquals( 1., t.getMatrix().a );
        assertEquals( 0., t.getMatrix().b );
        assertEquals( 0., t.getMatrix().c );
        assertEquals( 1., t.getMatrix().d );
        assertEquals( 0., t.getMatrix().tx );
        assertEquals( 0., t.getMatrix().ty );
        
        var p = { x:23., y:42. };
        var q = t.apply(p);
        assertEquals( p.x, q.x );
        assertEquals( p.y, q.y );
        
        var q = t.applyInverse(p);
        assertEquals( p.x, q.x );
        assertEquals( p.y, q.y );
    }

    public function testTranslate() {
        var x = 23.; var y = 42.;
        var t = new Translate( x, y );
        assertEquals( x,  t.getTranslation().x );
        assertEquals( y,  t.getTranslation().y );
        assertEquals( 0., t.getScale().x );
        assertEquals( 0., t.getScale().y );
        assertEquals( 1., t.getMatrix().a );
        assertEquals( 0., t.getMatrix().b );
        assertEquals( 0., t.getMatrix().c );
        assertEquals( 1., t.getMatrix().d );
        assertEquals( x,  t.getMatrix().tx );
        assertEquals( y,  t.getMatrix().ty );
        
        var p = { x:10., y:10. };
        var q = t.apply(p);
        assertEquals( p.x+x, q.x );
        assertEquals( p.y+y, q.y );
        
        var q = t.applyInverse(p);
        assertEquals( p.x-x, q.x );
        assertEquals( p.y-y, q.y );
    }
}