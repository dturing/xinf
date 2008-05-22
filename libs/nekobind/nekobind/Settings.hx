/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package nekobind;
import nekobind.type.TypeRep;

class Settings implements Dynamic<String> {
	public var argTypes:Hash<TypeRep>;
	public var isStatic:Bool;
	public function new() {
		argTypes = new Hash<TypeRep>();
		isStatic = false;
	}
}
