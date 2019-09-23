//
//  ResumeSupervisionCell.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 3/18/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
protocol ResumenSuperVisionDelegate {
    var openPopUp: (() -> Void)? { get  set }
    
}
class ResumeSupervisionCell: UITableViewCell {
    @IBOutlet weak var lblTopic: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var stackBreaches: UIStackView!
    @IBOutlet weak var lblReasonsTitle: UILabel!
    @IBOutlet weak var lblCommentTitle: UILabel!
    @IBOutlet weak var lblPhotoTitle: UILabel!
    @IBOutlet weak var stackOptions: UIStackView!
    @IBOutlet weak var lblDateSolution: UILabel!
    @IBOutlet weak var heightReasonsConstraint: NSLayoutConstraint!
    var breaches : [[String: Any]] = []
    
    @IBOutlet weak var heightOptionsConstraint: NSLayoutConstraint!
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    @IBOutlet weak var photo4: UIImageView!
    @IBOutlet weak var photo5: UIImageView!
    @IBOutlet weak var scrollBreaches: UIScrollView!
    
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var viewBreaches: UIView!
    @IBOutlet weak var viewAction: UIView!
    @IBOutlet weak var viewComments: UIView!
    @IBOutlet weak var viewPhoto: UIView!
    @IBOutlet weak var stackGeneralViews: UIStackView!
    
