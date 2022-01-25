// Copyright 2015-present 650 Industries. All rights reserved.
#import "EXDevMenuBuildInfo.h"

@implementation EXDevMenuBuildInfo

// TODO -- EXManifest - use actual interface
//- (nullable NSString *)sdkVersion;
//- (NSString *)bundleUrl;
//- (nullable NSString *)revisionId;
//- (nullable NSString *)slug;
//- (nullable NSString *)appKey;
//- (nullable NSString *)name;
//- (nullable NSString *)version;
//- (nullable NSDictionary *)notificationPreferences;
//- (nullable NSDictionary *)updatesInfo;
//- (nullable NSDictionary *)iosConfig;
//- (nullable NSString *)hostUri;
//- (nullable NSString *)orientation;
//- (nullable NSDictionary *)experiments;
//- (nullable NSDictionary *)developer;
//- (nullable NSString *)facebookAppId;
//- (nullable NSString *)facebookApplicationName;
//- (BOOL)facebookAutoInitEnabled;

+(NSDictionary *)getBuildInfoForBridge:(RCTBridge *)bridge andManifest:(NSDictionary *)manifest
{
  NSMutableDictionary *buildInfo = [NSMutableDictionary new];

  NSString *appIcon = [EXDevMenuBuildInfo getAppIcon];
  NSString *runtimeVersion = [EXDevMenuBuildInfo getUpdatesConfigForKey:@"EXUpdatesRuntimeVersion"];
  NSString *sdkVersion = [EXDevMenuBuildInfo getUpdatesConfigForKey:@"EXUpdatesSDKVersion"];
  NSString *appVersion = [EXDevMenuBuildInfo getFormattedAppVersion];
  NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"] ?: [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleExecutable"];
  NSString *hostUrl = [bridge.bundleURL host] ?: @"";

  if (manifest[@"name"] != nil) {
    appName = manifest[@"name"];
  }
  
  if (manifest[@"version"] != nil) {
    appVersion = manifest[@"version"];
  }

  buildInfo[@"appName"] = appName;
  buildInfo[@"appIcon"] = appIcon;
  buildInfo[@"appVersion"] = appVersion;
  buildInfo[@"runtimeVersion"] = runtimeVersion;
  buildInfo[@"sdkVersion"] = sdkVersion;
  buildInfo[@"hostUrl"] = hostUrl;

  return buildInfo;
}

+(NSString *)getAppIcon
{
  NSString *appIcon = @"";
  NSString *appIconName = [[[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]  lastObject];
  
  if (appIconName != nil) {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *appIconPath = [[resourcePath stringByAppendingString:appIconName] stringByAppendingString:@".png"];
    appIcon = [@"file://" stringByAppendingString:appIconPath];
  }
  
  return appIcon;
}

+(NSString *)getUpdatesConfigForKey:(NSString *)key
{
  NSString *value = @"";
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Expo" ofType:@"plist"];
  
  if (path != nil) {
    NSDictionary *expoConfig = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (expoConfig != nil) {
      value = [expoConfig objectForKey:key] ?: @"";
    }
  }

  return value;
}

+(NSString *)getFormattedAppVersion
{
  NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  NSString *buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
  NSString *appVersion = [NSString stringWithFormat:@"%@ (%@)", shortVersion, buildVersion];
  return appVersion;
}

@end
