//
//  ShopCreationInputViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 07/03/2024.
//

import UIKit
import SwiftUI
import Combine

class ShopCreationInputViewController: UIViewController, ShopCreationInputFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: ShopCreationInputViewModelProtocol = ShopCreationInputViewModel()
    var dismissCompletion: (() -> Void)?
    
    var cancellables: Set<AnyCancellable> = []
    
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
    
    lazy var recipientEmailStackView = makeVerticalStackView()
    lazy var recipientEmailLabel: UILabel = makeLabel()
    lazy var recipientEmailTextFieldContainer: UIView = makeRoundedContainer()
    lazy var recipientEmailTextField: UITextField = makeTextField(placeholder: "Enter recipient email")
    
    lazy var shopEmailStackView = makeVerticalStackView()
    lazy var shopEmailLabel: UILabel = makeLabel()
    lazy var shopEmailTextFieldContainer: UIView = makeRoundedContainer()
    lazy var shopEmailTextField: UITextField = makeTextField(placeholder: "Enter shopEmail")
    
    lazy var loadingAnimationView = makeLottieAnimationView(animationName: "loading")
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupData()
        setupAction()
        setupAsync()
    }
    
    // -MARK: Config UI
    private func configUI() {
        self.view.backgroundColor = .systemBackground
        configNavigation()
        
        view.addSubview(inputStackView)
        configInputStackView()
        
        view.addSubview(loadingAnimationView)
        configLoadingView()
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configInputStackView() {
        inputStackView.spacing = heightScaler(60)
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
        
        inputStackView.addArrangedSubview(recipientEmailStackView)
        recipientEmailStackView.addArrangedSubview(recipientEmailLabel)
        recipientEmailStackView.spacing = heightScaler(10)
        recipientEmailLabel.setupTitle(text: "Recipient Email", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        recipientEmailLabel.textAlignment = .left
        recipientEmailStackView.addArrangedSubview(recipientEmailTextFieldContainer)
        recipientEmailTextFieldContainer.addRoundedTextField(recipientEmailTextField)
        recipientEmailTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
        
        inputStackView.addArrangedSubview(shopEmailStackView)
        shopEmailStackView.addArrangedSubview(shopEmailLabel)
        shopEmailStackView.spacing = heightScaler(10)
        shopEmailLabel.setupTitle(text: "Shop Email", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        shopEmailLabel.textAlignment = .left
        shopEmailStackView.addArrangedSubview(shopEmailTextFieldContainer)
        shopEmailTextFieldContainer.addRoundedTextField(shopEmailTextField)
        shopEmailTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
    }
    
    private func configLoadingView() {
        loadingAnimationView.isHidden = true
        NSLayoutConstraint.activate([
            loadingAnimationView.widthAnchor.constraint(equalToConstant: sizeScaler(300)),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: sizeScaler(300)),
            loadingAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // -MARK: Setup Data
    private func setupData() {

    }
    
    // -MARK: Setup Action
    private func setupAction() {
        self.nameTextField.delegate = self
        self.phoneTextField.delegate = self
        self.recipientEmailTextField.delegate = self
        self.shopEmailTextField.delegate = self
    }
    
    // -MARK: Setup Async
    private func setupAsync() {
        self.viewModel.isCreatedShopSubject
            .sink { result in
                switch result {
                case .success(let message):
                    self.displaySucces(message: message)
                    self.hiddenLoadingView()
                case .failure(let error):
                    self.displayErrorAlert(message: error.localizedDescription)
                    self.hiddenLoadingView()
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
        self.showLoadingView()
        guard let name = nameTextField.text,
              let recipientEmail = recipientEmailTextField.text,
              let phone = phoneTextField.text,
              let shopEmail = shopEmailTextField.text
        else {
            return
        }
        
        let shopCreationModel = ShopCreationModel(name: name, email: recipientEmail, shopEmail: shopEmail, phone: phone)
        self.viewModel.setShopCreationModel(shopCreationModel: shopCreationModel)
        self.viewModel.createShop()
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
    
    private func showLoadingView() {
        self.loadingAnimationView.isHidden = false
        self.loadingAnimationView.play()
        self.view.isUserInteractionEnabled = false
    }
    
    private func hiddenLoadingView() {
        self.loadingAnimationView.isHidden = true
        self.loadingAnimationView.stop()
        self.view.isUserInteractionEnabled = true
    }
}

extension ShopCreationInputViewController: UITextFieldDelegate {
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
struct ShopCreationInputViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let shopCreationInputViewController = ShopCreationInputViewController()
            return shopCreationInputViewController
        }
    }
}
