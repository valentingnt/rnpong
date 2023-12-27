#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(CustomHapticsModule, NSObject)

RCT_EXTERN_METHOD(CustomHapticsFunction:(float)x y:(float)y)

@end