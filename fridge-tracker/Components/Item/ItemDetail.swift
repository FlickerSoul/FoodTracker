//
//  ItemDetail.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import SwiftUI

struct ItemDetail: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: FridgeItem
    @Binding var adding: Bool
    @State private var canceling = false
    @State private var showInvalidAleart = false
    
    @State private var showScanningView = false
    
    var titleText: String {
        if adding {
            return "Add Item"
        } else {
            return "Edit Item"
        }
    }
    
    private var isItemInvalid: Bool {
        item.name.isEmpty
    }
    
    @State var errorMessage: ErrorMessageDetail = .init()
    @State var loadingBarcodeDetail: Bool = false
    
    private var isCodeValid: Bool {
        item.barcode.isNumber
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Label("Barcode", systemImage: "barcode"), footer: Text("The barcode of this food item. You can ignore this and fill in manually.")) {
                    HStack {
                        TextField("Barcode", text: $item.barcode)
                        
                        Button {
                            showScanningView.toggle()
                        } label: {
                            Image(systemName: "barcode.viewfinder")
                        }.buttonStyle(.borderless)
                        
                        Button {
                            searchBarCode()
                        } label: {
                            Image(systemName: loadingBarcodeDetail ? "icloud.and.arrow.down" : "questionmark.bubble")
                                .contentTransition(.symbolEffect(.replace.upUp.wholeSymbol))
                                .symbolEffect(.pulse.byLayer, isActive: loadingBarcodeDetail)
                        }.buttonStyle(.borderless)
                    }
                }
                
                Section(header: Label("Name", systemImage: "pencil"), footer: Text("The name should not be empty.")) {
                    TextField("Give a name to this item", text: $item.name)
                }
                
                Section(header: Label("Date", systemImage: "pencil")) {
                    DatePicker("Expiry Date", selection: $item.expiryDate, displayedComponents: .date)
                    DatePicker("Added Date", selection: $item.addedDate, displayedComponents: .date)
                }
                
                Section(header: Label("Note", systemImage: "note")) {
                    TextEditor(text: $item.note)
                }
                
                Section(header: Label("Options", systemImage: "ellipsis")) {
                    Toggle("Notification", isOn: $item.notificationOn)
                    Toggle("Archive", isOn: $item.archived)
                }
            }
        }
        .navigationTitle(titleText)
        .toolbar {
            if adding {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        canceling = true
                    }.alert(
                        "Discard Changes?",
                        isPresented: $canceling
                    ) {
                        Button("Yes", role: .destructive) {
                            dismiss()
                        }
                    }
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button {
                    if adding {
                        item.toggleNotification()
                        modelContext.insert(item)
                    }
                    
                    dismiss()
                } label: {
                    Text("save")
                }.disabled(isItemInvalid)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showScanningView) {
            ScannerView { code in
                self.item.barcode = code
                searchBarCode()
            }
        }
        .alert(isPresented: $errorMessage.isShowing) {
            Alert(title: Text(errorMessage.title), message: Text(errorMessage.message), dismissButton: .default(Text(errorMessage.buttonText)))
        }
    }
}

extension ItemDetail {
    private func searchBarCode() {
        guard isCodeValid else {
            errorMessage.showErrorMessage(title: "Barcode Is Not Valid", message: "Please scan or enter a correct barcode before fetching")
            return
        }
        
        OpenFoodFactsRequestFactory.current.makeFoodInfoRequest(barcode: item.barcode) {
            startLoadingBarcodeDetail()
        } resultCallback: { result, error in
            finishLoadingBarcodeDetail(error: error)
            
            if var result = result {
                fillInItemNameFromBarcode(of: &result.product)
                
                // TODO: infer categories etc.
            }
        }
    }
    
    private func startLoadingBarcodeDetail() {
        loadingBarcodeDetail.toggle()
    }
    
    private func finishLoadingBarcodeDetail(error: APIRequestError?) {
        loadingBarcodeDetail.toggle()
        
        if let error = error {
            errorMessage.showErrorMessage(title: "Cannot Load Barcode Detail", message: "Please check if the barcode is correctly entered or not.")
            
            // TODO: better error handling
            switch error {
            case .decodeError(let data):
                print(data)
            case .requestError:
                print("Request error")
            }
        }
    }

    private func fillInItemNameFromBarcode(of data: inout OpenFoodFactsProductDetail) {
        item.name = (
            data.brands ?? ""
        ) + (
            data.product_name ??
                data.generic_name ??
                data.generic_name_en ?? ""
        )
    }
}

private extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

#Preview("adding") {
    MainView()
        .modelContainer(previewContainer)
}
