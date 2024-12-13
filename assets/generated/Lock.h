#import <Foundation/Foundation.h>
@interface Lock : NSObject
- (int)trackScreenViews:(currentPage)int int:(isSyncComplete)int;
- (void)trackAppNotifications:(surveyErrorMessageDetails)int int:(surveyResponseTime)int;
- (void)endAnalyticsSession:(itemQuality)int;
- (int)getProgressStatus:(currentStep)int int:(taskList)int;
- (void)clearUserStatusReport;
- (int)trackUserActivity:(isEntityOnline)int int:(isTaskCompleted)int;
- (int)resetAppPermissions:(surveyFeedbackReviewTime)int int:(deviceNetworkType)int;
- (void)clearCache:(itemCategory)int;
- (int)resetUserActivityData:(isSurveyEnabled)int int:(appDataStatus)int;
- (void)trackUserMessagesInteraction;
- (int)clearScreenVisitStats:(gpsLocationAccuracy)int int:(apiEndpoint)int;
- (int)saveAppVersion:(selectedItem)int;
- (int)checkBatteryLevel;
- (int)logAppNotification:(surveyCompletionFailureMessageText)int int:(fileTransferError)int;
@end