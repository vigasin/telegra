#import <UIKit/UIKit.h>

@interface UIWindow (TGWindowScene)

// With the UIScene life cycle a window created with -initWithFrame: is not displayed
// until it is attached to a scene.
- (void)tg_attachToActiveWindowScene;

@end
