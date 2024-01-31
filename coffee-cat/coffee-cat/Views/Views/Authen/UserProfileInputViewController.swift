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
    
    // -MARK: Create UI Components
    lazy var nameStackView: UIStackView = makeVerticalStackView()
    lazy var nameLabel: UILabel = makeLabel()
    lazy var nameTextFieldContainer: UIView = makeRoundedContainer()
    lazy var nameTextField: UITextField = makeTextField(placeholder: UserProfileInputScreenText.nameTextFieldPlaceholder)
    
    lazy var dobStackView: UIStackView = makeVerticalStackView()
    lazy var dobLabel: UILabel = makeLabel()
    lazy var datePickerContainer = makeRoundedContainer()
    
    lazy var datePicker = makeDatePicker()
    lazy var doneButton = makeButton()
    lazy var dateLabel = makeLabel()
    
    lazy var genreStackView = makeVerticalStackView()
    lazy var genreLabel = makeLabel()
    lazy var firstGenreStackView = makeHorizontalStackView()
    lazy var secondGenreStackView = makeHorizontalStackView()
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
        
        view.addSubview(dobStackView)
        configDobStackView()
        
        datePickerValueChanged()
        
        view.addSubview(datePicker)
        configDatePicker()
        
        view.addSubview(doneButton)
        configDoneButton()
        
        view.addSubview(genreStackView)
        configGenreButtons()
        
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.right.circle.fill")?.resized(to: CGSize(width: sizeScaler(50), height: sizeScaler(50))), style: .plain, target: self, action: #selector(skipButtonTapped))
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
        nameTextFieldContainer.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightScaler(200)),
            nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        NSLayoutConstraint.activate([
            nameTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
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
            dobStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: heightScaler(60)),
            dobStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            dobStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        
        configDatePickerContainer()
    }
    
    private func configDatePickerContainer() {
        datePickerContainer.backgroundColor = .systemBackground
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
    
    private func configGenreButtons() {
        genreStackView.alignment = .leading
        genreStackView.spacing = heightScaler(20)
        NSLayoutConstraint.activate([
            genreStackView.topAnchor.constraint(equalTo: dobStackView.bottomAnchor, constant: heightScaler(60)),
            genreStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            genreStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60))
        ])
        
        genreLabel.setupTitle(text: "Genre", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        genreLabel.setBoldText()
        genreLabel.textAlignment = .left
        genreStackView.addArrangedSubview(genreLabel)
        genreStackView.addArrangedSubview(firstGenreStackView)
        genreStackView.addArrangedSubview(secondGenreStackView)
        
        firstGenreStackView.addArrangedSubview(manRadio)
        firstGenreStackView.addArrangedSubview(womanRadio)
        firstGenreStackView.addArrangedSubview(nonBinaryRadio)
        firstGenreStackView.distribution = .equalSpacing
        
        secondGenreStackView.addArrangedSubview(somethingElseRadio)
        secondGenreStackView.addArrangedSubview(preferNotToSayRadio)
        secondGenreStackView.spacing = widthScaler(60)
        secondGenreStackView.distribution = .equalCentering
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
        let homeViewController = HomeViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            window?.rootViewController = homeViewController
            window?.makeKeyAndVisible()
        }
    }
    
    private func showDatePicker() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.datePicker.isHidden = false
            self?.doneButton.isHidden = false
            self?.submitButton.isHidden = true
        }
        
    }
    
    private func hideDatePicker() {
        datePicker.isHidden = true
        doneButton.isHidden = true
        
        submitButton.isHidden = false
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        nameTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        datePickerContainer.addGestureRecognizer(tapGesture)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
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
        pushToHome()
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
