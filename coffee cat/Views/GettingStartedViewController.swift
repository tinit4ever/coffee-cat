//
//  ViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI

class GettingStartedViewController: UIViewController, UIFactory {
    
    // -MARK: Create UI Components
    private lazy var getStartedTitleLabel: UILabel = makeLabel()
    
    private lazy var getStartedContentLabel: UILabel = makeLabel()
    
    private lazy var getStartedButton: UIButton = makeButton()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // -MARK: SetupUI
    
    func setupUI() {
        view.backgroundColor = .systemMint
        let backgroundImage = UIImageView(image: UIImage(named: ImageNames.gettingStartedBackground))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = view.bounds
        view.insertSubview(backgroundImage, at: 0)
        
        //getStartedTitleLabel
        view.addSubview(getStartedTitleLabel)
        getStartedTitleLabel.setupTitle(text: GettingStartedScreenText.gettingStartedTitle, fontName: FontNames.avenir , size: 29, textColor: .black)
        getStartedTitleLabel.setBoldText()
        getStartedTitleLabelContrains()
        
        //getStartedContentLabel
        view.addSubview(getStartedContentLabel)
        getStartedContentLabel.setupTitle(text: GettingStartedScreenText.getStartedContent, fontName: FontNames.avenir, size: 20, textColor: .black)
        getStartedContentLabelContrains()
        
        //getStartedButtonContrains
        view.addSubview(getStartedButton)
        getStartedButton.makeCornerRadius(cornerRadius: 20)
        getStartedButton.makeTitle(title: GettingStartedScreenText.getStartedButtonTitle, fontName: FontNames.avenir, size: 30, color: .white)
        getStartedButton.backgroundColor = .customPink
        getStartedButtonContrains()
    }
    
    func getStartedTitleLabelContrains() {
        NSLayoutConstraint.activate([
            getStartedTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2)
        ])
    }
    
    func getStartedContentLabelContrains() {
        NSLayoutConstraint.activate([
            getStartedContentLabel.topAnchor.constraint(equalTo: getStartedTitleLabel.bottomAnchor, constant: 20),
            getStartedContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getStartedContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    func getStartedButtonContrains() {
        NSLayoutConstraint.activate([
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            getStartedButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

// -MARK: Preview
struct GettingStartedViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let gettingStartedViewControllerPreview = GettingStartedViewController()
            return gettingStartedViewControllerPreview
        }
    }
}
