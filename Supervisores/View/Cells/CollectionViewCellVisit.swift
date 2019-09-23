//
//  CollectionViewCellVisit.swift
//  Supervisores
//
//  Created by Sharepoint on 7/26/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class CollectionViewCellVisit: UICollectionViewCell {
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var viewOption: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblQuestion: UILabel!
    var index: Int = 0
    var isCheckedBox = false
    var viewPhoto: PhotosView?
    var delegate: CollectionViewCellVisitDelegate!
    static var reuseIdentifier: String = "\(String(describing: self))"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = CGFloat(10.0)
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.black.cgColor
    }
    func display(item: String, index: Int){
        lblQuestion.text = item
        self.index = index
    }
    func displayComment(){
        self.viewComment.isHidden = false
        self.viewOption.isHidden = true
    }
    func displayPhoto(photos: PhotosView)  {
        photos.lblTitle.text = "Evidencia fotográfica (obligatoria)"
        self.viewComment.isHidden = true
        self.viewOption.isHidden = true
        self.addSubview(photos)
        
    
    }
    @IBAction func checkBoxSeleted(){
        if isCheckedBox{
            isCheckedBox = false
            imageView.image = UIImage(named: "checkBoxFalse")
        }else{
            isCheckedBox = true
            imageView.image = UIImage(named: "checkBoxTrue")
        }
        delegate.selctedBox(index: self.index, status: isCheckedBox)
    }
}
extension CollectionViewCellVisit: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
    func textViewDidChange(_ textView: UITextView) {
         self.lblCount.text = "\(textView.text.count)/500"
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.lblCount.text = "\(textView.text.count)/500"
    }
}
protocol CollectionViewCellVisitDelegate: class {
    func selctedBox(index: Int, status: Bool)
}
