YYKit
==========
YYKit contains some utilities that I use in my project.

## Documentation

You can build and install docset use `Docset` scheme.
Or your can read the [Documentation](http://github.ibireme.com/yykit/doc/) online.


## How to use

1. Build this project and you will get `YYKit.framework`.

2. Add `YYKit.framework` to your project,
then add `-ObjC` to your project's `Other Compiler Flags`

3. Add required frameworks:

	 * UIKit.framework
	 * CoreGraphics.framework
	 * CoreImage.framework
	 * QuartzCore.framework
	 * libz.dylib

(Optional) Add `YYKit.framework` to your .pch file.


- - -

I knew too many categories are not good for an app, but I'm lazy :-)
