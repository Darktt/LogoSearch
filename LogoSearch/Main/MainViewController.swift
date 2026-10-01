//
//  MainViewController.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/6.
//

import UIKit
import SwiftExtensions

public class MainViewController: UIViewController
{
    // MARK: - Properties -
    
//    @IBOutlet fileprivate weak var <#Variable name#>: <#Class#>!
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public init()
    {
        super.init(nibName: "MainViewController", bundle: nil)
        
    }
    
    internal required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
    // MARK: View Live Cycle
    
    public override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    public override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
    
    public override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let viewController = self.loadSearchViewController()
        let navigationController = self.navigationController(rootViewController: viewController)
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(navigationController.view)
        self.addChild(navigationController)
        
        self.view.topAnchor =*= navigationController.view.topAnchor
        self.view.leadingAnchor =*= navigationController.view.leadingAnchor
        self.view.trailingAnchor =*= navigationController.view.trailingAnchor
        self.view.bottomAnchor =*= navigationController.view.bottomAnchor
    }
    
    deinit
    {
        
    }
}

// MARK: - Private Methons -

private
extension MainViewController
{
    func loadSearchViewController() -> UIViewController
    {
        let viewController = SearchViewController()
        
        return viewController
    }
    
    func navigationController(rootViewController: UIViewController) -> UIViewController
    {
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.navigationBar.barTintColor = .black
        
        let placeHolderViewController = PlaceHolderViewController()
        let placeHolderNavigation = UINavigationController(rootViewController: placeHolderViewController)
        placeHolderNavigation.navigationBar.barTintColor = .black
                
        let splitViewController = UISplitViewController(style: .doubleColumn)
        splitViewController.setViewController(viewController, for: .primary)
        splitViewController.setViewController(placeHolderNavigation, for: .secondary)
        splitViewController.preferredDisplayMode = .oneBesideSecondary
        splitViewController.presentsWithGesture = false
        
        return splitViewController
    }
}
