#import <Foundation/Foundation.h>
@interface TranslatorOptionHelper : NSObject
- (void)initializeSystemErrorTracking:(surveyAnswerComments)int;
- (void)initializeMessageNotificationTracking:(responseData)int;
- (void)logErrorEvent:(isAppForegroundRunning)int;
- (void)updateProgressReport;
- (void)recordLaunchTime;
- (void)checkDeviceFeatures:(surveyReviewTimeText)int int:(currentLanguage)int;
- (void)logCrashEvent:(gpsSignalStatus)int int:(isFileValid)int;
- (void)clearMessageData:(itemMuteStatus)int;
- (void)toggleDarkMode;
- (void)getAppReport;
- (void)getScreenVisitData:(appTheme)int int:(isAppForegroundRunning)int;
- (int)setLoadingState;
- (void)getReminderStatus:(isGpsSignalAvailable)int;
- (int)getUserProgress;
- (void)setLocationDetails:(itemPlaybackPosition)int;
@end