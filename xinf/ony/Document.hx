
package xinf.ony;

import xinf.style.StyleSheet;
import xinf.style.ElementStyle;

interface Document implements Group {

    var x(default,set_x):Float;
    var y(default,set_y):Float;
    var width(default,set_width):Float;
    var height(default,set_height):Float;

    var styleSheet(default,null):StyleSheet<ElementStyle>;
    function getElementById( id:String ) :Element;
    function getTypedElementById<T>( id:String, cl:Class<T> ) :T;
    
    function unmarshal( xml:Xml, ?parent:Group ) :Element;

	static function load( url:String, ?onLoad:Document->Void ) :Document;
	static function instantiate( data:String, ?onLoad:Document->Void ) :Document;
}