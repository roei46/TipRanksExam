//
//  PostTableViewCell.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var nameDateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(viewModel: PostTableViewCellViewModel) {
        authorImage.makeRounded()
        descriptionLbl.text = viewModel.description
        nameDateLbl.text = viewModel.authorName + " / " + viewModel.date 
        headlineLbl.text = viewModel.headline
        
        self.background.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.background.sd_setImage(with: URL(string: viewModel.imageUrl), completed: nil)
        self.authorImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.authorImage.sd_setImage(with: URL(string: viewModel.authorImageUrl), completed: nil)
    }
}

