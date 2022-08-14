//
//  CameraScanner.swift
//  DataScannerExample
//
//  Created by Lee Myeonghwan on 2022/08/14.
//

import SwiftUI

struct CameraScanner: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var startScanning: Bool
    @Binding var scanResult: String
    var body: some View {
        NavigationView {
            CameraScannerViewController(startScanning: $startScanning, scanResult: $scanResult)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
self.presentationMode.wrappedValue.dismiss()
                        } label: {
                              Text("Cancel")
                        }
                    }
                }
                .interactiveDismissDisabled(true)
        }
    }
}
//
//struct CameraScanner_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraScanner()
//    }
//}
