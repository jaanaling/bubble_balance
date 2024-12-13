#import <Foundation/Foundation.h>
@interface DispatcherFactorySink : NSObject
- (int)trackErrorEvents;
- (int)sendAppStatusReport;
- (int)getAppFeedback;
@end