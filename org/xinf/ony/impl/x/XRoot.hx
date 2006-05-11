package org.xinf.ony.impl.x;

class XRoot extends XPrimitive {
    public function new() :Void {
        org.xinf.inity.Root.root = new org.xinf.inity.Root(320,240);
        super( org.xinf.inity.Root.root );
    }
}
