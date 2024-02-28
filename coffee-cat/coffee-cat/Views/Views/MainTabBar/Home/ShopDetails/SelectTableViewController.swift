//
//  SelectTableViewController.swift
//  coffee-cat
//
//  Created by Tin on 25/02/2024.
//

import UIKit
import SwiftUI

class SelectTableViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var areaList: [Area] = []
    var didSelectSeat: ((Seat?) -> Void)?
    var availableToSubmit: Int = 0
    var submitSeat: Seat?
    
    // MARK: - Create UIComponents
    lazy var datePicker = makeDatePicker()
    lazy var areaTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var noteStack = makeVerticalStackView()
    
    lazy var selectStack = makeHorizontalStackView()
    lazy var selectView = makeView()
    lazy var select = makeLabel()
    
    lazy var notSelectStack = makeHorizontalStackView()
    lazy var notSelectView = makeView()
    lazy var notSelect = makeLabel()
    
    lazy var disableStack = makeHorizontalStackView()
    lazy var disableView = makeView()
    lazy var disable = makeLabel()
    
    lazy var noteLabel = makeLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    private func setupUI() {
        configAppearance()
        configNavigation()
        
        view.addSubview(noteStack)
        setupStackData()
        configNoteStack()
        
        view.addSubview(areaTableView)
        configAreaTableView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray6
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .customPink
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .customPink
        
        let datePicker = UIBarButtonItem(customView: datePicker)
        configDatePicker()
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = widthScaler(100)
        
        self.navigationItem.leftBarButtonItems = [cancelButton, space, datePicker]
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        datePicker.tintColor = .customBlack
    }
    
    private func setupStackData() {
        selectView.widthAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        selectView.heightAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        selectView.layer.cornerRadius = sizeScaler(10)
        selectView.backgroundColor = .systemBlue
        selectView.layer.borderColor = UIColor(resource: .customBlack).cgColor
        selectView.layer.borderWidth = widthScaler(4)
        
        select.setupTitle(text: "Currently selected location", fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        select.textAlignment = .left
        
        notSelectView.widthAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        notSelectView.heightAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        notSelectView.layer.cornerRadius = sizeScaler(10)
        notSelectView.backgroundColor = .systemBlue
        
        notSelect.setupTitle(text: "Position is ready to choose", fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        notSelect.textAlignment = .left
        
        disableView.widthAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        disableView.heightAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        disableView.layer.cornerRadius = sizeScaler(10)
        disableView.backgroundColor = .systemGray3
        
        disable.setupTitle(text: "Position is not available", fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        disable.textAlignment = .left
        
        noteLabel.setupTitle(text: "The app only allows booking one table\nSorry for the inconvenience", fontName: FontNames.avenir, size: sizeScaler(28), textColor: .systemRed)
        noteLabel.setBoldText()
        noteLabel.textAlignment = .left
    }
    
    private func configNoteStack() {
        noteStack.spacing = heightScaler(10)
        NSLayoutConstraint.activate([
            noteStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(20)),
            noteStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(80)),
            noteStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-80)),
        ])
        
        noteStack.addArrangedSubview(selectStack)
        selectStack.spacing = widthScaler(30)
        selectStack.addArrangedSubview(selectView)
        selectStack.addArrangedSubview(select)
        
        noteStack.addArrangedSubview(notSelectStack)
        notSelectStack.spacing = widthScaler(30)
        notSelectStack.addArrangedSubview(notSelectView)
        notSelectStack.addArrangedSubview(notSelect)
        
        noteStack.addArrangedSubview(disableStack)
        disableStack.spacing = widthScaler(30)
        disableStack.addArrangedSubview(disableView)
        disableStack.addArrangedSubview(disable)
        
        noteStack.addArrangedSubview(noteLabel)
    }
    
    private func configAreaTableView() {
        areaTableView.delegate = self
        areaTableView.dataSource = self
        areaTableView.register(AreaTableViewCell.self, forCellReuseIdentifier: AreaTableViewCell.identifier)
        areaTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            areaTableView.topAnchor.constraint(equalTo: noteStack.bottomAnchor, constant: heightScaler(10)),
            areaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            areaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            areaTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        self.datePicker.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
    }
    
    // MARK: - Catch Action
    @objc 
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
        self.didSelectSeat?(nil)
    }
    
    @objc 
    private func doneButtonTapped() {
        if availableToSubmit != 0 {
            self.didSelectSeat?(submitSeat!)
            self.dismiss(animated: true)
        } else {
            self.displayErrorAlert()
        }
    }
    
    @objc
    private func dateChange(_ datePicker: UIDatePicker) {
        print(datePicker.date)
        DispatchQueue.main.async {
            self.datePicker.endEditing(true)
        }
    }
    
    @objc
    private func datePickerTapped() {
        datePicker.becomeFirstResponder()
    }
    
    // MARK: - Utitlities
    private func displayErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please choose table to submit\nYou can close without submit by click close button", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SelectTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(240)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.areaList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.areaList[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaTableViewCell.identifier, for: indexPath) as? AreaTableViewCell else {
            return UITableViewCell()
        }
        
        if let seatList = self.areaList[indexPath.section].seatList {
            cell.configure(seatList: seatList)
        }
        
        cell.didSelectSeat = { [weak self] selectedSeat, availableToSubmit in
            self?.submitSeat = selectedSeat
            if availableToSubmit {
                self?.availableToSubmit += 1
                print(self?.availableToSubmit as Any)
            } else {
                self?.availableToSubmit -= 1
                print(self?.availableToSubmit as Any)
            }
        }
        
        return cell
    }
}

extension SelectTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select")
    }
    
}

// -MARK: Preview
struct SelectTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let selectTableViewController = SelectTableViewController()
            return selectTableViewController
        }
    }
}
