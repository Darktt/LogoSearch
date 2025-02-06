//
//  SearchViewController.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/6.
//

import UIKit
import Combine

public class SearchViewController: UIViewController
{
    // MARK: - Properties -
    
    @IBOutlet private
    weak var textFieldBorderView: UIView!
    
    @IBOutlet private
    weak var textFieldInnerView: UIView!
    
    @IBOutlet fileprivate
    weak var textField: UITextField!
    
    @IBOutlet private
    weak var searchButton: UIButton!
    
    @IBOutlet private
    weak var notFoundView: UIView!
    
    @IBOutlet private
    weak var tableView: UITableView!
    
    private
    let store: LogoSearchStore = kLogoSearchStore
    
    private
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init()
    {
        super.init(nibName: "SearchViewController", bundle: nil)
        
    }
    
    internal required
    init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    public override
    func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
    // MARK: View Live Cycle
    
    public override
    func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    public override
    func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    public override
    func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
    
    public override
    func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
    }
    
    public override
    func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let title: String = "Logo Search"
        let placeholder: String = "Enter brand name…"
        let attrubutes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray]
        let attrubutedPlaceholder = NSAttributedString(string: placeholder, attributes: attrubutes)
        let cleanImage = UIImage(systemName: "xmark.circle.fill")
        let cleanButton = UIButton(type: .custom).fluent
                                                 .tintColor(.lightGray)
                                                 .subject
        cleanButton.setTitle("  ", for: .normal)
        cleanButton.setImage(cleanImage, for: .normal)
        cleanButton.addTarget(self, action: #selector(self.cleanAction(_:)), for: .touchUpInside)
        cleanButton.sizeToFit()
        
        self.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.textFieldBorderView.fluent
            .cornerRadius(10.0)
            .discardResult
        self.textFieldInnerView.fluent
            .cornerRadius(9.0)
            .discardResult
        self.textField.fluent
            .attributedPlaceholder(attrubutedPlaceholder)
            .autocorrectionType(.no)
            .rightView(cleanButton)
            .rightViewMode(.whileEditing)
            .discardResult
        self.searchButton.addTarget(self, action: #selector(self.searchAction(_:)), for: .touchUpInside)
        self.notFoundView.isHidden = true
        self.tableView.fluent
            .dataSource(self)
            .delegate(self)
            .separatorStyle(.none)
            .rowHeight(UITableView.automaticDimension)
            .estimatedRowHeight(UITableView.automaticDimension)
            .register(SearchCell.self)
            .discardResult
        
        self.setupSubscribes()
    }
    
    deinit
    {
        
    }
}

// MARK: - Actions -

private extension SearchViewController
{
    @objc
    func cleanAction(_ sender: UIButton)
    {
        self.textField.text = nil
        self.textField.becomeFirstResponder()
    }
    
    @objc
    func searchAction(_ sender: UIButton)
    {
        guard let keyword = self.textField.text else {
            
            return
        }
        
        self.sendSearchAction(with: keyword)
        self.notFoundView.isHidden = false
        self.tableView.isHidden = false
    }
}

// MARK: - Private Methons -

private
extension SearchViewController
{
    func setupSubscribes()
    {
        self.store
            .$state
            .throttle(for: 1.0, scheduler: DispatchQueue.main, latest: false)
            .sink {
                
                [weak self] state in
                
                self?.updateView(with: state)
            }
            .store(in: &self.cancellables)
    }
    
    func sendSearchAction(with keyword: String)
    {
        let request = BrandSearchRequest(keyword: keyword)
        let action = LogoSearchAction.search(request)
        
        self.store.dispatch(action)
    }
    
    func fetchImageAction(with imageUrl: URL, at indexPath: IndexPath)
    {
        let action = LogoSearchAction.fetchImage(imageUrl, indexPath)
        
        self.store.dispatch(action)
    }
    
    func updateView(with state: LogoSearchState)
    {
        let logoInfos: Array = state.logoInfos
        let isTableViewHidden = logoInfos.isEmpty
        
        self.tableView.isHidden = isTableViewHidden
        self.tableView.reloadData()
        
        if let error = state.error {
            
            self.presentErrorAlert(with: error)
        }
    }
}

// MARK: - Delegate Methods -
// MARK: #UITableViewDataSource

extension SearchViewController: UITableViewDataSource
{
    public
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let state = self.store.state
        let logoInfos: Array = state.logoInfos
        
        return logoInfos.count
    }
    
    public
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(SearchCell.self, for: indexPath) else {
            
            return UITableViewCell()
        }
        
        let state = self.store.state
        let logoInfos: Array = state.logoInfos
        let logoInfo = logoInfos[indexPath.row]
        let image: UIImage? = state.cachedImages[indexPath]
        
        if image == nil, let imageUrl: URL = logoInfo.imageUrl {
            
            self.fetchImageAction(with: imageUrl, at: indexPath)
        }
        
        cell.logoInfo = logoInfo
        cell.logoImage = image
        
        return cell
    }
}

// MARK: #UITableViewDelegate

extension SearchViewController: UITableViewDelegate
{
    public
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
