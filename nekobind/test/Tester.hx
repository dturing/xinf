
package test;

/**
	A class testing various nekobind features.
	
	<nekobind 
		translator="CamelCaseToMinuscleUnderscore"
		prefix="tester_"
		nekoAbstract="_t"
		cStruct="tester"
		dtor="destruct"
		module="tester"
		globalFinderPrefix="TESTER_"
		globalFinderCCFlags="-Itest/"
		/>
	<nekobind:cHeader>
		#include "tester.h"
	</nekobind:cHeader>
	
	TODO:
		* global functions (all statics are such!)
		* test static, maybe remove/cleanup ctor stuff
		* test: allocation/gc, keep global counter
		
		* automatic arrayization or objectization for >4 args?
		* getters/setters, with functions and public struct members.
		* references to other abstract types in the same library (think cairo)
		* enums (think cairo)
		* inheritance (think gobject)
		* test multiple constructors
		* maybe an argument flag to free some allocated string (glib)..
		* remove new()?

	DONE:
		* cptr handling, min-size checking
		* String handling (done? - hx Strings can be passed to nekobind-libs, but return is always neko string)

**/

extern class Tester extends haxe.unit.TestCase {
	public static var CONST_GLOBAL_TEST:Int;
	
	/** <nekobind ctor="true"/> **/
	public static function construct() :Tester;
	
	public function testInt( v:Int ) :Int;
	public function testFloat( v:Float ) :Float;
	public function testString( v:String ) :String;
	public function testBool( v:Bool ) :Bool;
	public function testOrder( a:String, b:Int, c:String, d:String) :Int; // returns b
	public function testMany( a1:Int, a2:Int, a3:Int, a4:Int, a5:Int, a6:Int ) :Int;
	
	public function testVoid() :Void;
	public function testDynamic( v:Dynamic ) :Dynamic; 
	public function testObject( o:{foo:String,bar:Int} ) : {foo:Int,bar:String};
	
	/** <nekobind>
		<cptr name="ptr" type="int" min-size="5"/>
	</nekobind>**/
	public function testPointer( ptr:Dynamic ) :Int;
	
	
    public static function __init__() : Void {
        untyped {
        	var loader = untyped __dollar__loader;
            Tester = loader.loadmodule("tester".__s,loader).Tester__impl;
        }
    }
}
