
package xinf.ony;

import xinf.style.StyleSheet;

interface Document implements Group {

    var styleSheet(default,null):StyleSheet;
    function getElementById( id:String ) :Element;
    
    function unmarshal( xml:Xml ) :Element;

}