    @IBOutlet weak var heightBreachesConstraint: NSLayoutConstraint!
    var viewHeightY = 0
    @IBOutlet weak var lblTitleAction: UILabel!
    var openPopUp: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGRect {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil)
        return rect
    }
    
    func setAnswer(answer: [String: Any]) {
        self.lblTopic.text = answer[KeysAnswerResume.topicDescription.rawValue] as? String
        self.lblQuestion.text = answer[KeysAnswerResume.questionDescription.rawValue] as? String
        self.viewHeightY += Int(self.lblTopic.bounds.height) + 5
        self.viewHeightY += Int(self.lblQuestion.bounds.height) + 5
        self.checkOptions(answer: answer)
        self.checkBreaches(answer: answer)
        self.checkAction(answer: answer)
        self.checkComment(answer: answer)
        self.checkPhotos(answer: answer)
        self.viewHeightY += 15
        self.contentView.frame.size.height = CGFloat(self.viewHeightY)
    }
    
    func checkOptions(answer: [String: Any]) {
        guard let options =  answer[KeysAnswerResume.optionDescription.rawValue] as? [String] else { return }
        self.stackOptions.subviews.forEach({ $0.removeFromSuperview() })
        var yPos = 0
        for option in options {
            let labelRect = rectForText(text: option, font: UIFont.systemFont(ofSize: 13), maxSize: CGSize(width: self.stackOptions.bounds.width, height: 500))
            let trueHeght = labelRect.height * 1.5
            let labelOption = UILabel(frame: CGRect(x: 0, y: yPos, width: Int(self.stackOptions.bounds.width), height: Int(trueHeght)))
            labelOption.text = option
            labelOption.numberOfLines = 10
            labelOption.textAlignment = .center
            labelOption.font = UIFont.systemFont(ofSize: 13)
            self.stackOptions.addSubview(labelOption)
            yPos += Int(trueHeght) + 5
        }
        self.heightOptionsConstraint.constant = CGFloat(yPos)
        self.viewHeightY += yPos + 5
    }
    
    func checkBreaches(answer: [String: Any]) {
        self.viewBreaches.isHidden = true
        if let breachesAnswer = answer[KeysAnswerResume.breaches.rawValue] as? [[String: Any]] {
            self.breaches = breachesAnswer
            self.scrollBreaches.subviews.forEach({ $0.removeFromSuperview() })
            if self.breaches.count > 0 {
                self.viewBreaches.isHidden = false
//                self.heightReasonsConstraint.constant = 22
            } else {
//                self.heightReasonsConstraint.constant = 0
            }
            var posY = 0
            for breach in self.breaches {
                let viewBreach = ViewResumeBreach(frame: CGRect(x: 0, y: posY, width: Int(self.scrollBreaches.frame.width), height: 65))
                viewBreach.setBreach(breach: breach)
                posY += 70
                viewBreach.delegate = self
                self.scrollBreaches.addSubview(viewBreach)
            }
            self.scrollBreaches.contentSize = CGSize(width: 10, height: posY)
            self.heightBreachesConstraint.constant = CGFloat(posY > 250 ? 250 : (posY + 30))
            self.viewHeightY += (Int(self.lblReasonsTitle.frame.height) + 5)
            self.viewHeightY += (Int(self.heightBreachesConstraint.constant) + 5)
        }
    }
   
    func checkAction(answer: [String: Any]) {
        self.viewAction.isHidden = true
        if let traces = answer[KeysAnswerResume.traces.rawValue] as? [[String: Any]] {
            if traces.count > 0 {
                self.viewAction.isHidden = false
                let trace = traces[0]
                if let actionSaved = trace[KeysTraceDictoResume.action.rawValue] as? String {
                    self.lblAction.text = actionSaved
                }
                if let datesolution = trace[KeysTraceDictoResume.dateCommitment.rawValue] as? Date{
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "yyyy"
                    let solutionYear = Int( dateFormatter.string(from: datesolution))
                    
                    if solutionYear! >= 2018  {
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        lblDateSolution.text = dateFormatter.string(from: datesolution)
                    }
                    
                }
                self.viewHeightY += Int(self.lblTitleAction.bounds.height) + 5
                self.viewHeightY += Int(self.lblAction.bounds.height) + 5
            }
        }        
    }
    
    func checkComment(answer: [String: Any]){
        viewComments.isHidden = true
        if let comment =  answer[KeysAnswerResume.comment.rawValue] as? String {
            if comment == "" {
                self.lblCommentTitle.text = ""
            } else {
                viewComments.isHidden = false
                self.lblCommentTitle.text = "Comentario"
                self.viewHeightY += Int(self.lblCommentTitle.frame.height) + 5
                self.lblComment.text = comment
                self.viewHeightY += Int(self.lblComment.frame.height) + 5
            }
        }
    }
    
    func checkPhotos(answer: [String: Any]) {
        self.viewPhoto.isHidden = true
      /*  if let theJSONData = try? JSONSerialization.data(
            withJSONObject:answer,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("ArrayAnwer: \(theJSONText!)")
        }*/
        ///print("ArrayAnswer: \(answer)")
        if let photosAnswer = answer[KeysAnswerResume.photos.rawValue] as? [[String: Any]] {
            //print("Photo: \(photosAnswer)")
            if photosAnswer.count > 0 {
                self.viewPhoto.isHidden = false
                self.viewHeightY += Int(self.lblPhotoTitle.frame.height) + 5
                self.viewHeightY += Int(self.stackBreaches.frame.height) + 5
            }
            /*self.photo1.isHidden = true
            self.photo2.isHidden = true
            self.photo3.isHidden = true
            self.photo4.isHidden = true
            self.photo5.isHidden = true*/
            let arrImgs:[UIImageView] = [self.photo1, self.photo2, self.photo3, self.photo4, self.photo5]
            for (i, photo) in photosAnswer.enumerated() {
                if i < arrImgs.count {
                    arrImgs[i].isHidden = false
                    if let photoImage = photo[KeysPhotosResume.photo.rawValue] as? UIImage {
                        arrImgs[i].image = photoImage
                    }
                    if let photoImage = photo[KeysPhotosResume.photo.rawValue] as? String {
                        //arrImgs[i].imageFromUrl(urlString: photoImage)
                        arrImgs[i].load(url: URL(string: photoImage)!)
                        //print("JDURLImage: \(photoImage)")
                    }
                }
            }
        }
    }
}
extension ResumeSupervisionCell : ViewResumenBreachDelegate, ResumenSuperVisionDelegate{
    
    
    func pressButton() {
       openPopUp?()
    }
    
    
}
