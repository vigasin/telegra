import Foundation
import UIKit

// Adopts the UIScene life cycle (required by the iOS 27 SDK) by forwarding scene events
// to the existing AppDelegate implementation, which keeps owning the main window.
@objc(SceneDelegate) final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene, let appDelegate = self.appDelegate else {
            return
        }

        // The main window is created in application(_:didFinishLaunchingWithOptions:), before any scene is connected.
        if let window = appDelegate.window {
            window.windowScene = windowScene
            window.makeKeyAndVisible()
        }

        for context in connectionOptions.urlContexts {
            let _ = appDelegate.application(UIApplication.shared, open: context.url, options: [:])
        }
        for userActivity in connectionOptions.userActivities {
            let _ = appDelegate.application(UIApplication.shared, continue: userActivity, restorationHandler: { _ in })
        }
        if let shortcutItem = connectionOptions.shortcutItem {
            appDelegate.application(UIApplication.shared, performActionFor: shortcutItem, completionHandler: { _ in })
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            let _ = self.appDelegate?.application(UIApplication.shared, open: context.url, options: [:])
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        let _ = self.appDelegate?.application(UIApplication.shared, continue: userActivity, restorationHandler: { _ in })
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let appDelegate = self.appDelegate else {
            completionHandler(false)
            return
        }
        appDelegate.application(UIApplication.shared, performActionFor: shortcutItem, completionHandler: completionHandler)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        self.appDelegate?.applicationWillResignActive(UIApplication.shared)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        self.appDelegate?.applicationDidEnterBackground(UIApplication.shared)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        self.appDelegate?.applicationWillEnterForeground(UIApplication.shared)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        self.appDelegate?.applicationDidBecomeActive(UIApplication.shared)
    }
}
