[YYKit](https://github.com/ibireme/YYKit)
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/YYKit/master/LICENSE)&nbsp;
[![Cocoapods](http://img.shields.io/cocoapods/v/YYKit.svg?style=flat)](http://cocoapods.org/?q=YYKit)&nbsp;
[![Cocoapods](http://img.shields.io/cocoapods/p/YYKit.svg?style=flat)](http://cocoapods.org/?q=YYKit)&nbsp;
[![Build Status](https://api.travis-ci.org/ibireme/YYKit.svg)](https://travis-ci.org/ibireme/YYKit)&nbsp;

YYKit contains some utilities that I used in my project.


Documentation
==============

You can build and install docset use `Docset` scheme in Xcode, `appledoc` need to be pre-installed. 
Or your can read the [Documentation](http://github.ibireme.com/yykit/doc/) online.


Installation
==============

* Download YYKit source code.
* Select `YYKit` scheme, and run `Archive` in Xcode, you will get `YYKit.framework`.
* Drag the `YYKit.framwork` to your project and linked the required Frameworks below.
* Add `-ObjC` to your project's `Other Linker Flags`.
* Import `<YYKit/YYKit.h>` as you need.

* (You can also search and install `YYKit` with cocoapods)


Require Frameworks
==============
    UIKit.framework
    QuartzCore.framework
    CoreGraphics.framework
    CoreImage.framework
    CoreText.framework
    ImageIO.framework
    Accelerate.framework
    Security.framework
    MobileCoreServices.framework
    libz.dylib

About
==============
This library support iOS 6.0 and later.

I want to use my API as if it was provided by system, so I don't add prefix in
these categories. I know this is not good, so if you just need some pieces of code
in this project, pick them out and don't import the whole library.
