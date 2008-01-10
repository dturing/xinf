/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */

package xinf.test;

import xinf.ony.Model;
import xinf.ony.Element;
import xinf.ony.Group;
import xinf.ony.Rectangle;

import xinf.geom.Transform;

class TestModel extends haxe.unit.TestCase {

    public function testElement() {
        var e = X.rectangle();
        assertFalse( e==null );
        assertTrue( Std.is( e, Element ) );

        // assert XID association
        assertTrue( e == X.getByXid( e.xid ) );
    }

    public function testRectangle() {
        var e = X.rectangle();
        assertFalse( e==null );
        assertTrue( Std.is( e, Rectangle ) );
        
        assertEquals( 0., e.x );
        assertEquals( 0., e.y );
        assertEquals( 0., e.width );
        assertEquals( 0., e.height );
        
        e.x=10; e.y=20; e.width=30; e.height=40;
        assertEquals( 10., e.x );
        assertEquals( 20., e.y );
        assertEquals( 30., e.width );
        assertEquals( 40., e.height );
    }
    
    // helper
    function buildArrayFromIterator<T>( i:Iterator<T> ) :Array<T> {
        var a = new Array<T>();
        for( item in i ) {
            a.push(item);
        }
        return a;
    }
    
    public function testGroup() {
        var g = X.group();
        assertFalse( g==null );
        assertTrue( Std.is( g, Group ) );
        assertTrue( Std.is( g, Element ) );
        
        // assert no children
        assertEquals( 0, buildArrayFromIterator(g.children()).length );
        
        // add a child, assert children.length==1 and child's parent
        var o = X.rectangle();
        assertEquals( null, o.parent );
        g.attach(o);
        assertEquals( 1, buildArrayFromIterator(g.children()).length );
        assertEquals( g, o.parent );
 
        // assert the attached child is the one we attached
        for( item in g.children() ) {
            assertTrue( o==item );
        }
        
        // remove child, assert no children and child's parent being null
        g.detach(o);
        assertEquals( 0, buildArrayFromIterator(g.children()).length );
        assertEquals( null, o.parent );
        
        // add some new children, insert our known child between them
        var o2 = X.rectangle();
        g.attach( o2 );
        g.attach( X.rectangle() );
        g.attach( X.rectangle() );
        g.attach( o, o2 );
        
        // assert 4 children, and o at position 1
        var a = buildArrayFromIterator(g.children());
        assertEquals( 4, a.length );
        assertTrue( a[1] == o );
    }
    
    public function testTranslation() {
        var e = X.rectangle();
        var p = { x:23., y:42. };
        
        e.transform = new Translate( p.x, p.y );
        var q = e.globalToLocal( p );
        assertTrue( q.x==0 && q.y==0 );
        
        var q = e.localToGlobal( p );
        assertTrue( q.x==2*p.x && q.y==2*p.y );

        // now do the same transformation on a parent group, too
        var g = X.group();
        g.transform = new Translate( p.x, p.y );
        g.attach( e );

        var q = e.globalToLocal( p );
        assertEquals( -p.x, q.x );
        assertEquals( -p.y, q.y );
        
        var q = e.localToGlobal( p );
        assertEquals( 3*p.x, q.x );
        assertEquals( 3*p.y, q.y );
        
        // other kinds of transformations (scale, rotate, matrix, identity)
        // should be tested by TestGeometry.
        // we're just testing their integration into xinf.ony here,
        // for that, testing translation should be enough
    }
}

class Test {   
    static function main() {
        var runner = new haxe.unit.TestRunner();
        runner.add(new TestGeometry());
        runner.add(new TestModel());
        runner.run();
    }
}
