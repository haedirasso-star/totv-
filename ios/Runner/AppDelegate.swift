import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure for background audio
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(.playback, mode: .moviePlayback)
    } catch {
      print("Failed to set audio session category: \(error)")
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle push notifications
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Forward to Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // Handle Universal Links
  override func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
