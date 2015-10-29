YYKit
==============

YYKit is a collection of iOS component.

It's so huge that I split it into several independent components:

* [YYModel](https://github.com/ibireme/YYModel) — High performance model framework for iOS.
* [YYCache](https://github.com/ibireme/YYCache) — High performance cache framework for iOS.
* [YYImage](https://github.com/ibireme/YYImage) — Image framework for iOS to display/encode/decode animated WebP, APNG, GIF, and more.
* YYText — Powerful rich text component for iOS.
* 
* YYKeyboardManager — iOS keyboard manager.
* YYDispatchQueuePool — iOS queue pool  manager.
* YYAsyncLayer — CALayer subclass for asynchronous rendering and display.
* [YYCategories](https://github.com/ibireme/YYKeyboardManager) — A set of useful categories for Foundation and UIKit.

All these components support iOS 6.0 and later.


<br/>
---
中文介绍
==============

YYKit 是一组功能丰富的 iOS 组件，用于构建大型、复杂的 iOS 应用。

这个项目起源于 13 年我还在人人的时候对人人网的一些基础 Category 工具的整理。但随后我在里面更改和添加了大量其他组件，以至于这个项目的代码迅速膨胀了起来。这个项目目前是作为我在公司项目的技术预研而存在，当其中某些组件足够成熟时，我便会将其投入到公司项目的生产环境中去。

为了尽量复用代码，这个项目中的某些组件之间有比较强的依赖关系。为了方便其他开发者使用，我从中拆分出以下独立组件 (某些组件还在补充文档中，暂时没有开源)：

* [YYModel](https://github.com/ibireme/YYModel) — 高性能的 iOS JSON 模型框架。
* [YYCache](https://github.com/ibireme/YYCache) — 高性能的 iOS 缓存框架。
* [YYImage](https://github.com/ibireme/YYImage) — 功能强大的 iOS 图像框架。
* YYWebImage — 高性能的 iOS 异步图像加载框架。
* YYText — 功能强大的 iOS 富文本框架。
* 
* YYKeyboardManager — iOS 键盘监听管理工具。
* YYDispatchQueuePool — iOS 全局并发队列管理工具。
* YYAsyncLayer — iOS 异步绘制与显示的工具。
* [YYCategories](https://github.com/ibireme/YYKeyboardManager) — 功能丰富的 Category 类型工具库。

以上类库全部都兼容 iOS 6 ~ 9，所有文件都有详尽文档注释。


以下是一些功能预览：

###复杂的列表视图 (微博/Twitter 内嵌富文本控件、网络图像加载)
<img src="https://raw.github.com/ibireme/YYKit/master/DemoSnapshot/IMG_2376.PNG" width="320"> <img src="https://raw.github.com/ibireme/YYKit/master/DemoSnapshot/IMG_2375.PNG" width="320">



###富文本输入、静态/动态表情显示、自定义键盘、图文混排、竖排版
<img src="https://raw.github.com/ibireme/YYKit/master/DemoSnapshot/IMG_2380.PNG" width="320"> <img src="https://raw.github.com/ibireme/YYKit/master/DemoSnapshot/IMG_2382.PNG" width="320"> <img src="https://raw.github.com/ibireme/YYKit/master/DemoSnapshot/IMG_2383.PNG" width="320">



###渐进式网络/本地图片加载
<img src="https://raw.github.com/ibireme/YYKit/master/DemoSnapshot/web.gif" width="320">



###GIF/WebP/APNG 动图播放
<img src="https://raw.github.com/ibireme/YYKit/master/DemoSnapshot/image.gif" width="320">



###高性能的异步绘制组件，即使在 iPhone 4S 或 iPad 3 上也能保持 60 fps 的流畅交互
<img src="https://raw.github.com/ibireme/YYKit/master/DemoSnapshot/scroll.gif" width="320">