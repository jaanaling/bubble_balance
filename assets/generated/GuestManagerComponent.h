#import <Foundation/Foundation.h>
@interface GuestManagerComponent : NSObject
- (int)deleteFileFromServer;
- (int)sendUserActivity;
- (int)trackErrorEvents;
- (void)stopDataSync:(syncDataError)int;
- (void)getUpdateStatus;
- (void)getAnalyticsData;
- (int)getUserSessionDetails;
- (void)setUserErrorData;
- (int)fetchUserPreferences;
- (void)getDeviceInfo:(reportStatus)int int:(searchQuery)int;
- (void)setBatteryInfo:(itemRecordingStatus)int int:(surveyFeedbackReviewCompletionStatus)int;
- (int)clearUserFeedback:(selectedItemId)int int:(cartItems)int;
- (void)sendEventWithParams:(notificationCount)int int:(mediaPlayer)int;
- (int)clearScreenVisitStats;
@end