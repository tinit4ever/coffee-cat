//
//  ViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI

class GettingStartedViewController: UIViewController, GettingStartedFactory{
    private lazy var viewModel: GettingStartedViewModel = {
        return GettingStartedViewModel()
    }()
    
    private lazy var getStartedTitleLabel: UILabel = makeLabel()
    
    private lazy var getStartedContentLabel: UILabel = makeLabel()
    
    private lazy var getStartedButton: UIButton = makeButton(backgroundColor: UIColor(named: "CustomPink")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateContent()
        setupUI()
    }
    
    func populateContent() {
        getStartedTitleLabel.text = viewModel.title
        getStartedContentLabel.text = viewModel.content
    }
    
    
    func setupUI() {
        view.backgroundColor = .systemMint
        let backgroundImage = UIImageView(image: UIImage(named: "getting-started-background"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = view.bounds
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(getStartedTitleLabel)
        getStartedTitleLabel.customizeLabel(fontName: "Arial Rounded MT Bold", size: 20, textColor: .black)
        
        view.addSubview(getStartedContentLabel)
        getStartedContentLabel.customizeLabel(fontName: "Chalkboard SE", size: 16, textColor: .black)
        
        getStartedButton.customizeButton(cornerRadius: 20)
        getStartedButton.titleLabel!.font = UIFont.systemFont(ofSize: 70)
        view.addSubview(getStartedButton)
        
        NSLayoutConstraint.activate([
            getStartedTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 7 * 4)
        ])
        
        NSLayoutConstraint.activate([
            getStartedContentLabel.topAnchor.constraint(equalTo: getStartedTitleLabel.bottomAnchor, constant: 20),
            getStartedContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getStartedContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50)
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
