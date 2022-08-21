//
//  ViewController.swift
//  DataScannerUIKit
//
//  Created by Lee Myeonghwan on 2022/08/17.
//

import UIKit
import VisionKit

class ViewController: UIViewController {
    let stringArray: [String] = []
    lazy var dataScannerController: DataScannerViewController = {
        let viewController =  DataScannerViewController(recognizedDataTypes: [.text()],qualityLevel: .accurate, recognizesMultipleItems: false, isHighFrameRateTrackingEnabled: false, isPinchToZoomEnabled: true, isGuidanceEnabled: true, isHighlightingEnabled: true)
        viewController.delegate = self
        return viewController
    }()
    lazy var scanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Scan", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(startScanning), for: .touchUpInside)
        return button
    }()
    var catchText: UILabel = {
        let label = UILabel()
        label.text = "none"
        label.textColor = .red
        label.numberOfLines = 10
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(scanButton)
        view.addSubview(catchText)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
        ])
        
        catchText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catchText.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 30),
            catchText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            catchText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
    }
    
    @objc func startScanning() {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
//            navigationController?.pushViewController(dataScannerController, animated: true)
            present(dataScannerController, animated: true)
            try? self.dataScannerController.startScanning()
        }
    }
}

extension ViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let text):
            print(text.transcript.split(separator: "\n"))
//            print(text.transcript)
            catchText.text = text.transcript
        case .barcode(let barcode):
            print(barcode.payloadStringValue ?? "unkown")
            catchText.text = barcode.payloadStringValue ?? "unkown"
        default:
            break
        }
        dataScanner.dismiss(animated: true)
        dataScanner.stopScanning()
    }
}
