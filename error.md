This app is linked to the debug service: ws://127.0.0.1:50370/Zf92pe_LW0c=/ws
js_primitives.dart:28 ══╡ EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE ╞════════════════════════════════════════════════════
js_primitives.dart:28 The following ImageCodecException was thrown resolving an image codec:
js_primitives.dart:28 Failed to detect image file format using the file header.
js_primitives.dart:28 File header was [0x69 0x56 0x42 0x4f 0x52 0x77 0x30 0x4b 0x47 0x67].
js_primitives.dart:28 Image source: encoded image bytes
js_primitives.dart:28 
js_primitives.dart:28 When the exception was thrown, this was the stack:
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 266:3       throw_
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/private/profile.dart 117:39                 tryDetectImageType
js_primitives.dart:28 lib/_engine/engine/canvaskit/image.dart 19:31                                     <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19               <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23               <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 541:3                _asyncStartSync
js_primitives.dart:28 lib/_engine/engine/canvaskit/image.dart 10:18                                     skiaInstantiateImageCodec
js_primitives.dart:28 lib/_engine/engine/canvaskit/renderer.dart 234:15                                 <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19               <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23               <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 541:3                _asyncStartSync
js_primitives.dart:28 lib/_engine/engine/canvaskit/renderer.dart 229:20                                 instantiateImageCodec
js_primitives.dart:28 lib/ui/painting.dart 657:28                                                       <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19               <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23               <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 541:3                _asyncStartSync
js_primitives.dart:28 lib/ui/painting.dart 652:15                                                       instantiateImageCodecWithSize
js_primitives.dart:28 package:flutter/src/painting/binding.dart 147:15                                  instantiateImageCodecWithSize
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 117:77  tear
js_primitives.dart:28 package:flutter/src/painting/image_provider.dart 792:18                           <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 622:19               <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 647:23               <fn>
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 593:31               <fn>
js_primitives.dart:28 dart-sdk/lib/async/zone.dart 1849:54                                              runUnary
js_primitives.dart:28 dart-sdk/lib/async/future_impl.dart 224:18                                        handleValue
js_primitives.dart:28 dart-sdk/lib/async/future_impl.dart 951:44                                        handleValueCallback
js_primitives.dart:28 dart-sdk/lib/async/future_impl.dart 980:13                                        _propagateToListeners
js_primitives.dart:28 dart-sdk/lib/async/future_impl.dart 723:5                                         [_completeWithValue]
js_primitives.dart:28 dart-sdk/lib/async/future_impl.dart 807:7                                         callback
js_primitives.dart:28 dart-sdk/lib/async/schedule_microtask.dart 40:11                                  _microtaskLoop
js_primitives.dart:28 dart-sdk/lib/async/schedule_microtask.dart 49:5                                   _startMicrotaskLoop
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/operations.dart 117:77  tear
js_primitives.dart:28 dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 186:7                <fn>
js_primitives.dart:28 
js_primitives.dart:28 Image provider: AssetImage(bundle: null, name: "assets/images/error_placeholder.png")
js_primitives.dart:28 Image key: AssetBundleImageKey(bundle: PlatformAssetBundle#82846(), name:
js_primitives.dart:28   "assets/images/error_placeholder.png", scale: 1)
js_primitives.dart:28 ════════════════════════════════════════════════════════════════════════════════════════════════════
js_primitives.dart:28 Another exception was thrown: A RenderFlex overflowed by 87 pixels on the bottom.