//
//  FaceLiveDetectionController.swift
//  Runner
//
//  Created by Yogesh on 05/12/23.
//

import Foundation
import SwiftUI
import UIKit
import FaceLiveness

class FaceLiveController: UIViewController {
    var sessionId: String?
    var flutterResult: FlutterResult!
    var hostingController: UIHostingController<FaceLivenessDetectorView>?
    override func viewDidLoad() {
        super.viewDidLoad();
        configureFaceDetection()
    }
    private func configureFaceDetection() {
        if let sessionID = self.sessionId {
            let faceView = FaceLivenessDetectorView(
                sessionID: sessionID,
                region: "ap-south-1",
                disableStartView: true,
                isPresented: .constant(true),
                onCompletion: { result in
                    switch result {
                    case .success:
                        self.callback("success")
                        print("Liveness successfully completed")
                    case .failure(let error):
                        self.callback(error.message)
                        print("Liveness error: \(error)")
                    }
                }
            )
            hostingController = createHostingController(with: faceView)
            addHostingControllerAsChild(hostingController!)
            configureConstraints(for: hostingController!.view)
        }
        
    }
    
    private func callback(_ res: String) {
        hostingController?.dismiss(animated: true, completion: nil)
        if (res == "success") {
            flutterResult("success")
        } else {
            flutterResult("error")
        }

    }

    private func createHostingController(with rootView: FaceLivenessDetectorView) -> UIHostingController<FaceLivenessDetectorView> {
            return UIHostingController(rootView: rootView)
        }

        private func addHostingControllerAsChild(_ hostingController: UIHostingController<FaceLivenessDetectorView>) {
            addChild(hostingController)
            view.addSubview(hostingController.view)
        }

        private func configureConstraints(for view: UIView) {
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
                view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }
}
