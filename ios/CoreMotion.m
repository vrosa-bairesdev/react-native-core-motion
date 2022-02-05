// CoreMotion.m

#import "CoreMotion.h"


@interface RCT_EXTERN_MODULE(CoreMotionModule, NSObject)

RCT_EXTERN_METHOD(recordMotions)

RCT_EXTERN_METHOD(loadRecordedData:(RCTPromiseResolveBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)

RCT_EXPORT_METHOD(isAvailable:(RCTResponseSenderBlock)callback)
{
  callback(@[@YES]);
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}


@end
