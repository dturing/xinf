package org.xinf.ony.impl;

import org.xinf.geom.Point;

interface IRootPrimitive implements IPrimitive {
    function setOwner( owner:org.xinf.event.EventDispatcher ) :Void;
    function addChild( child:IPrimitive ) :Void;
    function removeChild( child:IPrimitive ) :Void;
    function setBounds( bounds:org.xinf.ony.Bounds ) :Void;
    function setStyle( style:org.xinf.style.Style ) :Void;
    function eventRegistered( type:String ) :Void;
    
    function run() :Void;
}
