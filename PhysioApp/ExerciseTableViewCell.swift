//
//  ExerciseTableViewCell.swift
//  PhysioApp
//
//  Created by Philip Teow on 19/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    
    @IBOutlet weak var exerciseImageView: UIImageView! {
        didSet {
            //translatesAutoresizingMaskIntoConstraints = true
            //exerciseImageView.translatesAutoresizingMaskIntoConstraints = true
            exerciseImageView.layer.borderWidth = 1.0
            exerciseImageView.layer.masksToBounds = false
            exerciseImageView.layer.borderColor = UIColor.white.cgColor
            exerciseImageView.layer.cornerRadius = exerciseImageView.frame.size.width / 2
            exerciseImageView.clipsToBounds = true
            //layoutIfNeeded()
            //layoutSubviews()
        }
    }
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        exerciseImageView.layer.borderWidth = 1.0
//        exerciseImageView.layer.masksToBounds = false
//        exerciseImageView.layer.borderColor = UIColor.white.cgColor
//        exerciseImageView.layer.cornerRadius = exerciseImageView.frame.size.width / 2
//        exerciseImageView.clipsToBounds = true
//    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        exerciseImageView.frame.size = CGSize(width: 80, height: 80)
        exerciseImageView.layer.borderWidth = 1.0
        exerciseImageView.layer.masksToBounds = false
        exerciseImageView.layer.borderColor = UIColor.white.cgColor
        exerciseImageView.layer.cornerRadius = exerciseImageView.frame.size.width / 2
        exerciseImageView.clipsToBounds = true
    }
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
