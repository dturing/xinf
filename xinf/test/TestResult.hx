/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	

package xinf.test;

enum TestResult {
    ReferenceTaken;
    Compared( difference:Float );
    Error( e:Dynamic );
}