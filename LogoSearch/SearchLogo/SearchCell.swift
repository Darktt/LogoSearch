//
//  SearchCell.swift
//  LogoSearch
//
//  Created by Eden on 2025/2/6.
//

import UIKit

public class SearchCell: UITableViewCell
{
    // MARK: - Properties -
    
    @IBOutlet private
    weak var logoImageView: UIImageView!
    
    @IBOutlet private
    weak var nameLabel: UILabel!
    
    @IBOutlet private
    weak var domainLabel: UILabel!
    
    public
    var logoInfo: LogoInfo? {
        
        willSet {
            
            guard let logoInfo = newValue else {
                
                return
            }
            
            self.updateLogoInfo(logoInfo)
        }
    }
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public override
    func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit
    {
        
    }
}

// MARK: - Private Methods -

private
extension SearchCell
{
    func updateLogoInfo(_ logoInfo: LogoInfo)
    {
        let name: String? = logoInfo.name
        let domain: String? = logoInfo.domain
        
        self.nameLabel.text = name
        self.domainLabel.text = domain
    }
}

// MARK: - Confirm Protocol -

extension SearchCell: CustomCellRegistrable
{
    public static
    var cellNib: UINib? {
        
        let nib = UINib(nibName: "SearchCell", bundle: nil)
        
        return nib
    }
    
    public static
    var cellIdentifier: String {
        
        return "SearchCell"
    }
}
