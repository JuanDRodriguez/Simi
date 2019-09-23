
import UIKit
import Lottie
import MessageUI

class SupervisionFinishViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var lblTitleResult: UILabel!
    @IBOutlet weak var lblLegend: UILabel!
    @IBOutlet weak var viewStar1: UIView!
    @IBOutlet weak var viewStar2: UIView!
    @IBOutlet weak var viewStar3: UIView!
    @IBOutlet weak var viewStar4: UIView!
    @IBOutlet weak var viewStar5: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var imgResultSupervision: UIImageView!
    var lottieView : LottieViewController?
    
    var lottieSupervision : LOTAnimationView?
    var lottieStars : [LOTAnimationView] = []
    var idSupervision = -1
    var keyUnit = ""
    var descriptionSupervision = ""
    var unitName = ""
    var stars = 5
    var type = 1//TO DO: CHECAR SI 1 ES SUCURSAL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfoResponseSupervision()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        self.lblTitle.text = "Supervisión"
        self.lblUnit.text = "\(self.keyUnit) \(self.unitName)"
        
    }
    
    
    private func loadInfoResponseSupervision() { //TO DO: REVISAR, CREO QUE FUNCIONA PERO NO LO REVISE
        //TO DO: SE OBTIENE LA INFO CON EL NUMERO DE ESTRELLAS, NO SE SI SEA CORRECTO, SI ES CON EL VALOR DE LA SUPERVISION NO SE DE DONDE SACARLO
        var infoShowed = false
        if type == 1 { //TO DO: CHECAR SI 1 ES SUCURSAL
            infoShowed = WeighingRangeViewModel.shared.getBrachInfo(value: stars) {
                [unowned self] supInfo in
                DispatchQueue.main.async {
                    if let imgStr = supInfo?.image {
                        self.imgResultSupervision.load(url: URL(string: imgStr)!)
                        self.lblTitleResult.text = supInfo?.description
                        self.lblLegend.text = supInfo?.legend
                        self.createStars(numberStars: self.stars)
                        self.createImageSupervision(numberStars: self.stars)
                        self.lottieView?.animationFinishCorrect()
                    }
                    
                }
            }
        } else {
            infoShowed = WeighingRangeViewModel.shared.getFranchiseInfo(value: stars) {
                [unowned self] supInfo in
                DispatchQueue.main.async {
                    if let imgStr = supInfo?.image {
                        self.imgResultSupervision.load(url: URL(string: imgStr)!)
                    }
                    self.lblTitleResult.text = supInfo?.description
                    self.lblLegend.text = supInfo?.legend
                    self.createStars(numberStars: self.stars)
                    self.createImageSupervision(numberStars: self.stars)
                    self.lottieView?.animationFinishCorrect()
                }
            }
        }
        
        if !infoShowed { //TO DO: SI NO ESTA CACHEADO SE MUESTRA LA ANIMACION DE CARGANDO
            lottieView = CommonInit.lottieViewInit(vc: self)
            lottieView?.animationLoading()
        }
    }
    
    func createImageSupervision(numberStars: Int){
        if numberStars < 6 {
            self.imgResultSupervision.image = UIImage(named: "supervisión_\(numberStars + 1)")
        } else {
            self.imgResultSupervision.image = UIImage(named: "supervisión_6")
        }
    }
    
    func createStars(numberStars: Int) {
        let sizeLottie = self.viewStar1.frame.width * 2.0
        let centerAnim = CGPoint(x: self.viewStar1.frame.width / 2.0 , y: self.viewStar1.frame.height / 2.0)
        for _ in 0..<5 {
            let lottie = LOTAnimationView(name: "star")
            lottie.isUserInteractionEnabled = false
            lottie.frame = CGRect(x: 0.0, y: 0.0, width: sizeLottie, height: sizeLottie)
            self.lottieStars.append(lottie)
        }
        self.viewStar1.addSubview(self.lottieStars[0])
        self.lottieStars[0].center = centerAnim
        self.viewStar2.addSubview(self.lottieStars[1])
        self.lottieStars[1].center = centerAnim
        self.viewStar3.addSubview(self.lottieStars[2])
        self.lottieStars[2].center = centerAnim
        self.viewStar4.addSubview(self.lottieStars[3])
        self.lottieStars[3].center = centerAnim
        self.viewStar5.addSubview(self.lottieStars[4])
        self.lottieStars[4].center = centerAnim
        
        let maxNumberStars = numberStars > 5 ? 4 : numberStars
        for i in 0..<maxNumberStars {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
                Utils.runAnimation(lottieAnimation: self.lottieStars[i], from: 0, to: 30)
            })
        }
    }
    @IBAction func shareSupervision(_ sender: Any) {
        var folio = String(self.idSupervision)
        folio = folio.leftPadding(toLength: 8, withPad: "0")
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Reporte de farmacia \(self.keyUnit)-\(self.unitName) -- \(folio)")
            mail.setMessageBody("""
                <p>En el siguiente vinculo podrá descargar el resultado de la supervisión: <br/>
                http://200.34.206.100:8443/SupervisionDmz/dmz/v1/Reporte/\(self.idSupervision)/supervision</p>
                """, isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated:true, completion: nil)
    }
    @IBAction func detailSupervision(_ sender: Any) {
        let supervisionDetail = SupervisionResumeViewController()
        supervisionDetail.supervisionId = self.idSupervision
        supervisionDetail.isDetail = true
        self.present(supervisionDetail, animated: true, completion: nil)
    }
    @IBAction func endDetails(_ sender: Any) {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? SupervisionViewController {
                viewController.dissmisVC()
                viewController.dismiss(animated: true, completion: nil)
                break
            }
        }
    }
}
