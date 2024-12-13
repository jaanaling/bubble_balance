#import <Foundation/Foundation.h>
@interface BarInterpretor : NSObject
- (void)handleApiError;
- (void)clearAppReport;
- (int)getActivityLog:(gpsFixStatus)int int:(reminderMessage)int;
- (int)setTime:(mediaStatus)int int:(isServiceRunning)int;
- (int)sendFeedback:(downloadedFiles)int int:(surveyAnswerCompletionStatusTimeText)int;
- (int)clearDeviceStorage:(voiceCommandStatus)int int:(surveyParticipantCount)int;
- (void)setUserActivity:(mediaSyncStatus)int int:(isFileDecompressionEnabled)int;
- (int)getReminderStatus:(appUpdateAvailable)int int:(errorCodeDetails)int;
- (int)sendProgressReport;
- (int)trackUninstallEvents;
- (int)updateDataInDatabase;
- (void)uploadFileToServer:(currentGeoCoordinates)int int:(isTaskInProgress)int;
- (void)trackScreenVisit:(appLaunchCount)int int:(entityHasBio)int;
@end