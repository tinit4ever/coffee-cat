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
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    // -MARK: SetupUI
    func setupUI() {
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
    }
    
    func configAppearance() {
        view.backgroundColor = .systemGray5
        
        removeCircleGroupImageView()
        checkAndChangeAppearancceMode()
    }
    
    func removeCircleGroupImageView() {
        for subview in view.subviews {
            if let imageView = subview as? UIImageView,
               imageView.image == UIImage(named: ImageNames.darkCircleGroup) ||
                imageView.image == UIImage(named: ImageNames.lightCircleGroup)
            {
                imageView.removeFromSuperview()
            }
        }
    }

    func checkAndChangeAppearancceMode() {
        if traitCollection.userInterfaceStyle == .dark {
            let imageView = UIImageView(image: UIImage(named: ImageNames.darkCircleGroup))
            view.addSubview(imageView)
        } else {
            let imageView = UIImageView(image: UIImage(named: ImageNames.lightCircleGroup))
            view.addSubview(imageView)
        }
    }
    
    func configNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .systemBackground
    }
    
    // -MARK: Config UI
    func configNameStackView() {
        nameStackView.spacing = heightScaler(20)
        nameStackView.contentMode = .topLeft
        nameStackView.addArrangedSubview(nameLabel)
        nameLabel.setupTitle(text: UserProfileInputScreenText.nameLabel, fontName: FontNames.avenir, size: 20, textColor: .customBlack)
        nameLabel.setBoldText()
        nameLabel.textAlignment = .left
        
        nameStackView.addArrangedSubview(nameTextFieldContainer)
        nameTextFieldContainer.addRoundedTextField(nameTextField)
        nameTextFieldContainer.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightScaler(200)),
            nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(30)),
        ])
        NSLayoutConstraint.activate([
            nameTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configDobStackView() {
        dobStackView.spacing = 10
        dobStackView.contentMode = .topLeft
        dobStackView.addArrangedSubview(dobLabel)
        dobLabel.setupTitle(text: UserProfileInputScreenText.dobLabel, fontName: FontNames.avenir, size: 20, textColor: .customBlack)
        dobLabel.setBoldText()
        dobLabel.textAlignment = .left
        
        dobStackView.addArrangedSubview(datePickerContainer)
        datePickerContainer.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            dobStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 30),
            dobStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dobStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
        configDatePickerContainer()
    }
    
    func configDatePickerContainer() {
        datePickerContainer.backgroundColor = .systemBackground
        datePickerContainer.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor, constant: 30),
            dateLabel.centerYAnchor.constraint(equalTo: datePickerContainer.centerYAnchor)
        ])
     
        NSLayoutConstraint.activate([
//            datePickerContainer.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 30),
//            datePickerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            datePickerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            datePickerContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configDatePicker() {
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configDoneButton() {
        doneButton.removeBackground()
        doneButton.setTitle(title: UserProfileInputScreenText.doneButtonTitle, fontName: FontNames.avenir, size: 20, color: .systemBlue)
        doneButton.isHidden = true
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: datePicker.topAnchor)
        ])
    }
    
    // -MARK: Setup Action
    func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        datePickerContainer.addGestureRecognizer(tapGesture)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    @objc func viewTapped() {
        datePicker.isHidden = false
        doneButton.isHidden = false
        datePickerContainer.backgroundColor = .systemGray4
    }
    
    @objc func doneButtonTapped() {
        datePicker.isHidden = true
        doneButton.isHidden = true
        datePickerContainer.backgroundColor = .systemBackground
    }
    
    @objc func datePickerValueChanged() {
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatter
        dateLabel.setupTitle(text: "\(dateFormatter.string(from: selectedDate))", fontName: FontNames.avenir, size: 20, textColor: .customBlack)
    }
}

// -MARK: Preview
struct UserProfileViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let userProfileViewController = UserProfileInputViewController()
            userProfileViewController.navigationItem.title = "User Profile"
            return userProfileViewController
        }
    }
}
