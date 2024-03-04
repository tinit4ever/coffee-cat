//
//  InputAreaViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 04/03/2024.
//

import UIKit

class InputAreaViewController: UIViewController, PlaceFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize

    
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
        textField.placeholder = "Enter your table name here"
        textField.layoutMargins = UIEdgeInsets(top: 0, left: widthScaler(20), bottom: 0, right: widthScaler(20))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var viewModel: InputAreaViewModelProtocol
    
    init(viewModel: InputAreaViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configSelectAreaButton() {
        selectAreaButton.setTitle(title: "Select Table", fontName: FontNames.avenir, size: sizeScaler(30), color: .customBlack)
        selectAreaButton.backgroundColor = .systemPurple
        selectAreaButton.cornerRadius(cornerRadius: sizeScaler(10))
        
        var actionList: [UIAction] = []
        
        let selectedAreaClosure = { [weak self] (action: UIAction) in
            self?.hiddenAreaNameTextField()
            let title = action.title
            if let selectedAreaID = self?.viewModel.areaList.first(where: { $0.name == title })?.id {
                self?.viewModel.seatSubmition?.areaId = selectedAreaID
            }
        }
        
        let addMoreClosure = { [weak self] (action: UIAction) in
            self?.showAreaNameTextField()
            self?.viewModel.seatSubmition?.areaId = -1
        }
        
        for area in self.viewModel.areaList {
            let action = UIAction(title: area.name ?? "", handler: selectedAreaClosure)
            actionList.append(action)
        }
        
        let moreAction = UIAction(title: "Add more", handler: addMoreClosure)
        actionList.append(moreAction)
        let menu = UIMenu(title: "Select Area", children: actionList)
        
        
        selectAreaButton.menu = menu
        selectAreaButton.showsMenuAsPrimaryAction = true
        selectAreaButton.changesSelectionAsPrimaryAction = true
        
        NSLayoutConstraint.activate([
            selectAreaButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(30)),
            selectAreaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(40)),
            selectAreaButton.heightAnchor.constraint(equalToConstant: heightScaler(55)),
            selectAreaButton.widthAnchor.constraint(equalToConstant: widthScaler(380))
        ])
    }
    
    private func configAreaNameTextField() {
        NSLayoutConstraint.activate([
            areaNameTextField.topAnchor.constraint(equalTo: selectAreaButton.topAnchor),
            areaNameTextField.leadingAnchor.constraint(equalTo: selectAreaButton.trailingAnchor, constant: widthScaler(40)),
            areaNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-40)),
            areaNameTextField.heightAnchor.constraint(equalToConstant: heightScaler(55))
            
        ])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: widthScaler(30), height: areaNameTextField.frame.height))
        areaNameTextField.leftView = paddingView
        areaNameTextField.rightView = paddingView
        areaNameTextField.leftViewMode = .always
        areaNameTextField.rightViewMode = .always
        areaNameTextField.isHidden = true
    }
    
    private func configAddTableNameTextField() {
        NSLayoutConstraint.activate([
            tableNameTextField.topAnchor.constraint(equalTo: selectAreaButton.bottomAnchor, constant: heightScaler(50)),
            tableNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(40)),
            tableNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-40)),
            tableNameTextField.heightAnchor.constraint(equalToConstant: heightScaler(55)),
        ])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: widthScaler(30), height: tableNameTextField.frame.height))
        tableNameTextField.leftView = paddingView
        tableNameTextField.leftViewMode = .always
        tableNameTextField.rightView = paddingView
        tableNameTextField.rightViewMode = .always
        
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        self.areaNameTextField.delegate = self
        self.tableNameTextField.delegate = self
    }
    
    // MARK: - Catch Action
    @objc
    private func doneButtonTapped() {
        
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
