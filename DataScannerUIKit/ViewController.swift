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
        
        viewController.view.addSubview(catchButton)
        catchButton.addTarget(self, action: #selector(captureText), for: .touchUpInside)
        catchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catchButton.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            catchButton.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: -100),
            catchButton.widthAnchor.constraint(equalToConstant: 110),
            catchButton.heightAnchor.constraint(equalToConstant: 60)
        ])
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
    lazy var catchButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Catch", for: .normal)
        button.addTarget(self, action: #selector(captureText), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.configuration?.background.backgroundColor = .gray
        return button
    }()
    var catchLabel: UILabel = {
        let label = UILabel()
        label.text = "none"
        label.textColor = .red
        label.numberOfLines = 20
        return label
    }()
    
    var currentItems: [RecognizedItem.ID: String] = [:] {
        didSet {
            if currentItems.isEmpty {
                catchButton.isUserInteractionEnabled = false
                catchButton.configuration?.background.backgroundColor = .gray
            } else {
                catchButton.isUserInteractionEnabled = true
                catchButton.configuration?.background.backgroundColor = .systemBlue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(catchButton.isUserInteractionEnabled)
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(scanButton)
        view.addSubview(catchLabel)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
        ])
        
        catchLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catchLabel.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 30),
            catchLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            catchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    @objc func startScanning() {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            //            navigationController?.pushViewController(dataScannerController, animated: true)
            present(dataScannerController, animated: true)
            try? self.dataScannerController.startScanning()
        }
    }
    
    @objc func captureText() {
        guard let item = currentItems.first else { return } // recognizesMultipleItems 를 사용하지않기 떄문에 하나만 선택
        catchLabel.text = item.value
        dataScannerController.dismiss(animated: true)
        dataScannerController.stopScanning()
    }
}

extension ViewController: DataScannerViewControllerDelegate {
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        for item in addedItems {
            switch item {
            case .text(let text):
                currentItems[item.id] = text.transcript
            default:
                break
            }
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didUpdate addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        for item in addedItems {
            switch item {
            case .text(let text):
                currentItems[item.id] = text.transcript
            default:
                break
            }
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didRemove addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        for item in addedItems {
            currentItems.removeValue(forKey: item.id)
        }
    }
}
