//
//  InputAreaViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 04/03/2024.
//

import UIKit
import Combine

class InputAreaViewController: UIViewController, PlaceFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var isCreateNew: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    var viewModel: InputAreaViewModelProtocol
    
    var dismissCompletion: (() -> Void)?
    
    init(viewModel: InputAreaViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Create UI Components
    lazy var selectAreaButton = makeButton()

    lazy var areaNameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = sizeScaler(15)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = widthScaler(4)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.placeholder = "Enter area name"
        textField.layoutMargins = UIEdgeInsets(top: 0, left: widthScaler(20), bottom: 0, right: widthScaler(20))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var tableNameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = sizeScaler(15)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = widthScaler(4)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.placeholder = "Enter table name"
        textField.layoutMargins = UIEdgeInsets(top: 0, left: widthScaler(20), bottom: 0, right: widthScaler(20))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var capacityTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = sizeScaler(15)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = widthScaler(4)
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.placeholder = "Capacity"
        textField.keyboardType = .numberPad
        textField.layoutMargins = UIEdgeInsets(top: 0, left: widthScaler(20), bottom: 0, right: widthScaler(20))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupAction()
    }
    
    // MARK: - Config UI
    private func configUI() {
        self.view.backgroundColor = .systemBackground
        configNavigation()
        
        view.addSubview(selectAreaButton)
        configSelectAreaButton()
        
        view.addSubview(areaNameTextField)
        configAreaNameTextField()
        
        view.addSubview(tableNameTextField)
        configAddTableNameTextField()
        
        view.addSubview(capacityTextField)
        configCapacityTextField()
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configSelectAreaButton() {
        selectAreaButton.setTitle(title: "Select Table", fontName: FontNames.avenir, size: sizeScaler(26), color: .customBlack)
        selectAreaButton.backgroundColor = .systemPurple
        selectAreaButton.cornerRadius(cornerRadius: sizeScaler(10))
        
        var actionList: [UIAction] = []
        
        let selectedAreaClosure = { [weak self] (action: UIAction) in
            self?.isCreateNew = false
            self?.hiddenAreaNameTextField()
            let title = action.title
            self?.viewModel.seatSubmition?.name = title
            if let selectedAreaID = self?.viewModel.areaList.first(where: { $0.name == title })?.id {
                self?.viewModel.seatSubmition?.id = selectedAreaID
            }
        }
        
        let addMoreClosure = { [weak self] (action: UIAction) in
            self?.isCreateNew = true
            self?.showAreaNameTextField()
            self?.viewModel.seatSubmition?.id = -1
        }
        
        for area in self.viewModel.areaList {
            let action = UIAction(title: area.name ?? "", handler: selectedAreaClosure)
            actionList.append(action)
        }
        
        let moreAction = UIAction(title: "Add more area", handler: addMoreClosure)
        moreAction.state = .on
        addMoreClosure(moreAction)
        actionList.append(moreAction)
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
    
    private func configAreaNameTextField() {
        NSLayoutConstraint.activate([
            areaNameTextField.topAnchor.constraint(equalTo: selectAreaButton.topAnchor),
            areaNameTextField.leadingAnchor.constraint(equalTo: selectAreaButton.trailingAnchor, constant: widthScaler(40)),
            areaNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-40)),
            areaNameTextField.heightAnchor.constraint(equalTo: selectAreaButton.heightAnchor)
            
        ])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: widthScaler(30), height: areaNameTextField.frame.height))
        areaNameTextField.leftView = paddingView
        areaNameTextField.rightView = paddingView
        areaNameTextField.leftViewMode = .always
        areaNameTextField.rightViewMode = .always
    }
    
    private func configAddTableNameTextField() {
        NSLayoutConstraint.activate([
            tableNameTextField.topAnchor.constraint(equalTo: selectAreaButton.bottomAnchor, constant: heightScaler(30)),
            tableNameTextField.leadingAnchor.constraint(equalTo: areaNameTextField.leadingAnchor),
            tableNameTextField.trailingAnchor.constraint(equalTo: areaNameTextField.trailingAnchor),
            tableNameTextField.heightAnchor.constraint(equalTo: selectAreaButton.heightAnchor)
        ])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: widthScaler(30), height: tableNameTextField.frame.height))
        tableNameTextField.leftView = paddingView
        tableNameTextField.leftViewMode = .always
        tableNameTextField.rightView = paddingView
        tableNameTextField.rightViewMode = .always
    }
    
    private func configCapacityTextField() {
        NSLayoutConstraint.activate([
            capacityTextField.topAnchor.constraint(equalTo: tableNameTextField.topAnchor),
            capacityTextField.leadingAnchor.constraint(equalTo: selectAreaButton.leadingAnchor),
            capacityTextField.heightAnchor.constraint(equalTo: selectAreaButton.heightAnchor),
            capacityTextField.widthAnchor.constraint(equalTo: selectAreaButton.widthAnchor)
        ])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: widthScaler(30), height: capacityTextField.frame.height))
        capacityTextField.leftView = paddingView
        capacityTextField.leftViewMode = .always
        capacityTextField.rightView = paddingView
        capacityTextField.rightViewMode = .always
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        self.areaNameTextField.delegate = self
        self.tableNameTextField.delegate = self
        
        self.viewModel.createCompletionRequest
            .sink { result in
                switch result {
                case .success(let message):
                    self.displaySuccess(message)
                case .failure(let error):
                    self.displayErrorAlert(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Catch Action
    @objc
    private func doneButtonTapped() {
        guard let areaName = areaNameTextField.text,
              let seatName = tableNameTextField.text,
              let capacityText = capacityTextField.text else {
            return
        }
        if isCreateNew {
            if areaName.isEmpty {
                self.displayErrorAlert("Area name should not be empty")
            } else {
                self.viewModel.seatSubmition?.name = areaName
            }
        }
        
        if capacityText.isEmpty {
            self.displayErrorAlert("Capacity should not be empty")
        }
        
        guard capacityText.isNumber(), let capacity = Int(capacityText)  else {
            self.displayErrorAlert("Capacity must be number")
            return
        }
        
        if capacity < 1 {
            self.displayErrorAlert("Capacity must be at least greater than or equal to 1")
        }
        
        if seatName.isEmpty {
            self.displayErrorAlert("Seat name should not be empty")
        }
        
        self.viewModel.seatSubmition?.name = areaName
        self.viewModel.seatSubmition?.seatName = seatName
        self.viewModel.seatSubmition?.seatCapacity = capacity
        
        self.viewModel.createSeat()
    }
    
    @objc
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Utilities
    private func createSeat(_ area: Area) {
        
    }
    
    private func hiddenAreaNameTextField() {
        UIView.animate(withDuration: 0.5, animations: {
            self.areaNameTextField.alpha = 0.0
        }) { _ in
            self.areaNameTextField.isHidden = true
        }
    }
    
    private func showAreaNameTextField() {
        self.areaNameTextField.alpha = 0.0
        self.areaNameTextField.isHidden = false

        UIView.animate(withDuration: 0.5, animations: {
            self.areaNameTextField.alpha = 1.0
        })
    }
    
    private func displayErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displaySuccess(_ message: String) {
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

extension InputAreaViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isFirstResponder {
            textField.text = ""
        }
    }
}
