//
//  CatViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import UIKit
import SwiftUI
import Combine

class CatViewController: UIViewController, CatFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: CatViewModelProtocol = CatViewModel()
    var cancellables: Set<AnyCancellable> = []
    private var selectedCatIds: [CatId] = [] {
        didSet {
            if selectedCatIds.isEmpty {
                self.setDeleteButtonEnabled(false)
            } else {
                self.setDeleteButtonEnabled(true)
            }
        }
    }
    
    // MARK: - Create UIComponents
    lazy var managerStack = makeHorizontalStackView()
    lazy var deleteCatButton = makeButton()
    lazy var catAnimation = makeLottieAnimationView(animationName: "cat")
    lazy var addCatButton = makeButton()
    
    lazy var areaTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAsync()
        setupData()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    // MARK: - Setup UI
    private func setupUI() {
        configAppearance()
        
        view.addSubview(managerStack)
        configManagerStack()
        
        view.addSubview(areaTableView)
        configAreaTableView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray6
    }
    
    private func configManagerStack() {
        managerStack.backgroundColor = .systemPurple
        managerStack.layer.cornerRadius = sizeScaler(10)
        managerStack.distribution = .equalCentering
        managerStack.layoutMargins = UIEdgeInsets(top: heightScaler(10), left: 30, bottom: heightScaler(10), right: 30)
        managerStack.isLayoutMarginsRelativeArrangement = true
        NSLayoutConstraint.activate([
            managerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(10)),
            managerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            managerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-30))
        ])
        managerStack.addArrangedSubview(deleteCatButton)
        deleteCatButton.isEnabled = false
        deleteCatButton.setImage(UIImage(systemName: "trash")?.withTintColor(.systemBackground, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(30), height: heightScaler(35))), for: .normal)

        managerStack.addArrangedSubview(catAnimation)
        catAnimation.contentMode = .scaleAspectFit
        catAnimation.play()
        catAnimation.heightAnchor.constraint(equalToConstant: heightScaler(35)).isActive = true
        catAnimation.widthAnchor.constraint(equalToConstant: heightScaler(55)).isActive = true
        
        managerStack.addArrangedSubview(addCatButton)
        addCatButton.setImage(UIImage(systemName: "plus")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(35))), for: .normal)
    }
    
    private func configAreaTableView() {
        areaTableView.delegate = self
        areaTableView.dataSource = self
        areaTableView.register(AreaCatTableViewCell.self, forCellReuseIdentifier: AreaCatTableViewCell.identifier)
        areaTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            areaTableView.topAnchor.constraint(equalTo: managerStack.bottomAnchor, constant: heightScaler(20)),
            areaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            areaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            areaTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(80))
        ])
    }
    
    // MARK: - Setup Async
    private func setupAsync() {
        self.viewModel.isGetDataSubject
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success():
                    self.areaTableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.isDeleteResponseSubject
            .sink { result in
                switch result {
                case .success():
                    self.selectedCatIds = []
                    self.viewModel.areaList = []
                    self.viewModel.selectedCat = []
                    self.showSuccess()
                    self.setupData()
                case .failure(let error):
                    self.showDeleteError(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Data
    private func setupData() {
        self.viewModel.getCatList()
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        self.addCatButton.addTarget(self, action: #selector(addCatButtonTapped), for: .touchUpInside)
        self.deleteCatButton.addTarget(self, action: #selector(deleteCatButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Catch Action
    @objc
    private func addCatButtonTapped() {
        let viewModel = InputCatViewModel()
        let areaList = self.viewModel.areaList
        
        viewModel.areaList = areaList
        guard let areaName = areaList.first?.areaName else {
            self.displayErrorAlert()
            return
        }
        viewModel.selectedAreaName = areaName
        
        let inputCatViewController = InputCatViewController(viewModel: viewModel)
        inputCatViewController.dismissCompletion = { [weak self] in
            self?.setupData()
        }
        let navigationController = UINavigationController(rootViewController: inputCatViewController)
        present(navigationController, animated: true)
    }
    
    @objc
    private func deleteCatButtonTapped() {
        self.viewModel.deleteCats()
    }
    
    // MARK: - Utitlities
    private func displayErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "You do not have any area", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showSuccess() {
        let alertController = UIAlertController(title: "Success", message: "Cat is deleted", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showDeleteError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getStringDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatterToStore
        return dateFormatter.string(from: date)
    }
    
    private func setDeleteButtonEnabled(_ isEnabled: Bool) {
        self.deleteCatButton.isEnabled = isEnabled
        var color: UIColor = .systemBackground
        if isEnabled {
            color = .systemRed
        } else {
            color = .systemBackground
        }
        deleteCatButton.setImage(UIImage(systemName: "trash")?.withTintColor(color, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(30), height: heightScaler(35))), for: .normal)
    }
}

extension CatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.areaList[section].areaName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.areaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaCatTableViewCell.identifier, for: indexPath) as? AreaCatTableViewCell else {
            return UITableViewCell()
        }
        
        let catList = self.viewModel.areaList[indexPath.section].cat
        cell.configure(catList: catList)
        
        cell.didSelectedCat = { [weak self] catId, isAdd in
            if isAdd {
                self?.selectedCatIds.append(catId)
            } else {
                if let indexToRemove = self?.selectedCatIds.firstIndex(where: { $0.catId == catId.catId }) {
                    self?.selectedCatIds.remove(at: indexToRemove)
                }
            }
            
            if let selectedCatIds = self?.selectedCatIds {
                print(selectedCatIds)
                self?.viewModel.selectedCat = selectedCatIds
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(440)
    }
}

extension CatViewController: UITableViewDelegate {
    
}

// -MARK: Preview
struct CatViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let catViewController = CatViewController()
            return catViewController
        }
    }
}
