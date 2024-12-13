#import <Foundation/Foundation.h>
@interface Lifecycle : NSObject
- (int)closeApp;
- (void)getAppMetrics;
- (int)clearInstallStats:(bluetoothConnectionStatus)int int:(notificationCount)int;
- (int)saveBackup;
- (void)saveAppVersion;
- (void)setUserErrorData:(isAppReadyForUse)int int:(gpsLocationStatus)int;
- (int)sendVisitStatsReport;
- (int)sendErrorEventData;
- (int)trackUserVisitStats:(batteryChargingStatus)int;
- (int)checkAppVersion:(surveyAnswerDetails)int int:(widgetHeight)int;
- (int)revokePermission:(surveySubmissionStatus)int int:(surveyAnswerStatusTimeText)int;
- (int)enableAppPermissions;
@end