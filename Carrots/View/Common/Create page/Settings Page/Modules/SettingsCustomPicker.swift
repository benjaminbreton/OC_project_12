//
//  GenericPicker.swift
//  Carrots
//
//  Created by Benjamin Breton on 17/04/2021.
//

import SwiftUI

// MARK: - SettingsCustomPicker


struct SettingsCustomPicker<T: CustomStringConvertible>: View {
    
    // MARK: - Properties
    
    @State var selectionIndex: Int? = nil
    @Binding var selectedObjects: [T]
    let titleOne: String
    let titleMany: String
    let data: [T]
    let maximumSelection: Int
    let lineCount: CGFloat
    
    // MARK: - Init
    
    /**
     UITextView used to select datas from a UIPickerView.
     - parameter selectedObjects: Binding array containing selected objects by the user.
     - parameter title: Ocjects name.
     - parameter data: Objects list to display in the pickeview.
     - parameter maximumSelection: Maximum number of objects which can be selected by the user.
     - parameter lineCount: Number of lines of the textview.
     */
    init(titleOne: String, titleMany: String, data: [T], selectedObjects: Binding<[T]>, maximumSelection: Int, lineCount: CGFloat) {
        self.titleOne = titleOne
        self.titleMany = titleMany
        self.data = data
        self._selectedObjects = selectedObjects
        self.maximumSelection = maximumSelection
        self.lineCount = lineCount
    }
    
    // MARK: - View
    
    var body: some View {
        PickerView(titleOne: titleOne, titleMany: titleMany, data: data, selectionIndex: $selectionIndex, selectedObjects: _selectedObjects, maximumSelection: maximumSelection)
            .frame(height: ViewCommonSettings().textLineHeight * lineCount)
            .inModule(titleMany)
    }
}

// MARK: - UIViewRepresentable

fileprivate struct PickerView<T: CustomStringConvertible>: UIViewRepresentable {
    
    // MARK: - Properties
    
    @Binding private var selectionIndex: Int?
    @Binding private var selectedObjects: [T]
    private let data: [T]
    private let textView: PickerTextView<T>
    private let defaultText: String
    private let maximumSelection: Int

    
    // MARK: - Init
    
    init(titleOne: String, titleMany: String, data: [T], selectionIndex: Binding<Int?>, selectedObjects: Binding<[T]>, maximumSelection: Int) {
        self.data = data
        self._selectionIndex = selectionIndex
        self._selectedObjects = selectedObjects
        self.maximumSelection = maximumSelection
        defaultText = maximumSelection == 1 ? "\("picker.choices1".localized)\(titleOne.lowercased())" : "\("picker.choices1plus".localized)\(titleOne.lowercased())"
        textView = PickerTextView(data: data, selectionIndex: selectionIndex, selectedObjects: selectedObjects, maximumSelection: maximumSelection)
        setTextView(titleMany)
    }
    private func setTextView(_ title: String) {
        textView.font = UIFont(name: ViewCommonSettings().regularFontName, size: ViewCommonSettings().regularFontSize)
        textView.text = "\("picker.chooseClick".localized)"
        textView.textAlignment = .center
    }

    // MARK: - UIView methods
    
    func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UITextView {
        //textField.placeholder = placeholder
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<PickerView>) {
        guard selectionIndex != nil else { return }
        uiView.text = selectedObjects.count == 0 ? defaultText : selectedObjects.map({ "\($0.description)" }).joined(separator: ", ")
    }

    
}

// MARK: UITextView

fileprivate class PickerTextView<T: CustomStringConvertible>: UITextView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    @Binding private var selectionIndex: Int?
    @Binding private var selectedObjects: [T]
    private let data: [T]
    private let maximumSelection: Int
    /// Pickerview to display when textview is selected.
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.pickerBackground
        return pickerView
    }()
    /// Pickerview's toolbar.
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        // colors
        toolbar.backgroundColor = UIColor.pickerBackground
        toolbar.tintColor = UIColor.pickerText
        toolbar.barTintColor = UIColor.pickerBackground
        // buttons creation
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: #selector(addObject))
        let removeButton = UIBarButtonItem(image: UIImage(systemName: "minus"), style: .plain, target: nil, action: #selector(removeObject))
        let addAllButton = UIBarButtonItem(image: UIImage(systemName: "infinity"), style: .plain, target: nil, action: #selector(addAllObjects))
        let removeAllButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: nil, action: #selector(removeAllObjects))
        let removeLastButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: nil, action: #selector(removeLastObject))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        // add buttons regarding the maximum number of selected objects
        if maximumSelection == 1 {
            toolbar.setItems([spacer, doneButton], animated: false)
        } else if maximumSelection < data.count && maximumSelection > 0 {
            toolbar.setItems([addButton, spacer, removeButton, spacer, removeAllButton, spacer, removeLastButton, spacer, doneButton], animated: false)
        } else {
            toolbar.setItems([addButton, spacer, removeButton, spacer, addAllButton, spacer, removeAllButton, spacer, removeLastButton, spacer, doneButton], animated: false)
        }
        // size
        toolbar.sizeToFit()
        // return
        return toolbar
    }()
    
    // MARK: - Init
    
    init(data: [T], selectionIndex: Binding<Int?>, selectedObjects: Binding<[T]>, maximumSelection: Int) {
        // init
        self.data = data
        self._selectionIndex = selectionIndex
        self._selectedObjects = selectedObjects
        self.maximumSelection = maximumSelection
        super.init(frame: .zero, textContainer: nil)
        // customization
        inputView = pickerView
        inputAccessoryView = toolbar
        tintColor = .clear
        isScrollEnabled = true
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Toolbar's buttons actions
    
    /// Add the selected object  in the list.
    @objc
    private func addObject() {
        guard let index = selectionIndex else { return }
        if selectedObjects.count > 0 {
            for object in selectedObjects {
                if object.description == data[index].description { return }
            }
        }
        if maximumSelection <= 0 || selectedObjects.count < maximumSelection {
            selectedObjects.append(data[index])
        }
    }
    /// Remove the selected object from the list.
    @objc
    private func removeObject() {
        guard let selectionIndex = selectionIndex else { return }
        if selectedObjects.count > 0 {
            for index in selectedObjects.indices {
                if selectedObjects[index].description == data[selectionIndex].description {
                    selectedObjects.remove(at: index)
                    return
                }
            }
        }
    }
    /// Add all objects in the list.
    @objc
    private func addAllObjects() {
        if selectionIndex == nil { selectionIndex = 0 }
        selectedObjects = data
    }
    /// Remove all objects from the list.
    @objc
    private func removeAllObjects() {
        selectedObjects = []
    }
    /// Remove the last object added in the list.
    @objc
    private func removeLastObject() {
        if selectedObjects.count > 0 {
            selectedObjects.removeLast()
        }
    }
    /// Toolbar's done button action.
    @objc
    private func donePressed() {
        self.selectionIndex = self.pickerView.selectedRow(inComponent: 0)
        self.endEditing(true)
    }
    
    // MARK: - UIPickerView methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if selectionIndex == nil {
            selectionIndex = 0
            if maximumSelection == 1 {
                selectedObjects = [data[0]]
            }
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].description
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectionIndex = row
        if maximumSelection == 1 {
            selectedObjects = [data[row]]
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: data[row].description, attributes: [NSAttributedString.Key.foregroundColor: UIColor.pickerText, NSAttributedString.Key.font: UIFont.pickerFont])
    }
}

