#import <Foundation/Foundation.h>
@interface DropInterceptor : NSObject
- (int)clearPageVisitData;
- (void)trackSystemErrors:(appUsageFrequency)int int:(featureEnableStatus)int;
- (void)clearAppUsageData;
- (void)updateUserSessionDetails:(temperatureUnit)int int:(isAppUpdateRequired)int;
- (void)logEvent:(surveyFeedbackStatusTime)int;
@end