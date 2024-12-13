#import <Foundation/Foundation.h>
@interface DelayController : NSObject
- (void)fetchExternalData;
- (void)trackUserVisitStats;
- (int)deleteFromDatabase:(surveyAnswerCompletionMessageStatus)int;
- (int)showNotification:(surveyCompletionMessageStatusText)int int:(isGpsPermissionGranted)int;
- (int)hideToast;
- (void)initDatabase;
- (void)toggleTheme:(appVersion)int;
- (int)sendLocationData;
@end