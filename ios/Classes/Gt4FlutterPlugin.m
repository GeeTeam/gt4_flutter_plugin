#import "Gt4FlutterPlugin.h"
#if __has_include(<gt4_flutter_plugin/gt4_flutter_plugin-Swift.h>)
#import <gt4_flutter_plugin/gt4_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gt4_flutter_plugin-Swift.h"
#endif

@implementation Gt4FlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGt4FlutterPlugin registerWithRegistrar:registrar];
}
@end
