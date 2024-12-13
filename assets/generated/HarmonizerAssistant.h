#import <Foundation/Foundation.h>
@interface HarmonizerAssistant : NSObject
- (int)getAppLaunchStats;
- (int)logEventInAnalytics:(isSurveyInProgress)int;
- (void)sendFeedback:(surveyAnswerCompletionProgressStatusMessage)int int:(filePath)int;
- (void)getUserVisitStats;
- (int)enableAppPermissions:(isEntityFeedbackReceived)int int:(privacyPolicyAcceptedTime)int;
- (void)clearUserMessageData;
- (void)initializePushNotificationTracking;
@end