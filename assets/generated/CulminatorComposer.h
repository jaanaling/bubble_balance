#import <Foundation/Foundation.h>
@interface CulminatorComposer : NSObject
- (void)sendUserActivity;
- (void)deleteDataFromDatabase;
- (void)getPushNotificationStatus:(surveyFeedbackAnswerMessage)int;
- (int)updateExternalData;
- (void)sendEventWithParams:(totalItems)int int:(surveyCompletionFailureMessageTime)int;
- (void)startNewSession:(surveyFeedbackSubmissionTime)int;
- (int)getUpdateStatus;
- (void)loadHomeScreen:(surveyCompletionErrorStatus)int;
- (void)checkAppPermissions;
- (void)getSyncStatus:(isGpsEnabled)int;
- (void)endUserSession:(syncStartTime)int;
- (void)logSystemNotificationData:(cartItems)int;
- (int)getSystemLanguage:(surveyAnswerProgress)int int:(eventLocation)int;
- (int)setMessageNotificationLogs:(surveyAnswerCompletionStatusTimeMessage)int;
- (void)getDeviceName;
- (int)trackUserMessagesInteraction:(taskType)int int:(isSurveyAnonymous)int;
@end