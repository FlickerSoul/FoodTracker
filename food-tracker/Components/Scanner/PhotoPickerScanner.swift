//
//  PhotoPickerScanner.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 6/21/23.
//

import PhotosUI
import SwiftUI
import Vision

enum ScannerError: Error, CustomStringConvertible {
    var description: String {
        switch self {
        case .CannotLoadTransferable:
            "Cannot Load Transferable"
        case .CannotDecodeData:
            "Cannot Decode Data"
        case .InvalidObservation:
            "Invalid Barcode Observation"
        case .InvalidObservationCount:
            "We Detected None Or Multiple Barcodes"
        case .EmptyPayloadString:
            "Empty Barcode Observation"
        }
    }

    case CannotLoadTransferable(error: Error)
    case CannotDecodeData
    case InvalidObservation
    case InvalidObservationCount
    case EmptyPayloadString
}

struct PhotoPickerScanner: View {
    @State private var pickedPhoto: PhotosPickerItem? = nil
    let onSuccessHandler: (String) -> Void
    let onErrorHandler: (ScannerError) -> Void

    init(onSuccessHandler: @escaping (String) -> Void, onErrorHandler: @escaping (ScannerError) -> Void) {
        self.onSuccessHandler = onSuccessHandler
        self.onErrorHandler = onErrorHandler
    }

    var body: some View {
        PhotosPicker(selection: $pickedPhoto, matching: .images) {
            Image(systemName: "photo")
        }
        .onChange(of: pickedPhoto) {
            guard let pickedPhoto = self.pickedPhoto else { return }

            pickedPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        onErrorHandler(ScannerError.CannotDecodeData)
                        return
                    }

                    let imageRequestHandler = VNImageRequestHandler(data: data)

                    lazy var barcodeDetectRequest: VNDetectBarcodesRequest = {
                        let barcodeRequest = VNDetectBarcodesRequest(completionHandler: self.handlePickedImage)

                        return barcodeRequest
                    }()

                    try? imageRequestHandler.perform([barcodeDetectRequest])
                case .failure(let failure):
                    onErrorHandler(.CannotLoadTransferable(error: failure))
                }
            }
        }
    }

    private func handlePickedImage(request: VNRequest, error: Error?) {
        guard let observations = (request.results as? [VNBarcodeObservation]) else {
            onErrorHandler(ScannerError.InvalidObservation)
            return
        }
        guard observations.count == 1 else {
            onErrorHandler(ScannerError.InvalidObservationCount)
            return
        }

        guard let payloadString = observations[0].payloadStringValue else {
            onErrorHandler(ScannerError.EmptyPayloadString)
            return
        }

        onSuccessHandler(payloadString)
    }
}

#Preview {
    PhotoPickerScanner(onSuccessHandler: { _ in }, onErrorHandler: { _ in })
}
