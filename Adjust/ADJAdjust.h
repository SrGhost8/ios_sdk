//
//  ADJAdjust.h
//  Adjust
//
//  Created by Aditi Agrawal on 04/07/22.
//

#import <Foundation/Foundation.h>


@class ADJAdjustConfig;
@class ADJAdjustEvent;
@class ADJAdjustAdRevenue;
@class ADJAdjustPushToken;
@class ADJAdjustLaunchedDeeplink;
@class ADJAdjustBillingSubscription;
@class ADJAdjustThirdPartySharing;
@protocol ADJAdjustAttributionCallback;
@protocol ADJAdjustDeviceIdsCallback;


@interface ADJAdjust : NSObject

// instantiation
- (nullable instancetype)init NS_UNAVAILABLE;

// public api
+ (void)sdkInitWithAdjustConfig:(nonnull ADJAdjustConfig *)adjustConfig;

+ (void)trackEvent:(nonnull ADJAdjustEvent *)adjustEvent;

+ (void)trackAdRevenue:(nonnull ADJAdjustAdRevenue *)adjustAdRevenue;

+ (void)trackPushToken:(nonnull ADJAdjustPushToken *)adjustPushToken;

+ (void)trackLaunchedDeeplink:(nonnull ADJAdjustLaunchedDeeplink *)adjustLaunchedDeeplink;

+ (void)trackBillingSubscription:(nonnull ADJAdjustBillingSubscription *)adjustBillingSubscription;

+ (void)trackThirdPartySharing:(nonnull ADJAdjustThirdPartySharing *)adjustThirdPartySharing;

+ (void)adjustAttributionWithCallback:(nonnull id<ADJAdjustAttributionCallback>)adjustAttributionCallback;

+ (void)deviceIdsWithCallback:(nonnull id<ADJAdjustDeviceIdsCallback>)adjustDeviceIdsCallback;

+ (void)gdprForgetDevice;

+ (void)inactivateSdk;
+ (void)reactivateSdk;

+ (void)switchToOfflineMode;
+ (void)switchBackToOnlineMode;

+ (void)appWentToTheForegroundManualCall;
+ (void)appWentToTheBackgroundManualCall;

+ (void)addGlobalCallbackParameterWithKey:(nonnull NSString *)key
                                    value:(nonnull NSString *)value;
+ (void)removeGlobalCallbackParameterByKey:(nonnull NSString *)key;
+ (void)clearAllGlobalCallbackParameters;

+ (void)addGlobalPartnerParameterWithKey:(nonnull NSString *)key
                                    value:(nonnull NSString *)value;
+ (void)removeGlobalPartnerParameterByKey:(nonnull NSString *)key;
+ (void)clearAllGlobalPartnerParameters;

@end
