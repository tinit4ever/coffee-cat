//
//  ScrollViewController.swift
//  coffee-cat
//
//  Created by Tin on 25/02/2024.
//

import UIKit

class ScrollViewController: UIViewController, UIFactory {
    lazy var label = UILabel()
    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        // Add other customization as needed
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        view.addSubview(popupView)
        hidePopup()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.topAnchor.constraint(equalTo: view.topAnchor),
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -500),
        ])
        
        let button = UIButton()
        button.setTitle(title: "A", fontName: FontNames.avenir, size: 20, color: .red)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        let button2 = UIButton()
        button2.setTitle(title: "A", fontName: FontNames.avenir, size: 20, color: .red)
        button2.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(button2)
        NSLayoutConstraint.activate([
            button2.topAnchor.constraint(equalTo: view.topAnchor),
            button2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button2.heightAnchor.constraint(equalToConstant: 50),
        ])
        button2.addTarget(self, action: #selector(tapped2), for: .touchUpInside)
        
    }
    
    private func scrollView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.text = "As a passionate Vietnamese software engineer aspiring for success in the vast field of technology, I strive to embrace minimalism in both my professional and personal life. With the ability to discuss technologies for hours, I am dedicated to reaching the pinnacle of achievement in my role as a software engineer. Continuous learning and growth drive my journey, and I eagerly look forward to the challenges and innovations that lie ahead in this dynamic and ever-evolving industry."
        label.font = .boldSystemFont(ofSize: 50)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 600),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func showPopup() {
        popupView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 1
        }
    }
    
    func hidePopup() {
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 0
        }
    }
    
    @objc func tapped() {
        showPopup()
    }
    
    @objc func tapped2() {
        hidePopup()
    }
}
