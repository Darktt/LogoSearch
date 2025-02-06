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
    func searchAction(_ sender: UIButton)
    {
        guard let keyword = self.textField.text else {
            
            return
        }
        
        self.sendSearchAction(with: keyword)
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
    
    func updateView(with state: LogoSearchState)
    {
        self.tableView.reloadData()
        
        if let error = state.error {
            
            self.presentErrorAlert(with: error)
        }
    }
}
