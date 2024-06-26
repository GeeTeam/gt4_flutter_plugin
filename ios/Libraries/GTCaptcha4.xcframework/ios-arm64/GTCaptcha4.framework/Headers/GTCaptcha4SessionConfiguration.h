//
//  GTCaptcha4SessionConfiguration.h
//  GTCaptcha4
//
//  Created by NikoXu on 2020/9/30.
//  Copyright © 2020 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 验证界面样式(User interface style)
typedef NS_ENUM(NSInteger, GTC4UserInterfaceStyle) {
    /** 跟随系统样式(Follow system) */
    GTC4UserInterfaceStyleSystem = 0,
    /** 普通样式(Light) */
    GTC4UserInterfaceStyleLight,
    /** 暗黑样式(Dark) */
    GTC4UserInterfaceStyleDark,
    /** 默认样式(Default) */
    GTC4UserInterfaceStyleDefault = GTC4UserInterfaceStyleLight
};

/// 验证会话配置(Captcha session configuration)
@interface GTCaptcha4SessionConfiguration : NSObject <NSCoding>

/// 静态资源文件的路径, 默认为空。
/// 如果为远程文件，则应为完成路径。
/// 如果为本地文件，则应为文件所在路径（不包含文件）。
/// The path of static resources, which is empty by default.
@property (nullable, nonatomic, strong) NSString *resourcePath;
/// 远程访问静态资源时的协议，默认 @“https”。
/// Protocol for remote access to static resources, default is @ “https”.
@property (nullable, nonatomic, strong) NSString *protocol;
/// 静态服务地址，默认为空。
@property (nullable, nonatomic, strong) NSArray<NSString *> *staticServers;
/// 接口服务地址，默认为空。
@property (nullable, nonatomic, strong) NSArray<NSString *> *apiServers;

/// 界面和状态栏样式，默认 `GTC4UserInterfaceStyleLight`。
/// User interface and statusBar style, which is white by default.
@property (nonatomic, assign) GTC4UserInterfaceStyle userInterfaceStyle;

/// 背景颜色，默认透明
/// Defines color for captcha background. Default is transparent.
@property (nonatomic, strong) UIColor *backgroundColor;

/// 调试模式开关，默认关闭。
/// Determines whether the debug information is shown on background,
/// which is disable by default.
@property (nonatomic, assign) BOOL debugEnable;
/// 点击背景的交互，默认开启。
/// Determines whether the background is able to interact,
/// which is disable by default.
@property (nonatomic, assign) BOOL backgroundUserInteractionEnable;
/// 请求超时时长，默认 8 秒。
/// The timeout of each request. Default is 8.0s.
@property (nonatomic, assign) NSTimeInterval timeout;
/// 语言，默认跟随系统。
/// 如果系统为不支持的语言，则为中文简体。
/// 指定语言请参考文档中的语言短码清单（ISO 639-2 标准）。
/// Defines Language for captcha, which is same as system language by default.
/// Display in English, if not supported.
/// Please refer to the language short code(ISO 639-2 standard) for setting the language.
@property (nonatomic, strong) NSString *language;

/// 支持的横竖屏方向。
/// The supported interface orientations.
@property (assign, nonatomic) UIInterfaceOrientationMask supportedInterfaceOrientations;

/// 额外的参数, 默认为空。参数将被组装后提交到验证服务。
/// Additional parameter, which is empty by default.
/// Parameters will be assembled and submitted to the captcha server.
@property (nullable, nonatomic, strong) NSMutableDictionary *additionalParameter;

/// 获得一个默认配置
/// Get a default configuration.
+ (GTCaptcha4SessionConfiguration *)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
