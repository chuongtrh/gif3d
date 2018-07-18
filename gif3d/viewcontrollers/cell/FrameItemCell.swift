//
//  FrameItemCell.swift
//  gif3d
//
//  Created by Sam on 7/10/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import UIKit

class FrameItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var ivThumbnail:UIImageView!
    @IBOutlet private weak var lbText:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        lbText.layer.cornerRadius = 10
        lbText.layer.masksToBounds = true
        
        ivThumbnail.layer.makeShadow(color: UIColor.darkGray, x: 0, y: 2, blur: 4, spread: 0)
        
    }
    open class func identifier() -> String {
        return "FrameItemCellIdentifier"
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        ivThumbnail.image = nil
    }
   
    //MARK: - Public
    func updateUI(image:UIImage, isEdited:Bool, color:UIColor, index:Int, isActive:Bool){
        ivThumbnail.image = image
        ivThumbnail.backgroundColor =  color
        lbText.textColor = isActive == true ? UIColor.red : UIColor.black
        
        if isEdited == true {
            lbText.text = "\(index + 1) ✓"
            
        }else{
            lbText.text = "\(index + 1)"
            
        }
        
        //lbText.backgroundColor = isActive == true ? UIColor.green: UIColor.clear
        lbText.font = isActive == true ? font_bold(size:18) : font_light(size: 16)
    }
}
