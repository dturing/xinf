
package xinf.ony;

import xinf.event.Event;
import xinf.event.EventKind;
import xinf.event.EventDispatcher;
import xinf.geom.Types;
import xinf.geom.Transform;
import xinf.style.ElementStyle;
import xinf.xml.Serializable;

interface Element implements EventDispatcher, implements Serializable {

    /** Unique (to the runtime environment) ID of this object. Will be set automatically, in the constructor. 
        Note that this has nothing to do with the SVG 'id' property (which is a String, while this is numeric) **/
    var xid(default,null):Int;

    /** textual (SVG) id **/
    var id(default,null):String;

    /** textual name (name attribute) **/
    var name(default,null):String;

    /** Other Object that contains this Object, if any. **/
    var parent(default,null):Group;

    /** Document that ultimately contains this Object **/
    var document(default,null):Document;

    /** the object's transformation **/
    var transform(default,set_transform):Transform;

    /** the element's style **/
    var style(default,null):ElementStyle;

    function styleChanged() :Void;

    /** read element data from xml */
    function fromXml( xml:Xml ) :Void;

    /** convert the given point from global to local coordinates **/
    function globalToLocal( p:TPoint ) :TPoint;
    
    /** convert the given point from local to global coordinates **/
    function localToGlobal( p:TPoint ) :TPoint;

    /** hook to do something when attached to a parent Group **/
    function attachedTo( p:Group ) :Void;

    /** hook to do something when detached from a parent Group **/
    function detachedFrom( p:Group ) :Void;

    function addEventListener<T>( type :EventKind<T>, h :T->Void ) :T->Void;
    function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool;
    /** dispatch the given event to registered listeners **/
    function dispatchEvent<T>( e : Event<T> ) :Void;
    function postEvent<T>( e : Event<T>, ?pos:haxe.PosInfos ) :Void;
    
}
