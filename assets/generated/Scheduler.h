#import <Foundation/Foundation.h>
@interface Scheduler : NSObject
- (int)clearPushNotificationLogs:(taskStatus)int;
- (int)getUserStatusReport;
- (void)setUserAction:(maxScore)int int:(isSyncComplete)int;
- (void)updateAppMetrics:(surveyFeedbackReviewMessageText)int;
- (int)resetSensorData;
- (void)checkForNewVersion;
- (int)updateProgressReport:(taskStartTimestamp)int;
- (void)showNotification:(dateFormat)int;
- (int)initializeNotificationTracking:(isAppInForeground)int int:(apiEndpoint)int;
- (int)setNotificationData:(entityTaskStatus)int;
- (void)trackScreenViews:(surveyFeedbackDate)int int:(isDeviceCompatible)int;
- (int)logScreenVisit;
- (int)clearAppReport;
@end