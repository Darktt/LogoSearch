//
//  LogoDetailViewController.swift
//  LogoSearch
//
//  Created by Darktt on 2025/2/7.
//

import UIKit
import Combine

public
class LogoDetailViewController: UIViewController
{
    // MARK: - Properties -
    
    @IBOutlet private
    weak var previewBorderView: UIView!
    
    @IBOutlet private
    weak var previewInnerView: UIView!
    
    @IBOutlet private
    weak var downloadButton: UIButton!
    
    @IBOutlet private
    weak var imageBorderView: UIView!
    
    @IBOutlet fileprivate
    weak var imageView: UIImageView!
    
    @IBOutlet private
    weak var settingBorderView: UIView!
    
    @IBOutlet private
    weak var settingInnerView: UIView!
    
    @IBOutlet private
    weak var domainBorderView: UIView!
    
    @IBOutlet private
    weak var domainInnerView: UIView!
    
    @IBOutlet private
    weak var domainLabel: UILabel!
    
    @IBOutlet private
    weak var sizeValueLabel: UILabel!
    
    @IBOutlet private
    weak var sizeSlider: UISlider!
    
    @IBOutlet private
    weak var greyscaleSwitch: UISwitch!
    
    @IBOutlet private
    weak var retinaSwitch: UISwitch!
    
    @IBOutlet private
    weak var formatBorderView: UIView!
    
    @IBOutlet private
    weak var formatInnerView: UIView!
    
    @IBOutlet private
    weak var formatValueLabel: UILabel!
    
    @IBOutlet private
    weak var formatButton: UIButton!
    
    @IBOutlet private
    weak var fallbackBorderView: UIView!
    
    @IBOutlet private
    weak var fallbackInnerView: UIView!
    
    @IBOutlet private
    weak var fallbackValueLabel: UILabel!
    
    @IBOutlet private
    weak var fallbackButton: UIButton!
    
    private
    let logoInfo: LogoInfo
    
    private
    let store: LogoSearchStore
    
    private
    var cancellables: Set<AnyCancellable> = []
    
    private
    var selectedFormat: LogoImageRequest.Format = .jpg
    
    private
    var selectedFallback: LogoImageRequest.Fallback = .monogram
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init(with logoInfo: LogoInfo, store: LogoSearchStore)
    {
        self.logoInfo = logoInfo
        self.store = store
        
        super.init(nibName: "LogoDetailViewController", bundle: nil)
    }
    
    internal required
    init?(coder: NSCoder)
    {
        self.logoInfo = LogoInfo()
        self.store = kLogoSearchStore
        
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
        
        self.sendCleanLogoImageCacheAction()
    }
    
    public override
    func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let title: String = "Logo Image"
        let borderCornerRadius: CGFloat = 6.0
        let innerCornerRadius: CGFloat = 5.0
        let domain: String? = self.logoInfo.domain
        
        let formatMenuItems: Array<UIMenuElement> = LogoImageRequest.Format.allCases.map {
            
            UIAction(title: $0.rawValue) {
                
                [unowned self] action in
                
                self.selectedFormat = LogoImageRequest.Format(rawValue: action.title) ?? .jpg
                self.formatValueLabel.text = action.title
                self.sendImageAction()
            }
        }
        let formatMenu = UIMenu(options: .displayInline, children: formatMenuItems)
        let fallbackMenuItems: Array<UIMenuElement> = LogoImageRequest.Fallback.allCases.map {
            
            UIAction(title: $0.rawValue) {
                
                [unowned self] action in
                
                self.selectedFallback = LogoImageRequest.Fallback(rawValue: action.title) ?? .monogram
                self.fallbackValueLabel.text = action.title
                self.sendImageAction()
            }
        }
        let fallbackMenu = UIMenu(options: .displayInline, children: fallbackMenuItems)
        
        self.title = title
        self.previewBorderView.cornerRadius = borderCornerRadius
        self.previewInnerView.cornerRadius = innerCornerRadius
        self.downloadButton.addTarget(self, action: #selector(self.downloadAction(_:)), for: .touchUpInside)
        self.imageBorderView.cornerRadius = borderCornerRadius
        self.imageView.cornerRadius = innerCornerRadius
        self.imageView.image = nil
        self.settingBorderView.cornerRadius = borderCornerRadius
        self.settingInnerView.cornerRadius = innerCornerRadius
        self.domainBorderView.cornerRadius = borderCornerRadius
        self.domainInnerView.cornerRadius = innerCornerRadius
        self.domainLabel.text = domain
        self.sizeValueLabel.text = "(180px)"
        self.sizeSlider.addTarget(self, action: #selector(self.sizeAction(_:)), for: .valueChanged)
        self.greyscaleSwitch.addTarget(self, action: #selector(self.grayscaleAction(_:)), for: .valueChanged)
        self.retinaSwitch.addTarget(self, action: #selector(self.retinaAction(_:)), for: .valueChanged)
        self.formatBorderView.cornerRadius = borderCornerRadius
        self.formatInnerView.cornerRadius = innerCornerRadius
        self.formatValueLabel.text = self.selectedFormat.rawValue
        self.formatButton.fluent
            .menu(formatMenu)
            .showsMenuAsPrimaryAction(true)
            .discardResult
        self.fallbackBorderView.cornerRadius = borderCornerRadius
        self.fallbackInnerView.cornerRadius = innerCornerRadius
        self.fallbackValueLabel.text = self.selectedFallback.rawValue
        self.fallbackButton.fluent
            .menu(fallbackMenu)
            .showsMenuAsPrimaryAction(true)
            .discardResult
        self.setupSubscribes()
        self.sendImageAction()
    }
    
    deinit
    {
        
    }
}

// MARK: - Actions -

private
extension LogoDetailViewController
{
    @objc
    func downloadAction(_ sender: UIButton)
    {
        guard let image: UIImage = self.store.state.logoImage else {
                
            return
        }
        
        let coordinator = Coordinator.shared
        coordinator.nextPage(.activity(image))
    }
    
    @objc
    func sizeAction(_ sender: UISlider)
    {
        let size: String = "(\(Int(sender.value))px)"
        
        self.sizeValueLabel.text = size
        self.sendImageAction()
    }
    
    @objc
    func grayscaleAction(_ sender: UISwitch)
    {
        self.sendImageAction()
    }
    
    @objc
    func retinaAction(_ sender: UISwitch)
    {
        self.sendImageAction()
    }
}

// MARK: - Private Methons -

private
extension LogoDetailViewController
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
    
    func sendImageAction()
    {
        guard let domain: String = self.logoInfo.domain else {
                
            return
        }
        
        var request = LogoImageRequest.image(with: domain)
        request.size = self.sizeSlider.value
        request.isGreyscale = self.greyscaleSwitch.isOn
        request.isRetina = self.retinaSwitch.isOn
        request.format = self.selectedFormat
        request.fallback = self.selectedFallback
        
        request.url.unwrapped {
            
            Log.v(message: "Image url: \($0)")
            
            let action = LogoSearchAction.fetchLogoImage($0)
            
            self.store.dispatch(action)
        }
    }
    
    func sendCleanLogoImageCacheAction()
    {
        let action = LogoSearchAction.cleanLogoImageCache
        
        self.store.dispatch(action)
    }
    
    func updateView(with state: LogoSearchState)
    {
        let image: UIImage? = state.logoImage
        
        self.imageView.image = image
        
        if let error = state.error {
            
            self.presentErrorAlert(with: error)
        }
    }
}
