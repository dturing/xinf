package org.xinf.ony.impl;

interface IPrimitive {
    function setOwner( owner:org.xinf.event.EventDispatcher ) :Void;
    function addChild( child:IPrimitive ) :Void;
    function removeChild( child:IPrimitive ) :Void;
    function applyBounds( bounds:org.xinf.ony.Bounds ) :Void;
    function applyStyle( style:org.xinf.style.Style ) :Void;
    function eventRegistered( type:String ) :Void;
}
