//
//  UserProfileViewController.swift
//  coffee cat
//
//  Created by Tin on 19/01/2024.
//

import UIKit
import SwiftUI

class UserProfileInputViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: RegistrationViewModelProtocol?
    
    var gender: String?
    
    // -MARK: Create UI Components
    lazy var nameStackView: UIStackView = makeVerticalStackView()
    lazy var nameLabel: UILabel = makeLabel()
    lazy var nameTextFieldContainer: UIView = makeRoundedContainer()
    lazy var nameTextField: UITextField = makeTextField(placeholder: UserProfileInputScreenText.nameTextFieldPlaceholder)
    
    lazy var phoneNumberStackView: UIStackView = makeVerticalStackView()
    lazy var phoneNumberLabel: UILabel = makeLabel()
    lazy var phoneNumberTextFieldContainer: UIView = makeRoundedContainer()
    lazy var phoneNumberTextField: UITextField = makeTextField(placeholder: "Enter your phone number here")
    
    lazy var dobStackView: UIStackView = makeVerticalStackView()
    lazy var dobLabel: UILabel = makeLabel()
    lazy var datePickerContainer = makeRoundedContainer()
    
    lazy var datePicker = makeDatePicker()
    lazy var doneButton = makeButton()
    lazy var dateLabel = makeLabel()
    
    lazy var genderStackView = makeVerticalStackView()
    lazy var genderLabel = makeLabel()
    lazy var firstGenderStackView = makeHorizontalStackView()
    lazy var secondGenderStackView = makeHorizontalStackView()
    
    lazy var manRadio = makeRadioButtonStackView(content: "Man")
    lazy var womanRadio = makeRadioButtonStackView(content: "Woman")
    lazy var nonBinaryRadio = makeRadioButtonStackView(content: "Non-binary")
    lazy var somethingElseRadio = makeRadioButtonStackView(content: "Something else")
    lazy var preferNotToSayRadio = makeRadioButtonStackView(content: "Prefer not to say")
    
    lazy var submitButton = makeButton()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    // -MARK: SetupUI
    private func setupUI() {
        configAppearance()
        
        configNavigation()
        
        view.addSubview(nameStackView)
        configNameStackView()
        
        view.addSubview(phoneNumberStackView)
        configPhoneNumberStackView()
        
        view.addSubview(dobStackView)
        configDobStackView()
        
        
        datePickerValueChanged()
        
        view.addSubview(datePicker)
        configDatePicker()
        
        view.addSubview(doneButton)
        configDoneButton()
        
        view.addSubview(genderStackView)
        configGenderButtons()
        
        view.addSubview(submitButton)
        configSubmitButton()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray5
        
        removeCircleGroupImageView()
        checkAndChangeAppearancceMode()
    }
    
    func removeCircleGroupImageView() {
        for subview in view.subviews {
            if let imageView = subview as? UIImageView,
               let imageName = imageView.image?.accessibilityIdentifier,
               (imageName == ImageNames.darkCircleGroup || imageName == ImageNames.lightCircleGroup)
            {
                imageView.removeFromSuperview()
            }
        }
    }
    
    func checkAndChangeAppearancceMode() {
        if traitCollection.userInterfaceStyle == .dark {
            let image = UIImage(named: ImageNames.darkCircleGroup)
            image?.accessibilityIdentifier = ImageNames.darkCircleGroup
            
            let resizedImage = image?.resized(to: CGSize(width: widthScaler(700), height: heightScaler(200)))
            
            let imageView = UIImageView(image: resizedImage)
            imageView.image?.accessibilityIdentifier = ImageNames.darkCircleGroup
            
            view.addSubview(imageView)
            
        } else {
            let image = UIImage(named: ImageNames.darkCircleGroup)
            image?.accessibilityIdentifier = ImageNames.darkCircleGroup
            
            let resizedImage = image?.resized(to: CGSize(width: widthScaler(700), height: heightScaler(200)))
            
            let imageView = UIImageView(image: resizedImage)
            imageView.image?.accessibilityIdentifier = ImageNames.darkCircleGroup
            
            view.addSubview(imageView)
            
        }
    }
    
    private func configNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.right.circle.fill"), style: .plain, target: self, action: #selector(skipButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .customBlack
    }
    
    // -MARK: Config UI
    private func configNameStackView() {
        nameStackView.spacing = heightScaler(20)
        nameStackView.contentMode = .topLeft
        nameStackView.addArrangedSubview(nameLabel)
        nameLabel.setupTitle(text: UserProfileInputScreenText.nameLabel, fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        nameLabel.setBoldText()
        nameLabel.textAlignment = .left
        
        nameStackView.addArrangedSubview(nameTextFieldContainer)
        nameTextFieldContainer.addRoundedTextField(nameTextField)
        nameTextFieldContainer.backgroundColor = .textFieldContainer
        
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightScaler(200)),
            nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        NSLayoutConstraint.activate([
            nameTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configPhoneNumberStackView() {
        phoneNumberStackView.spacing = heightScaler(20)
        phoneNumberStackView.contentMode = .topLeft
        phoneNumberStackView.addArrangedSubview(phoneNumberLabel)
        phoneNumberLabel.setupTitle(text: "Phone Number", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        phoneNumberLabel.setBoldText()
        phoneNumberLabel.textAlignment = .left
        
        phoneNumberStackView.addArrangedSubview(phoneNumberTextFieldContainer)
        phoneNumberTextFieldContainer.addRoundedTextField(phoneNumberTextField)
        phoneNumberTextFieldContainer.backgroundColor = .textFieldContainer
        
        NSLayoutConstraint.activate([
            phoneNumberStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: heightScaler(40)),
            phoneNumberStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            phoneNumberStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        NSLayoutConstraint.activate([
            phoneNumberTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configDobStackView() {
        dobStackView.spacing = heightScaler(20)
        dobStackView.contentMode = .topLeft
        dobStackView.addArrangedSubview(dobLabel)
        dobLabel.setupTitle(text: UserProfileInputScreenText.dobLabel, fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        dobLabel.setBoldText()
        dobLabel.textAlignment = .left
        
        dobStackView.addArrangedSubview(datePickerContainer)
        datePickerContainer.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            dobStackView.topAnchor.constraint(equalTo: phoneNumberStackView.bottomAnchor, constant: heightScaler(40)),
            dobStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            dobStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        
        configDatePickerContainer()
    }
    
    private func configDatePickerContainer() {
        datePickerContainer.backgroundColor = .textFieldContainer
        datePickerContainer.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor, constant: widthScaler(50)),
            dateLabel.centerYAnchor.constraint(equalTo: datePickerContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            datePickerContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configDatePicker() {
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func configDoneButton() {
        doneButton.removeBackground()
        doneButton.setTitle(title: UserProfileInputScreenText.doneButtonTitle, fontName: FontNames.avenir, size: sizeScaler(30), color: .systemBlue)
        doneButton.isHidden = true
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(30)),
            doneButton.bottomAnchor.constraint(equalTo: datePicker.topAnchor)
        ])
    }
    
    private func configGenderButtons() {
        genderStackView.alignment = .leading
        genderStackView.spacing = heightScaler(20)
        NSLayoutConstraint.activate([
            genderStackView.topAnchor.constraint(equalTo: dobStackView.bottomAnchor, constant: heightScaler(40)),
            genderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            genderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60))
        ])
        
        genderLabel.setupTitle(text: "Gender", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        genderLabel.setBoldText()
        genderLabel.textAlignment = .left
        genderStackView.addArrangedSubview(genderLabel)
        genderStackView.addArrangedSubview(firstGenderStackView)
        genderStackView.addArrangedSubview(secondGenderStackView)
        
        firstGenderStackView.addArrangedSubview(manRadio)
        firstGenderStackView.addArrangedSubview(womanRadio)
        firstGenderStackView.addArrangedSubview(nonBinaryRadio)
        firstGenderStackView.distribution = .equalSpacing
        
        secondGenderStackView.addArrangedSubview(somethingElseRadio)
        secondGenderStackView.addArrangedSubview(preferNotToSayRadio)
        secondGenderStackView.spacing = widthScaler(60)
        secondGenderStackView.distribution = .equalCentering
    }
    
    private func configSubmitButton() {
        submitButton.cornerRadius(cornerRadius: heightScaler(30))
        submitButton.setTitle(title: "Submit", fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        submitButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(60)),
            submitButton.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    // -MARK: Supporting
    private func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToHome() {
        let homeViewController = MainTabBarViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            window?.rootViewController = homeViewController
            window?.makeKeyAndVisible()
        }
    }
    
    private func showDatePicker() {
        DispatchQueue.main.async { [weak self] in
            self?.datePicker.isHidden = false
            self?.doneButton.isHidden = false
            self?.submitButton.isHidden = true
            self?.genderStackView.isHidden = true
        }
        
    }
    
    private func hideDatePicker() {
        DispatchQueue.main.async { [weak self] in
            self?.datePicker.isHidden = true
            self?.doneButton.isHidden = true
            self?.submitButton.isHidden = false
            self?.genderStackView.isHidden = false
        }
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        datePickerContainer.addGestureRecognizer(tapGesture)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let manRadioGesture = UITapGestureRecognizer(target: self, action: #selector(manRadioTapped))
        manRadio.addGestureRecognizer(manRadioGesture)
        
        let womanRadioGesture = UITapGestureRecognizer(target: self, action: #selector(womanRadioTapped))
        womanRadio.addGestureRecognizer(womanRadioGesture)
        
        let nonBinaryRadioGesture = UITapGestureRecognizer(target: self, action: #selector(nonBinaryRadioTapped))
        nonBinaryRadio.addGestureRecognizer(nonBinaryRadioGesture)
        
        let somethingElseRadioGesture = UITapGestureRecognizer(target: self, action: #selector(somethingElseRadioTapped))
        somethingElseRadio.addGestureRecognizer(somethingElseRadioGesture)
        
        let preferNotToSayRadioGesture = UITapGestureRecognizer(target: self, action: #selector(preferNotToSayRadioTapped))
        preferNotToSayRadio.addGestureRecognizer(preferNotToSayRadioGesture)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    // -MARK: Catch Action
    @objc
    private func skipButtonTapped() {
        pushToHome()
    }
    
    @objc
    private func viewTapped() {
        view.endEditing(true)
        showDatePicker()
    }
    
    @objc
    private func manRadioTapped() {
        resetRatioButtons()
        manRadio.subviews.enumerated().forEach { index, view in
            if let button = view as? UIButton {
                button.ratioButton(true)
            } else if let label = view as? UILabel,
                      let gender = label.text
            {
                self.gender = gender
            }
        }
    }
    
    @objc
    private func womanRadioTapped() {
        resetRatioButtons()
        womanRadio.subviews.enumerated().forEach { index, view in
            if let button = view as? UIButton {
                button.ratioButton(true)
            } else if let label = view as? UILabel,
                      let gender = label.text
            {
                self.gender = gender
            }
        }
    }
    
    @objc
    private func nonBinaryRadioTapped() {
        resetRatioButtons()
        nonBinaryRadio.subviews.enumerated().forEach { index, view in
            if let button = view as? UIButton {
                button.ratioButton(true)
            } else if let label = view as? UILabel,
                      let gender = label.text
            {
                self.gender = gender
            }
        }
    }
    
    @objc
    private func somethingElseRadioTapped() {
        resetRatioButtons()
        somethingElseRadio.subviews.enumerated().forEach { index, view in
            if let button = view as? UIButton {
                button.ratioButton(true)
            } else if let label = view as? UILabel,
                      let gender = label.text
            {
                self.gender = gender
            }
        }
    }
    
    @objc
    private func preferNotToSayRadioTapped() {
        resetRatioButtons()
        preferNotToSayRadio.subviews.enumerated().forEach { index, view in
            if let button = view as? UIButton {
                button.ratioButton(true)
            } else if let label = view as? UILabel,
                      let gender = label.text
            {
                self.gender = gender
            }
        }
    }
    
    @objc
    private func doneButtonTapped() {
        hideDatePicker()
    }
    
    @objc
    private func datePickerValueChanged() {
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatter
        dateLabel.setupTitle(text: "\(dateFormatter.string(from: selectedDate))", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
    }
    
    @objc
    private func submitButtonTapped() {
        guard let name = nameTextField.text,
              let phoneNumber = phoneNumberTextField.text,
              let viewModel = self.viewModel,
              viewModel.validateName(name),
              viewModel.validatePhoneNumber(phoneNumber),
              viewModel.validateDob(datePicker.date) else {
            displayInvalidInput(self.viewModel!.alertMessage)
            self.viewModel?.alertMessage = ""
            return
        }
        
        self.viewModel?.updateUserProfile(name, phoneNumber, datePicker.date, gender ?? "")
        
        pushToHome()
    }
    
    // -MARK: Display Alert
    private func displayInvalidInput(_ message: String) {
        let alert = UIAlertController(title: "Input Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // -MARK: Utilities
    private func resetRatioButtons() {
        let allStackViews: [UIStackView] = [manRadio, womanRadio, nonBinaryRadio, somethingElseRadio, preferNotToSayRadio]
        
        for stackView in allStackViews {
            stackView.subviews.compactMap { $0 as? UIButton }.forEach {
                $0.ratioButton(false)
            }
        }
    }
}

extension UserProfileInputViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideDatePicker()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
    }
}

// -MARK: Preview
struct UserProfileViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let userProfileViewController = UserProfileInputViewController()
            return userProfileViewController
        }
    }
}
