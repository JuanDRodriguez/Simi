//
//  EscuestaCell.swift
//  Supervisores
//
//  Created by Sharepoint on 8/28/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class EscuestaCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    var type: QuestionTypes = .emoji
    var options: [OptionQuestion]!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var imgView4: UIImageView!
    @IBOutlet weak var lblQ1: UILabel!
    @IBOutlet weak var lblQ2: UILabel!
    @IBOutlet weak var lblQ3: UILabel!
    @IBOutlet weak var lblQ4: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stackThree: UIStackView!
    @IBOutlet weak var lblPregunta: UILabel!
    @IBOutlet weak var lblPreguntaF: UILabel!
    @IBOutlet weak var viewEmojis: EmojisViewCell!
    @IBOutlet weak var ViewStars: StartViewCell!
    @IBOutlet weak var viewFree: UIView!
    @IBOutlet weak var viewQ3: UIView!
    @IBOutlet weak var viewQ4: UIView!
    @IBOutlet weak var viewPhotos: UIView!
    var photoView: PhotosView!
    var title: String!
    var index: Int = 0
    var selectFree: [Int] = [-1,-1,-1,-1]
    var delegate: didSelectOptionEncuesta!
    var isCheckedBox:[Bool] = [false,false,false,false]
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = CGFloat(10.0)
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.black.cgColor
        textView.delegate = self
    }
    func checkBoxSeleted(isCheckedBox: Bool,index: Int) -> (Bool,UIImage){
        var image: UIImage!
        var checked: Bool!
        if isCheckedBox{
        checked = false
           image = UIImage(named: "checkBoxFalse")
            delegate.didselectedSingleOption(idResp: [-1], index: index)
        }else{
        checked = true
        image = UIImage(named: "checkBoxTrue")
            delegate.didselectedSingleOption(idResp: [options[index].id], index: self.index)
        }
    return (checked,image)
    }
    func checkBoxSeletedM(isCheckedBox: Bool,index: Int) -> (Bool,UIImage){
        var image: UIImage!
        var checked: Bool!
        if isCheckedBox{
            checked = false
            image = UIImage(named: "checkBoxFalse")
            delegate.didselectedMultipleOption(idResp: [-1], index: self.index, indexA: index)
        }else{
            checked = true
            image = UIImage(named: "checkBoxTrue")
            delegate.didselectedMultipleOption(idResp: [options[index].id], index: self.index,indexA: index)
        }
        return (checked,image)
    }
    @IBAction func actionCheckBox(_ button: UIButton){
        var item: (Bool,UIImage)!
        if type != .multipleChoice{
        switch button.tag {
        case 1:
            item = checkBoxSeleted(isCheckedBox: isCheckedBox[0],index: 0)
            isCheckedBox[0] = item.0
            imgView1.image = item.1
            imgView3.image = UIImage(named: "checkBoxFalse")
            imgView2.image = UIImage(named: "checkBoxFalse")
            imgView4.image = UIImage(named: "checkBoxFalse")
            isCheckedBox[1] = false
           isCheckedBox[2] = false
            isCheckedBox[3] = false
            
            break
        case 2:
           item = checkBoxSeleted(isCheckedBox: isCheckedBox[1],index: 1)
            isCheckedBox[1] = item.0
            imgView2.image = item.1
            imgView3.image = UIImage(named: "checkBoxFalse")
            imgView1.image = UIImage(named: "checkBoxFalse")
            imgView4.image = UIImage(named: "checkBoxFalse")
            isCheckedBox[0] = false
            isCheckedBox[2] = false
            isCheckedBox[3] = false
            
            break
        case 3:
            item = checkBoxSeleted(isCheckedBox: isCheckedBox[2],index: 2)
            isCheckedBox[2] = item.0
            imgView3.image = item.1
            imgView1.image = UIImage(named: "checkBoxFalse")
            imgView2.image = UIImage(named: "checkBoxFalse")
            imgView4.image = UIImage(named: "checkBoxFalse")
            isCheckedBox[1] = false
            isCheckedBox[0] = false
            isCheckedBox[3] = false
            
            break
        case 4:
            item = checkBoxSeleted(isCheckedBox: isCheckedBox[3],index: 3)
            isCheckedBox[3] = item.0
            imgView4.image = item.1
            imgView3.image = UIImage(named: "checkBoxFalse")
            imgView2.image = UIImage(named: "checkBoxFalse")
            imgView1.image = UIImage(named: "checkBoxFalse")
            isCheckedBox[1] = false
            isCheckedBox[2] = false
            isCheckedBox[0] = false
            
            break
            
        default:
            break
        }
        }else{
            switch button.tag {
            case 1:
                item = checkBoxSeletedM(isCheckedBox: isCheckedBox[0],index: 0)
                isCheckedBox[0] = item.0
                imgView1.image = item.1
                break
            case 2:
                item = checkBoxSeletedM(isCheckedBox: isCheckedBox[1],index: 1)
                isCheckedBox[1] = item.0
                imgView2.image = item.1
                break
            case 3:
                item = checkBoxSeletedM(isCheckedBox: isCheckedBox[2],index: 2)
                isCheckedBox[2] = item.0
                imgView3.image = item.1
                break
            case 4:
                item = checkBoxSeletedM(isCheckedBox: isCheckedBox[3],index: 3)
                isCheckedBox[3] = item.0
                imgView4.image = item.1
                break
            default:
                break
            }
        }
    }
    func display(type: QuestionTypes, question: Question, photosView: PhotosView, index: Int){
        self.index = index
        self.photoView = photosView
        self.type = type
        self.options = question.options
         self.title = question.question
        lblPregunta.text = title
        initUIElements()
         self.viewPhotos.addSubview(photoView)
    }
    func initUIElements(){
        switch type {
        case .binary:
            self.viewFree.isHidden = true
            self.ViewStars.isHidden = true
            self.viewEmojis.isHidden = true
            self.stackThree.isHidden = true
            self.lblQ1.text = options[0].option
            self.lblQ2.text = options[1].option
            break
        case .threeOptions:
            self.viewFree.isHidden = true
            self.ViewStars.isHidden = true
            self.viewEmojis.isHidden = true
            self.stackThree.isHidden = false
            self.viewQ4.isHidden = true
            self.lblQ1.text = options[0].option
            self.lblQ2.text = options[1].option
            self.lblQ3.text = options[2].option
           
            break
        case .multipleChoice:
            self.viewFree.isHidden = true
            self.ViewStars.isHidden = true
            self.viewEmojis.isHidden = true
            self.stackThree.isHidden = true
            self.setOptions(options: options.count)
            break
        case .emoji:
            self.viewFree.isHidden = true
            self.ViewStars.isHidden = true
            self.viewEmojis.isHidden = false
            self.viewEmojis.display(item: self.options,title: title)
            self.viewEmojis.index = self.index
            self.viewEmojis.delegate = self.delegate
            break
        case .stars:
            self.viewFree.isHidden = true
            self.ViewStars.isHidden = false
            self.viewEmojis.isHidden = true
            self.ViewStars.display(item: self.options,title: title)
            self.ViewStars.index = self.index
            self.ViewStars.delegate = self.delegate
            break
             case .free:
                self.viewFree.isHidden = false
                self.ViewStars.isHidden = true
                self.viewEmojis.isHidden = true
                lblPreguntaF.text = title
            break
        default:
            self.viewFree.isHidden = false
            self.ViewStars.isHidden = true
            self.viewEmojis.isHidden = true
            
            break
        }
    }
    func setOptions(options: Int){
        switch options {
        case 2:
            self.stackThree.isHidden = true
            self.lblQ1.text = self.options[0].option
            self.lblQ2.text = self.options[1].option
            break
        case 3:
            self.stackThree.isHidden = false
            self.viewQ4.isHidden = true
            self.lblQ1.text = self.options[0].option
            self.lblQ2.text = self.options[1].option
            self.lblQ3.text = self.options[2].option
            break
        case 4:
            self.stackThree.isHidden = false
            self.viewQ4.isHidden = false
            self.lblQ1.text = self.options[0].option
            self.lblQ2.text = self.options[1].option
            self.lblQ3.text = self.options[2].option
            self.lblQ4.text = self.options[3].option
            break
        default:
            break
        }
    }
}
extension EscuestaCell: didSelectOptionCell{
    func didSelected(option: [String : Any]) {
        
    }
    
    
}
protocol didSelectOptionEncuesta {
    func didselectedSingleOption(idResp:[Int],index: Int)
    func didselectedMultipleOption(idResp:[Int],index: Int, indexA: Int)
    func didSelectedFreeOption(resp: String,index:Int)
    
}
extension EscuestaCell: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate.didSelectedFreeOption(resp: textView.text, index: self.index)
    }
    func textViewDidChange(_ textView: UITextView) {
     delegate.didSelectedFreeOption(resp: textView.text, index: self.index)
    }
}
