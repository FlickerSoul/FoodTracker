//
//  ItemDetail.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import OpenAIKit

import SwiftUI

// MARK: - Item Detail View Decl

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
    
    @State private var foodFactCache: OpenFoodFactsAPIResponse? = nil
    
    @AppStorage(SettingsKeys.autoFetch.rawValue) private var autoFetch: Bool = true
    
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
                        
                        PhotoPickerScanner(onSuccessHandler: self.loadBarcode) { error in
                            errorMessage.showErrorMessage(title: error.description)
                        }
                    }
                }
                
                Section(header: Label("Name", systemImage: "pencil"), footer: Text("The name should not be empty.")) {
                    TextField("Give a name to this item", text: $item.name)
                }
                
                Section(header: Label("Category", systemImage: "filemenu.and.selection")) {
                    FoodCategoryPicker(category: $item.category)
                }
                
                Section(header: Label("Dates", systemImage: "pencil")) {
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
            
            ToolbarItem {
                Button {
                    searchBarCode()
                } label: {
                    Image(systemName: "questionmark.bubble")
                        .symbolEffect(.pulse.byLayer, isActive: loadingBarcodeDetail)
                }.buttonStyle(.borderless)
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
            ScannerView(callback: self.loadBarcode)
        }
        .alert(isPresented: $errorMessage.isShowing) {
            Alert(title: Text(errorMessage.title), message: Text(errorMessage.message), dismissButton: .default(Text(errorMessage.buttonText)))
        }
    }
}

// MARK: - Item Detail Bar Code

extension ItemDetail {
    private func loadBarcode(_ barcode: String) {
        item.barcode = barcode
        searchBarCode()
    }
    
    private var isCodeValid: Bool {
        item.barcode.isNumber
    }
    
    private func searchBarCode() {
        guard isCodeValid else {
            errorMessage.showErrorMessage(title: "Barcode Is Not Valid", message: "Please scan or enter a correct barcode before fetching")
            return
        }
        
        OpenFoodFactsRequestFactory.current.makeFoodInfoRequest(barcode: item.barcode) {
            startLoadingBarcodeDetail()
        } resultCallback: { result, error in
            finishLoadingBarcodeDetail(error: error)
            
            if let result = result {
                self.foodFactCache = result
                
                if autoFetch {
                    fillInItemNameFromBarcode()
                    inferDetail()
                }
            }
        }
    }
    
    private func startLoadingBarcodeDetail() {
        loadingBarcodeDetail.toggle()
    }
    
    private func finishLoadingBarcodeDetail(error: APIRequestError?) {
        loadingBarcodeDetail.toggle()
        
        if error != nil {
            errorMessage.showErrorMessage(title: "Cannot Load Barcode Detail", message: "Please check if the barcode is correctly entered or not.")
        }
    }

    private func fillInItemNameFromBarcode() {
        guard let data = foodFactCache else { return }
        
        item.name = "\(data.product.name) \(data.product.brandDescription) \(data.product.quantityDescription)"
    }
}

// MARK: - Item Detail AI Classification

extension ItemDetail {
    private func inferDetail() {
        guard setupAI() else { return }
        
        guard let foodFactCache = foodFactCache else { return }
        
        // TODO: use dispatch queue
        Task.detached {
            await OpenAIFoodItemQueryMaker.current.processFoodCategory(item: foodFactCache.product) { chat, _ in
                
                if let chat = chat {
                    updateCategory(chat: chat)
                } else {
                    errorMessage.showErrorMessage(title: "Cannot Infer Category")
                }
            }
        }
    }
    
    private func setupAI() -> Bool {
        let apiKey = UserDefaults.standard.string(forKey: SettingsKeys.openAIKey.rawValue)
        
        OpenAIFoodItemQueryMaker.current.setApiKey(apiKey)
        
        do {
            try OpenAIFoodItemQueryMaker.current.setup()
        } catch {
            return false
        }
        
        return true
    }
    
    private func updateCategory(chat: OpenAIKit.Chat) {
        let choice = chat.choices[0]
        
        switch choice.message {
        case .assistant(let content):
            if let id = Int(content), let category = FoodItemCategory(rawValue: id) {
                item.category = category
            } else {
                errorMessage.showErrorMessage(title: "Cannot Get Correct Category")
            }
        default:
            return
        }
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
