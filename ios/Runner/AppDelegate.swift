import UIKit
import Flutter
import Amplify
import AWSCognitoAuthPlugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
              }
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let methodChannel = FlutterMethodChannel(name: "LIVE_VERIFICATION_CHANNEL", binaryMessenger: controller.binaryMessenger)
      methodChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "startLiveVerification" {
                guard let args = call.arguments as? [String: Any],
                      let sessionId = args["sessionId"] as? String else {
                                 result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid session Id",details: nil))
                                    return
                                }
                print("session id is \(sessionId)")
                let faceLivenessController = FaceLiveDetectionController()
                faceLivenessController.sessionId = sessionId
                faceLivenessController.flutterResult = result
                faceLivenessController.isModalInPresentation = true
                controller.present(faceLivenessController,
                                                                animated: true,
                                                                completion: nil)
            } else {
              result(FlutterMethodNotImplemented)
            }
          }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
