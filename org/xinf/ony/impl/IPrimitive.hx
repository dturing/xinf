package org.xinf.ony.impl;

interface IPrimitive {
    function setOwner( owner:org.xinf.event.EventDispatcher ) :Void;
    function applyStyle( style:org.xinf.style.Style ) :Void;
    function eventRegistered( type:String ) :Void;
}
