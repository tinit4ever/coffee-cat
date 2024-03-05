//
//  AccountInputViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import UIKit
import SwiftUI
import Combine

class AccountInputViewController: UIViewController, AccountInputFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: AccountInputViewModelProtocol
    private var emailExistedSubject = PassthroughSubject<Result<String, Error>, Never>()
    var dismissCompletion: (() -> Void)?
    var isUpdate: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: AccountInputViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.cancellables = []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // -MARK: Create UI Components
    lazy var inputStackView = makeVerticalStackView()
    
    lazy var nameStackView = makeVerticalStackView()
    lazy var nameLabel: UILabel = makeLabel()
    lazy var nameTextFieldContainer: UIView = makeRoundedContainer()
    lazy var nameTextField: UITextField = makeTextField(placeholder: "Enter name")
    
    lazy var phoneStackView = makeVerticalStackView()
    lazy var phoneLabel: UILabel = makeLabel()
    lazy var phoneTextFieldContainer: UIView = makeRoundedContainer()
    lazy var phoneTextField: UITextField = makeTextField(placeholder: "Enter phone number")
    
    lazy var emailStackView = makeVerticalStackView()
    lazy var emailLabel: UILabel = makeLabel()
    lazy var emailTextFieldContainer: UIView = makeRoundedContainer()
    lazy var emailTextField: UITextField = makeTextField(placeholder: "Enter email")
    
    lazy var passwordStackView = makeVerticalStackView()
    lazy var passwordLabel: UILabel = makeLabel()
    lazy var passwordTextFieldContainer: UIView = makeRoundedContainer()
    lazy var passwordTextField: UITextField = makeTextField(placeholder: "Enter password")
    
    lazy var confirmPasswordStackView = makeVerticalStackView()
    lazy var confirmPasswordLabel: UILabel = makeLabel()
    lazy var confirmPasswordTextFieldContainer: UIView = makeRoundedContainer()
    lazy var confirmPasswordTextField: UITextField = makeTextField(placeholder: "Enter confirm password")
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupData()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isUpdate = false
    }
    
    // -MARK: Config UI
    private func configUI() {
        self.view.backgroundColor = .systemBackground
        configNavigation()
        view.addSubview(inputStackView)
        configInputStackView()
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configInputStackView() {
        inputStackView.spacing = heightScaler(50)
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(40)),
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
        
        inputStackView.addArrangedSubview(emailStackView)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.spacing = heightScaler(10)
        emailLabel.setupTitle(text: "Email", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        emailLabel.textAlignment = .left
        emailStackView.addArrangedSubview(emailTextFieldContainer)
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
        
        inputStackView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.spacing = heightScaler(10)
        passwordLabel.setupTitle(text: "Password", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        passwordLabel.textAlignment = .left
        passwordStackView.addArrangedSubview(passwordTextFieldContainer)
        passwordTextFieldContainer.addRoundedTextField(passwordTextField)
        passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
        
        inputStackView.addArrangedSubview(confirmPasswordStackView)
        confirmPasswordStackView.addArrangedSubview(confirmPasswordLabel)
        confirmPasswordStackView.spacing = heightScaler(10)
        confirmPasswordLabel.setupTitle(text: "Confirm Password", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        confirmPasswordLabel.textAlignment = .left
        confirmPasswordStackView.addArrangedSubview(confirmPasswordTextFieldContainer)
        confirmPasswordTextFieldContainer.addRoundedTextField(confirmPasswordTextField)
        confirmPasswordTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
    }
    
    // -MARK: Setup Data
    private func setupData() {
        self.nameTextField.text = self.viewModel.accountCreation?.name
        self.emailTextField.text = self.viewModel.accountCreation?.email
        self.phoneTextField.text = self.viewModel.accountCreation?.phone
        self.passwordTextField.text = self.viewModel.accountCreation?.password
        self.confirmPasswordTextField.text = self.viewModel.accountCreation?.password
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        self.viewModel.accountCreationResultSubject
            .sink { [weak self] completion in
                switch completion {
                case .success:
                    self?.displaySucces(message: "Creation account success")
                case .failure(let error):
                    self?.displayErrorAlert(message: "Error \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.accountUpdateResultSubject
            .sink { [weak self] completion in
                switch completion {
                case .success:
                    self?.displaySucces(message: "Update account success")
                case .failure(let error):
                    self?.displayErrorAlert(message: "Error \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
        
        emailExistedSubject
            .sink { [weak self] completion in
                switch completion {
                case .success (let email):
                    self?.viewModel.setEmail(email: email)
                    self?.setAccount()
                case .failure(let error):
                    print("Error \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    // -MARK: Catch Action
    @objc
    private func cancelButtonTapped() {
        self.dismissViewController()
    }
    
    @objc
    private func doneButtonTapped() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let phone = phoneTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            return
        }
        guard validateName(name: name),
              validatePhone(phone: phone),
              validateEmail(email: email) else {
            return
        }
        validatePassword(password: password, confirmPassword: confirmPassword)
        
        self.viewModel.setName(name: name)
        self.viewModel.setPhone(phone: phone)
        self.viewModel.setPassword(password: password)
        
        if self.viewModel.accountCreation?.staffId != nil {
            self.isUpdate = true
        }
        
        if let initEmail = self.viewModel.initEmailWhenUpdate {
            if initEmail == email {
                self.emailExistedSubject.send(.success(email))
            } else {
                self.checkEmailExisted(email: email)
            }
        } else {
            self.checkEmailExisted(email: email)
        }
        
    }
    
    // MARK: -Utilities
    private func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displaySucces(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismissViewController()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func dismissViewController() {
        dismissCompletion?()
        self.dismiss(animated: true)
    }
    
    private func validateName(name: String) -> Bool {
        if !self.viewModel.validateName(name) {
            self.displayErrorAlert(message: self.viewModel.alertMessage)
            self.viewModel.alertMessage = ""
            return false
        }
        
        return true
    }
    
    private func validatePhone(phone: String) -> Bool {
        if !self.viewModel.validatePhoneNumber(phone) {
            self.displayErrorAlert(message: self.viewModel.alertMessage)
            self.viewModel.alertMessage = ""
            return false
        }
        
        return true
    }
    
    private func validateEmail(email: String) -> Bool {
        if !self.viewModel.validateEmail(email) {
            self.displayErrorAlert(message: self.viewModel.alertMessage)
            self.viewModel.alertMessage = ""
            return false
        }
        
        return true
    }
    
    private func checkEmailExisted(email: String) {
        self.viewModel.checkEmailExisted(email: email)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.emailExistedSubject.send(.failure(error))
                }
            } receiveValue: { [weak self] isExisted in
                if isExisted {
                    self?.displayErrorAlert(message: "Email is existed")
                } else {
                    self?.emailExistedSubject.send(.success(email))
                }
            }
            .store(in: &cancellables)
    }
    
    private func setAccount() {
        if let accessToken = UserSessionManager.shared.getAccessToken() {
            if isUpdate {
                self.viewModel.updateAccount(model: self.viewModel.getUserRegistration(), accessToken: accessToken)
            } else {
                self.viewModel.createAccount(model: self.viewModel.getUserRegistration(), accessToken: accessToken)
            }
        }
    }
    
    private func validatePassword(password: String, confirmPassword: String) {
        if !self.viewModel.validatePassword(password, confirmPassword) {
            self.displayErrorAlert(message: self.viewModel.alertMessage)
            self.viewModel.alertMessage = ""
        }
    }
}

extension AccountInputViewController: UITextFieldDelegate {
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

// -MARK: Preview
struct AccountInputViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let accountCreation = CreateAccountModel(email: "tin@gmail.com", password: "tin123445", name: "Tin", phone: "0358887710")
            let accountInputViewModel: AccountInputViewModelProtocol = AccountInputViewModel()
            accountInputViewModel.accountCreation = accountCreation
            let accountInputViewController = AccountInputViewController(viewModel: accountInputViewModel)
            return accountInputViewController
        }
    }
}

