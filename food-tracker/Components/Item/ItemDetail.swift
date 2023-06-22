//
//  ItemDetail.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/6/23.
//

import OpenAIKit

import SwiftUI

enum DetailViewingStyle {
    case adding
    case editing
    case viewing
}

struct ItemDetailInfo: Hashable {
    let item: FridgeItem
    let viewingStyle: DetailViewingStyle
}

// MARK: - Item Detail View Decl

struct ItemDetail: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: FridgeItem
    let viewingStyling: DetailViewingStyle
    @State private var canceling = false
    @State private var showInvalidAleart = false
    
    @State private var showScanningView = false
    
    var titleText: String {
        switch viewingStyling {
        case .adding:
            "Add Item"
        case .editing:
            "Edit Item"
        case .viewing:
            "Item"
        }
    }
    
    private var isItemInvalid: Bool {
        item.name.isEmpty
    }
    
    @State var errorMessage: ErrorMessageDetail = .init()
    @State var loadingBarcodeDetail: Bool = false
    
    @State private var foodFactCache: OpenFoodFactsAPIResponse? = nil
    
    @AppStorage(SettingsKeys.autoFetch.rawValue) private var autoFetch: Bool = true
    
    var isAdding: Bool {
        viewingStyling == .adding
    }
    
    var canEdit: Bool {
        viewingStyling != .viewing
    }
    
    var body: some View {
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
            .disabled(!canEdit)
                
            Section(header: Label("Detail", systemImage: "pencil")) {
                HStack {
                    Text("Name")
                    Divider()
                    TextField("Give a name to this item", text: $item.name)
                }
                
                HStack {
                    Text("Quantity")
                    Divider()
                    TextField(
                        "Quantity",
                        text: Binding(
                            get: {
                                String(item.quantity)
                            },
                            set: { val in
                                item.quantity = Int(val) ?? 0
                            }
                        )
                    ).keyboardType(.numberPad)
                }
                
                FoodCategoryPicker(category: $item.category)
            }
            .disabled(!canEdit)
                
            Section(header: Label("Category", systemImage: "filemenu.and.selection")) {}
                .disabled(!canEdit)
            
            Section(header: Label("Dates", systemImage: "pencil")) {
                DatePicker("Expiry Date", selection: $item.expiryDate, displayedComponents: .date)
                DatePicker("Added Date", selection: $item.addedDate, displayedComponents: .date)
            }
            .disabled(!canEdit)
            
            Section(header: Label("Note", systemImage: "note")) {
                TextEditor(text: $item.note)
            }
            .disabled(!canEdit)
            
            Section(header: Label("Options", systemImage: "ellipsis")) {
                Toggle("Is Template", isOn: $item.isTemplate)
                Toggle("Notification On", isOn: $item.notificationOn)
                Toggle("Archived", isOn: $item.archived)
            }
            .disabled(!canEdit)
        }
        .navigationTitle(titleText)
        .toolbar {
            if isAdding {
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
            
            if canEdit {
                ToolbarItem {
                    Button {
                        searchBarCode()
                    } label: {
                        Image(systemName: "questionmark.bubble")
                            .symbolEffect(.pulse.byLayer, isActive: loadingBarcodeDetail)
                    }.buttonStyle(.borderless)
                }
            }
                
            if isAdding {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        item.toggleNotification()
                        modelContext.insert(item)
                            
                        dismiss()
                    } label: {
                        Text("save")
                    }.disabled(isItemInvalid)
                }
            }
        }
        .navigationBarBackButtonHidden(isAdding)
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
        
        Task.detached(priority: .userInitiated) {
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
