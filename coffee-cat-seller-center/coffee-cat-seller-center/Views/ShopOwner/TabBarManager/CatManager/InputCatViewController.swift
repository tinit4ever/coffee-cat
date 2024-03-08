//
//  InputCatViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import UIKit
import Combine

class InputCatViewController: UIViewController, CatFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var cancellables: Set<AnyCancellable> = []
    
    var viewModel: InputCatViewModelProtocol
    
    var dismissCompletion: (() -> Void)?
    
    init(viewModel: InputCatViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Create UI Components
    lazy var selectAreaButton = makeButton()

    lazy var catNameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = sizeScaler(15)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = widthScaler(4)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.placeholder = "Enter cat name"
        textField.layoutMargins = UIEdgeInsets(top: 0, left: widthScaler(20), bottom: 0, right: widthScaler(20))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var typeTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = sizeScaler(15)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = widthScaler(4)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.placeholder = "Enter cat type"
        textField.layoutMargins = UIEdgeInsets(top: 0, left: widthScaler(20), bottom: 0, right: widthScaler(20))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupAsync()
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Config UI
    private func configUI() {
        self.view.backgroundColor = .systemBackground
        configNavigation()
        
        view.addSubview(selectAreaButton)
        configSelectAreaButton()
        
        view.addSubview(catNameTextField)
        configAddCatNameTextField()
        
        view.addSubview(typeTextField)
        configTypeTextField()
    }
    
    private func configSelectAreaButton() {
        selectAreaButton.setTitle(title: "Select Table", fontName: FontNames.avenir, size: sizeScaler(26), color: .customBlack)
        selectAreaButton.backgroundColor = .systemPurple
        selectAreaButton.cornerRadius(cornerRadius: sizeScaler(10))
        
        var actionList: [UIAction] = []
        
        let selectedAreaClosure = { [weak self] (action: UIAction) in
            let title = action.title
            self?.viewModel.selectedAreaName = title
        }
        
        for area in self.viewModel.areaList {
            let action = UIAction(title: area.areaName, handler: selectedAreaClosure)
            actionList.append(action)
        }
        
        actionList.first?.state = .on
    
        let menu = UIMenu(title: "Select Area", children: actionList)
        
        selectAreaButton.menu = menu
        selectAreaButton.showsMenuAsPrimaryAction = true
        selectAreaButton.changesSelectionAsPrimaryAction = true
        
        NSLayoutConstraint.activate([
            selectAreaButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(30)),
            selectAreaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(40)),
            selectAreaButton.heightAnchor.constraint(equalToConstant: heightScaler(55)),
            selectAreaButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2 - widthScaler(80))
        ])
    }
    
    private func configAddCatNameTextField() {
        NSLayoutConstraint.activate([
            catNameTextField.topAnchor.constraint(equalTo: selectAreaButton.bottomAnchor, constant: heightScaler(30)),
            catNameTextField.leadingAnchor.constraint(equalTo: selectAreaButton.leadingAnchor),
            catNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-40)),
            catNameTextField.heightAnchor.constraint(equalTo: selectAreaButton.heightAnchor)
        ])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: widthScaler(30), height: catNameTextField.frame.height))
        catNameTextField.leftView = paddingView
        catNameTextField.leftViewMode = .always
        catNameTextField.rightView = paddingView
        catNameTextField.rightViewMode = .always
    }
    
    private func configTypeTextField() {
        NSLayoutConstraint.activate([
            typeTextField.topAnchor.constraint(equalTo: catNameTextField.bottomAnchor, constant: heightScaler(30)),
            typeTextField.leadingAnchor.constraint(equalTo: catNameTextField.leadingAnchor),
            typeTextField.trailingAnchor.constraint(equalTo: catNameTextField.trailingAnchor),
            typeTextField.heightAnchor.constraint(equalTo: catNameTextField.heightAnchor),
        ])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: widthScaler(30), height: typeTextField.frame.height))
        typeTextField.leftView = paddingView
        typeTextField.leftViewMode = .always
        typeTextField.rightView = paddingView
        typeTextField.rightViewMode = .always
    }
    
    private func setupAsync() {
        self.viewModel.isCreateCompletionRequest
            .sink { result in
                switch result {
                case .success(let message):
                    self.showSuccess(message)
                case .failure(let error):
                    guard let castError = error as? ResponseError else {
                        self.showError(error.localizedDescription)
                        return
                    }
                    print(castError.localizedDescription)
                    self.showError(castError.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Catch Action
    @objc
    private func doneButtonTapped() {
        guard let name = catNameTextField.text,
              let type = typeTextField.text
        else {
            return
        }
        
        if name.isEmpty || type.isEmpty {
            showError("Please input all field")
            return
        }
        
        self.viewModel.setCatSubmition(name: name, type: type)
        self.viewModel.createCat()
    }
    
    @objc
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Utilities
    private func showError(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showSuccess(_ message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismissViewController()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func dismissViewController() {
        self.dismissCompletion?()
        self.dismiss(animated: true)
    }
}
