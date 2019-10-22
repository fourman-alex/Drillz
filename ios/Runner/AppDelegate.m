#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <StoreKit/StoreKit.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"drillz.com/rate"
                                          binaryMessenger:controller];

  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([call.method isEqualToString:@"requestReview"]) {
      [SKStoreReviewController requestReview];
      result(nil);
    }
    else if([call.method isEqualToString:@"canRequestReview"]) {
      if (@available(iOS 10.3, *)) {
        result([NSNumber numberWithBool:YES]);
      }
      else {
        result([NSNumber numberWithBool:NO]);
      }
    }
    else if([call.method isEqualToString:@"launchStore"]) {
      NSString *appId = call.arguments[@"appId"];

      if (appId == (NSString *)[NSNull null]) {
          result([FlutterError errorWithCode:@"ERROR" message:@"App id cannot be null" details:nil]);
      }
      else if ([appId length] == 0) {
          result([FlutterError errorWithCode:@"ERROR" message:@"Empty app id" details:nil]);
      }
      else {
        NSString *iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", appId];
        NSURL* itunesURL = [NSURL URLWithString:iTunesLink];
        if ([[UIApplication sharedApplication] canOpenURL:itunesURL]) {
          [[UIApplication sharedApplication] openURL:itunesURL];
        }
      }

      result(nil);
    }
    else {
      result(FlutterMethodNotImplemented);
    }  }];

  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
