
package opengl;

/**
    OpenGL helpers and workarounds.
**/
class Helper {

    public static function getBools( pname:Int, interest:Int ) :Array<Bool> {
        return untyped _getBool( pname, interest );
    }
    public static function getBool( pname:Int ) :Bool {
        return untyped _getBool( pname, 1 );
    }

    public static function getInts( pname:Int, interest:Int ) :Dynamic {
        return ( _getInt( pname, interest ) );
    }
    public static function getInt( pname:Int ) :Int {
        return untyped _getInt( pname, 1 );
    }

    public static function getFloats( pname:Int, interest:Int ) :Dynamic {
        return ( _getFloat( pname, interest ) );
    }
    public static function getFloat( pname:Int ) :Float {
        return untyped _getFloat( pname, 1 );
    }

    public static function getDoubles( pname:Int, interest:Int ) :Dynamic {
        return ( _getDouble( pname, interest ) );
    }
    public static function getDouble( pname:Int ) :Float {
        return untyped _getDouble( pname, 1 );
    }

    private static var _getBool;
    private static var _getInt;
    private static var _getFloat;
    private static var _getDouble;
    private static var _evaluateCubicBezier;
    private static var _evaluateQuadraticBezier;
    
    public static function __init__() : Void {
        DLLLoader.addLibToPath("opengl");

        _getBool = neko.Lib.load("opengl","opengl_get_bool", 2 );
        _getInt = neko.Lib.load("opengl","opengl_get_int", 2 );
        _getFloat = neko.Lib.load("opengl","opengl_get_float", 2 );
        _getDouble = neko.Lib.load("opengl","opengl_get_double", 2 );

    }
}
