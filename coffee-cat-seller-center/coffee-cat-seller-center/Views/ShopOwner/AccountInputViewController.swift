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
        self.nameTextField.text = self.viewModel.userRegistration?.name
        self.emailTextField.text = self.viewModel.userRegistration?.email
        self.passwordTextField.text = self.viewModel.userRegistration?.password
        self.confirmPasswordTextField.text = self.viewModel.userRegistration?.password
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
    
    // -MARK: Catch Action
    @objc
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func doneButtonTapped() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            return
        }
        guard validateName(name: name),
              validateEmail(email: email),
              checkEmailExistedAndValidatePassword(email: email, password: password, confirmPassword: confirmPassword) else {
            return
        }
        
        self.viewModel.setUserRegistration(name: name, email: email, password: password)
    }
    
    // MARK: -Utilities
    private func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func validateName(name: String) -> Bool {
        if !self.viewModel.validateName(name) {
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
    
    private func checkEmailExistedAndValidatePassword(email: String, password: String, confirmPassword: String) -> Bool {
        var result: Bool = false
        self.viewModel.checkEmailExisted(email: email)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] isExisted in
                if isExisted {
                    self?.displayErrorAlert(message: "Email is existed")
                    result = false
                } else {
                    result = self?.validatePassword(password: password, confirmPassword: confirmPassword) ?? false
                }
            }
            .store(in: &cancellables)
        
        return result
    }
    
    private func validatePassword(password: String, confirmPassword: String) -> Bool {
        if !self.viewModel.validatePassword(password, confirmPassword) {
            self.displayErrorAlert(message: self.viewModel.alertMessage)
            self.viewModel.alertMessage = ""
            return false
        }
        return true
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
        textField.text = ""
    }
}

// -MARK: Preview
struct AccountInputViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let userRegistration = UserRegistration(name: "Tin", email: "tin@gmail.com", password: "tin123445")
            var accountInputViewModel: AccountInputViewModelProtocol = AccountInputViewModel()
            accountInputViewModel.userRegistration = userRegistration
            let accountInputViewController = AccountInputViewController(viewModel: accountInputViewModel)
            return accountInputViewController
        }
    }
}

