
package xinf.test;

enum TestResult {
    ReferenceTaken;
    Compared( difference:Float );
    Error( e:Dynamic );
}