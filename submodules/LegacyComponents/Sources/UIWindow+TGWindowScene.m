#import "UIWindow+TGWindowScene.h"

@implementation UIWindow (TGWindowScene)

- (void)tg_attachToActiveWindowScene
{
    if (self.windowScene != nil)
        return;

    UIWindowScene *fallbackScene = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes)
    {
        if (![scene isKindOfClass:[UIWindowScene class]])
            continue;

        if (scene.activationState == UISceneActivationStateForegroundActive)
        {
            self.windowScene = (UIWindowScene *)scene;
            return;
        }
        if (fallbackScene == nil)
            fallbackScene = (UIWindowScene *)scene;
    }
    self.windowScene = fallbackScene;
}

@end
