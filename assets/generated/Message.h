#import <Foundation/Foundation.h>
@interface Message : NSObject
- (int)saveInitialData:(surveyStatus)int int:(surveyQuestionText)int;
- (int)clearUserActivityData:(deviceStorageStatus)int;
- (void)checkProgressStatus;
- (int)fetchLocalData:(entityNotificationFrequency)int;
- (int)logErrorEvent;
- (int)saveUserData:(surveyAnswerReviewStatusMessageText)int;
- (void)toggleFeature:(lastSyncTime)int int:(notificationFrequency)int;
- (void)initializeAnalytics:(surveyFeedbackDate)int int:(requestData)int;
- (void)logCrashData;
@end