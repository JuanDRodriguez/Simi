//
//  MessageViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 9/8/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    var lottieView : LottieViewController?
    var items: [MessageItem] = []
    let model = MessageModel()
    var delegate: MainTabBarProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
         CommonInit.navBArInitMainTabBar(vc: self, navigationBar: self.navBar, title: "Mensajes")
        self.lottieView = CommonInit.lottieViewInit(vc: self)
        tableView.register(MessageCell.nib, forCellReuseIdentifier: MessageCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.items = MessageModel.shared.setNumberMessage(items: MessageModel.shared.items)
        tableView.reloadData()
        lottieView?.animationFinishCorrect()
        MessageModel.shared.newMessages = 0
        delegate.clearBadge()
    }
    
    
}
extension MessageViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier, for: indexPath) as! MessageCell
        cell.display([items[indexPath.row].Asunto!,items[indexPath.row].Mensaje!])
        return cell
    }
    
    
}
extension MessageViewController: MessageModelOutput{
    func modelDidLoad(_ items: [MessageItem]) {
      
    }
    
    func modelDidLoadFail() {
        lottieView?.animationFinishError()
    }
    
    
}
extension MessageViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var size = 55
        switch items[indexPath.row].Mensaje!.count{
            case (0...64):
            size += 10
            break
        case (65...129):
            size += 20
            break
        case (130...194):
            size += 30
            break
        case (195...259):
            size += 40
            break
        case (260...324):
            size += 50
            break
        case (325...389):
            size += 60
            break
        case (390...454):
            size += 70
            break
        case (454...500):
            size += 80
            break
            
        default:
            break
        }
        return CGFloat(size)
    }
}
