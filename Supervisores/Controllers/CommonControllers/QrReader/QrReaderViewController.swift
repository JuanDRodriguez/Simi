//
//  QrReaderViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 21/01/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import AVFoundation

protocol  QRReaderProtocol: class {
    func readingQR(jsonInfo: [String:Any], wasOnPause: Bool,statusUnit: Int32)
    func setTypeOption(type: typeOperationStore)
}

class QrReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var qrView: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var appPermissionView: AppPermissions? = nil
    var lottieView: LottieViewController?
    var idUnitRetake = -1
    var idUnitEdit = -1
    var statusUnit = 1
    var idUnit = 0
    var nameUnitEdit = ""
    var isRetaking = false
    var supervisionComplete = false
    var type: typeOperationStore!
    weak var delegate: QRReaderProtocol?
    @IBOutlet weak var viewSupervisionInCourse: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var unitsOwner : [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.qrView.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        configureCamera()
        captureSession.startRunning()
    }
    func configureCamera(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoCaptureDevice.cancelVideoZoomRamp()
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.qrView.layer.addSublayer(previewLayer)
    }
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type == typeOperationStore.supervision{
        validatePauseSuper()
        }else{
            self.qrView.isHidden = false
            self.viewSupervisionInCourse.isHidden = true
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        openCamera()
       
//        let dicto : [String: Any] = ["TimeStamp": 1549399287980,
//                                     "FarmaciaId": 1,
//                                     "Tipo": "supervision",
//                                     "TipoFarmacia": "Sucursal",
//                                     "NombreFarmacia": "ANTILLAS",
//                                     "FarmaciaClave": "01",
//                                     "ClaveSupervisor" : "07-02",
//                                     "Supervisor": [
//                                        "Activo" : 1,
//                                        "ApellidoMaterno" : "López",
//                                        "ApellidoPaterno" : "Colín",
//                                        "CorreoElectronico" : "sisrlopez@fsimilares.com",
//                                        "CuentaDominio" : "SIMI\\sisrlopez",
//                                        "Nombre" : "Hazael",
//                                        "UsuarioId" : 2]]
//        self.dismiss(animated: true, completion: {
//            [unowned self] in
//            self.delegate?.readingQR(jsonInfo: dicto, wasOnPause: false)
//        })
    }
    func validatePauseSuper(){
        
        let supervisionData = Storage.shared.getCurrentSupervision()
        self.supervisionComplete = supervisionData.completion
        self.statusUnit = Int(supervisionData.statusUnit)
        self.idUnit = supervisionData.idUnit
        if idUnit != 0{
            self.idUnitRetake = idUnit
            self.viewSupervisionInCourse.isHidden = false
             self.lblTitle.text = "Tienes una supervisión pendiente en: \(supervisionData.unitName)"
            captureSession.stopRunning()
            self.qrView.isHidden = true
        } else {
            self.viewSupervisionInCourse.isHidden = true
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }
    }
    func openCamera(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        guard let permission = self.appPermissionView else {
                            return
                        }
                        permission.removeFromSuperview()
                        self.appPermissionView = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.appPermissionView = AppPermissions(frame: self.view.frame, permision: Permissions.camera)
                        guard let permission = self.appPermissionView else {
                            return
                        }
                        self.view.addSubview(permission)
                    }
                }
            })
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    func finishWithError(errorQR : String = "") {
        self.lottieView?.animationFinishError(errorDescription: errorQR)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.captureSession.startRunning()
        }
    }
    func found(code: String) {
        let decrypted = Cypher.decrypt(text: code)
        self.unitsOwner.removeAll()
        self.unitsOwner = MyUnitsViewModel.shared.arrayUnitsMaped
        guard let decryptInfo = decrypted else {
            self.finishWithError()
            return
        }
        if let data = decryptInfo.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
               print("JsonQr: \(json)")
                guard let jsonDecoded = json else {
                    self.finishWithError()
                    return
                }
                guard let idUnit = jsonDecoded[KeysQr.unitId.rawValue] as? Int else {
                    self.finishWithError()
                    return
                }
                if self.isRetaking {
                    if idUnit != self.idUnitRetake {
                        self.finishWithError()
                        return
                    }
                }
                if self.idUnitEdit != -1 {
                    if idUnit != self.idUnitEdit {
                        self.finishWithError(errorQR: "Debes leer el QR de la unidad \(nameUnitEdit)")
                        return
                    }
                }
                let unitsFound = self.unitsOwner.filter({unit in
                    guard let idUnitFilter = unit[KeysUnit.idUnit.rawValue] as? Int else { return false}
                    if idUnitFilter == idUnit {
                        return true
                    }
                    return false
                })
                if unitsFound.count <= 0 {
                    self.finishWithError()
                    return
                }
                guard let timeStamp = jsonDecoded[KeysQr.timeStamp.rawValue] as? String else {
                    self.finishWithError()
                    return
                }
                let timeStampNumber = Utils.removeAllNonNumeric(text: timeStamp) / 1000.0
                if timeStampNumber > 0.0 {
                    let date = Date(timeIntervalSince1970: timeStampNumber)
                    let componentsLeftTime = Calendar.current.dateComponents([.second], from: date, to: Date())
                    guard let second = componentsLeftTime.second else {
                        self.finishWithError()
                        return
                    }
                    if second > 10000000000 {
                        self.finishWithError()
                        return
                    }
                    self.lottieView?.animationFinishCorrect()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.dismiss(animated: true, completion: {
                            [unowned self] in
                           if  jsonDecoded[KeysQr.type.rawValue] as! String == "supervision" {
                            self.delegate?.setTypeOption(type: typeOperationStore.supervision)
                           } else if jsonDecoded[KeysQr.type.rawValue] as! String == "visita" {
                            self.delegate?.setTypeOption(type: typeOperationStore.visita)
                           }else{
                            self.delegate?.setTypeOption(type: typeOperationStore.encuesta)
                            }
                            self.delegate?.readingQR(jsonInfo: jsonDecoded, wasOnPause: self.isRetaking,statusUnit: 1)
                        })
                    }
                } else {
                    self.finishWithError()
                    return
                }
            } catch {
                print("Something went wrong \(error)")
                self.lottieView?.animationFinishError()
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    @IBAction func cancelQrReader(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func sendSupervision(_ sender: Any) {
        let previewVC = SupervisionResumeViewController()
        previewVC.delegate = self
        let supervisionData = Storage.shared.getCurrentSupervision()
        var dateString = ""
        if let date = supervisionData.dateStart {
            dateString = Utils.stringFromDate(date: date)
        }
        let (key, address) = UnitsMapViewModel.shared.getInfoUnit(id: idUnit)
        
        self.present(previewVC, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            previewVC.setPreviewInfo(unitKey: key,
                                     unitName: supervisionData.unitName,
                                     address: address,
                                     dateSupervision: dateString,
                                     supKey: supervisionData.supervisorKey,
                                     typeUnit: supervisionData.typeUnit,
                                     nameSup: supervisionData.nameSupervisor, domainAccount: supervisionData.domainAccount)
        }
    }
    @IBAction func retakeSupervision(_ sender: Any) {
       if  self.statusUnit == 3{
        self.dismiss(animated: true, completion: nil)
        delegate?.setTypeOption(type: .supervision)
            delegate?.readingQR(jsonInfo: Operation.getJsonOffQR(type: .supervision , id: self.idUnit), wasOnPause: false,statusUnit: 3)
        
        }else{
        self.isRetaking = true
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        self.viewSupervisionInCourse.isHidden = true
        self.qrView.isHidden = false
        }
    }
    @IBAction func deleteSupervision(_ sender: Any) {
        Storage.shared.deleteCurrentSupervision(isEditing: false)
        self.isRetaking = false
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        self.viewSupervisionInCourse.isHidden = true
        self.qrView.isHidden = false
    }
}
