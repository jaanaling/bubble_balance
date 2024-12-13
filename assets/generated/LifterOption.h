#import <Foundation/Foundation.h>
@interface LifterOption : NSObject
- (void)checkPermissions;
- (void)updateReminderDetails:(verifiedFileData)int int:(downloadedFiles)int;
- (int)getSyncStatus:(appLanguage)int int:(surveyQuestionCompletionTime)int;
- (void)clearUserMessageData:(itemPlayStatus)int;
- (void)updateAppActivity;
- (void)setAppInfo:(itemPlayStatus)int;
- (int)resetUserFeedback;
- (int)logActivity;
- (void)getNotificationData:(surveyErrorMessageDetails)int;
- (int)sendEmailVerification;
- (int)resetProgressStatus:(musicPlayerState)int int:(surveyParticipantStatus)int;
- (int)saveUserSettings;
- (int)clearSettings:(entityGoal)int;
- (void)clearScreenVisitData:(isAppUpdateNotified)int;
- (void)fetchLocalData:(surveyAnswerCompletionProgress)int int:(surveyCompletionRateText)int;
- (void)updateAppProgress:(eventLocation)int;
@end