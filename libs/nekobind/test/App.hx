/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package test;

class TestNekobind extends haxe.unit.TestCase {
	var tester:Tester;
	public function new( t:Tester ) {
		super();
		tester = t;
	}
		
	function testInt() {
		assertEquals( 23, tester.testInt(23) );
		// trying a float instead of an int will fail during compilation (haxe typechecking)
		//assertEquals( 23, tester.testInt(23.42) ); // FAILS
	}
	function testFloat() {
		assertEquals( 23.42, tester.testFloat(23.42) );
		// ints instead of floats are accepted.
		assertEquals( 23.00, tester.testFloat(23) );
	}
	function testBool() {
		assertTrue ( tester.testBool(true) );
		assertFalse( tester.testBool(false) );
	}
	function testString() {
		var string = "Hello, World!";
		var s = untyped string.__s;
		assertEquals( s, tester.testString(s) );
		
		// nekobind-bound functions take both pure neko strings or haxe string classes,
		// but return only pure neko strings. *mostly* that is fine for haxe, but not always.
		assertEquals( s, tester.testString(string) );
		assertEquals( string, new String(tester.testString(s)) );
		
		// notably, comparison doesnt work. let's assure this.
		assertFalse( string == tester.testString(string) );
	}
	function testOrder() {
		assertEquals( 23, tester.testOrder("foo",23,"bar","baz") );
	}
	function testMany() {
		var r:Int = tester.testMany(1,2,3,4,5,6);
		assertEquals( 21, r );
		// this fails: see neko mailing list
		// assertEquals( 21, (tester.testMany(1,2,3,4,5,6)) );
	}
	function testVoid() {
		// void cannot really be tested, but the function should at least be callable
		tester.testVoid();
		assertTrue(true);
	}
	function testPointer() {
		var cp = cptr.CPtr.int_alloc( 5 );
		cptr.CPtr.int_set( cp, 2, 23 );
		assertEquals( 23, tester.testPointer( cp ) );
		
		try {
			// let's allocate a cptr that is too small (19 chars are too little for 5 ints)
			var cp = cptr.CPtr.char_alloc( 19 );
			// should throw an exception
			tester.testPointer( cp );
			// shouldn't get here
			assertTrue(false);
		} catch( e:Dynamic ) {
			// instead, the exception should be caught here.
			assertTrue(true);
		}
	}
	function testDynamic() {
		assertEquals( "foo", tester.testDynamic("foo") );
		var a = { a:23, b:42.1 };
		assertEquals( a, tester.testDynamic(a) );
	}
	function testObject() {
		var o = tester.testObject( {foo:untyped "foo".__s,bar:23} );
		assertEquals( "foo", new String(o.bar) );
		assertEquals( 23, o.foo );
	}
	function testCGlobal() {
		assertEquals( 23, Tester.CONST_GLOBAL_TEST );
	}
}

class App {
	public static function main() :Void {
		var t = Tester.construct();
		var r = new haxe.unit.TestRunner();
		r.add( new TestNekobind( t ) );
		r.run();
		t=null;
	}
}