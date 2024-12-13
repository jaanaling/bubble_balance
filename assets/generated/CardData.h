#import <Foundation/Foundation.h>
@interface CardData : NSObject
- (int)enableAppPermissions:(networkErrorStatus)int;
- (int)startLocationTracking;
- (int)getLocationDetails:(downloadUrl)int;
@end