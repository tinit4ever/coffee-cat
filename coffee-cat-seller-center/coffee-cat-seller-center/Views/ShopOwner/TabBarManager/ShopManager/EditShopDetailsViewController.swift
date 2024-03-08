//
//  EditShopDetailsViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 06/03/2024.
//

import UIKit
import Combine

class EditShopDetailsViewController: UIViewController, ShopManagerFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: EditShopDetailsViewModelProtocol = EditShopDetailsViewModel()
    var cancellables: Set<AnyCancellable> = []
    var didUpdateSuccess: (() -> Void)?
    
    // MARK: - Create UI Components
    lazy var animationView = makeLottieAnimationView(animationName: "custom")
    
    lazy var inputStackView = makeVerticalStackView()
    
    lazy var nameStackView = makeVerticalStackView()
    lazy var nameLabel: UILabel = makeLabel()
    lazy var nameTextFieldContainer: UIView = makeRoundedContainer()
    lazy var nameTextField: UITextField = makeTextField(placeholder: "Enter name")
    
    lazy var phoneStackView = makeVerticalStackView()
    lazy var phoneLabel: UILabel = makeLabel()
    lazy var phoneTextFieldContainer: UIView = makeRoundedContainer()
    lazy var phoneTextField: UITextField = makeTextField(placeholder: "Enter phone number")
    
    lazy var addressStackView = makeVerticalStackView()
    lazy var addressLabel: UILabel = makeLabel()
    lazy var addressTextFieldContainer: UIView = makeRoundedContainer()
    lazy var addressTextField: UITextField = makeTextField(placeholder: "Enter address")
    
    lazy var timeLabel: UILabel = makeLabel()
    lazy var timeStackView = makeHorizontalStackView()
    lazy var openTimeLabel: UILabel = makeLabel()
    lazy var openTimePicker = makeDatePicker()
    lazy var closeTimeLabel: UILabel = makeLabel()
    lazy var closeTimePicker = makeDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupAsync()
        setupAction()
    }
    
    // MARK: - Config UI
    private func configUI() {
        view.backgroundColor = .animationBackground
        
        cofigNavigation()
        
        view.addSubview(animationView)
        animationView.play()
        configAnimationView()
        
        view.addSubview(inputStackView)
        configInputStackView()
        
        view.addSubview(timeStackView)
        configTimeStackView()
    }
    
    private func cofigNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .systemPurple
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            animationView.widthAnchor.constraint(equalToConstant: sizeScaler(540)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(400)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configInputStackView() {
        inputStackView.spacing = heightScaler(40)
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: self.animationView.bottomAnchor),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(40)),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-40))
        ])
        
        inputStackView.addArrangedSubview(nameStackView)
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.spacing = heightScaler(10)
        nameLabel.setupTitle(text: "Name", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        nameLabel.textAlignment = .left
        nameStackView.addArrangedSubview(nameTextFieldContainer)
        nameTextFieldContainer.addRoundedTextField(nameTextField)
        nameTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
        
        inputStackView.addArrangedSubview(phoneStackView)
        phoneStackView.addArrangedSubview(phoneLabel)
        phoneStackView.spacing = heightScaler(10)
        phoneLabel.setupTitle(text: "Phone", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        phoneLabel.textAlignment = .left
        phoneStackView.addArrangedSubview(phoneTextFieldContainer)
        phoneTextFieldContainer.addRoundedTextField(phoneTextField)
        phoneTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
        
        phoneTextField.keyboardType = .numberPad
        
        inputStackView.addArrangedSubview(addressStackView)
        addressStackView.addArrangedSubview(addressLabel)
        addressStackView.spacing = heightScaler(10)
        addressLabel.setupTitle(text: "Address", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        addressLabel.textAlignment = .left
        addressStackView.addArrangedSubview(addressTextFieldContainer)
        addressTextFieldContainer.addRoundedTextField(addressTextField)
        addressTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
    }
    
    private func configTimeStackView() {
        inputStackView.addArrangedSubview(timeLabel)
        timeLabel.setupTitle(text: "Operating hours", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        timeLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            timeStackView.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: heightScaler(20)),
            timeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(40)),
            timeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-320))
        ])
        
        timeStackView.contentMode = .center
        timeStackView.distribution = .equalSpacing
        timeStackView.spacing = widthScaler(20)
        
        timeStackView.addArrangedSubview(openTimeLabel)
        openTimeLabel.setupTitle(text: "From", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        
        timeStackView.addArrangedSubview(openTimePicker)
        openTimePicker.datePickerMode = .time
        
        timeStackView.addArrangedSubview(closeTimeLabel)
        closeTimeLabel.setupTitle(text: "To", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        
        timeStackView.addArrangedSubview(closeTimePicker)
        closeTimePicker.datePickerMode = .time
    }
    
    // MARK: - Setup Async
    private func setupAsync() {
        self.viewModel.isUpdatedSubject
            .sink { result in
                switch result {
                case .success():
                    self.showUpdateSuccess()
                case .failure(let error):
                    self.showUpdateFaild(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    // MARK: - Setup Action
    private func setupAction() {
        nameTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
    }
    
    // MARK: - Catch Action
    @objc
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func doneButtonTapped() {
        guard let name = nameTextField.text,
              let phone = phoneTextField.text,
              let address = addressTextField.text else {
            return
        }
        
        if !phone.isValidPhoneNumber {
            self.showPhoneNumberInvalid()
        }
        
        let openTime = self.formatTimePickerDate(time: openTimePicker.date)
        let closeTime = self.formatTimePickerDate(time: closeTimePicker.date)
        
        self.viewModel.setShopUpdateParameter(name: name, phone: phone, address: address, openTime: openTime, closeTime: closeTime)
        self.viewModel.updateShopProfile()
    }
    
    // MARK: - Utilities
    private func formatTimePickerDate(time: Date) -> String {
        let selectedTime = time
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.string(from: selectedTime)
        
        return formattedTime
    }
    
    private func showPhoneNumberInvalid() {
        let alertController = UIAlertController(title: "Input Invalid", message: "Phone number is invalid", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showUpdateSuccess() {
        let alertController = UIAlertController(title: "Success", message: "Your shop profile have been updated", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.didUpdateSuccess?()
            self.dismiss(animated: true)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showUpdateFaild(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension EditShopDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isFirstResponder {
            textField.text = ""
        }
    }
}
