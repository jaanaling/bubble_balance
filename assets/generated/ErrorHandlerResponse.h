#import <Foundation/Foundation.h>
@interface ErrorHandlerResponse : NSObject
- (void)getDeviceOrientation;
- (void)disableLocationServices:(taskPriority)int;
- (int)logCrashLogs;
- (void)checkInstallStats;
- (int)trackSystemNotifications:(isGpsPermissionGranted)int int:(surveyAnswerComments)int;
- (void)initializeUserErrorTracking:(isDeviceErrorDetected)int;
- (void)setSensorData:(mediaControl)int;
- (int)loadHomeScreen;
@end