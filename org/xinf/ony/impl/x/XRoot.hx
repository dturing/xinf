package org.xinf.ony.impl.x;

import org.xinf.ony.impl.IRootPrimitive;

class XRoot extends XPrimitive, implements IRootPrimitive {
    public function new() :Void {
        org.xinf.inity.Root.root = new org.xinf.inity.Root(320,240);
        super( org.xinf.inity.Root.root );
    }
    public function run() :Void {
        org.xinf.inity.Root.root.run();
    }
}
