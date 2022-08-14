//
//  CameraScannerViewController.swift
//  DataScannerExample
//
//  Created by Lee Myeonghwan on 2022/08/14.
//

import SwiftUI
import UIKit
import VisionKit
struct CameraScannerViewController: UIViewControllerRepresentable {
    @Binding var startScanning: Bool
    @Binding var scanResult: String
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController =  DataScannerViewController(recognizedDataTypes: [.text()],qualityLevel: .fast,recognizesMultipleItems: false, isHighFrameRateTrackingEnabled: false, isHighlightingEnabled: true)
        viewController.delegate = context.coordinator
        return viewController
    }
    func updateUIViewController(_ viewController: DataScannerViewController, context: Context) {
        if startScanning {
            try? viewController.startScanning()
        } else {
            viewController.stopScanning()
        }
    }
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: CameraScannerViewController
        init(_ parent: CameraScannerViewController) {
            self.parent = parent
        }
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
              switch item {
                  case .text(let text):
                      parent.scanResult = text.transcript
                  default:
                      break
              }
          }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
