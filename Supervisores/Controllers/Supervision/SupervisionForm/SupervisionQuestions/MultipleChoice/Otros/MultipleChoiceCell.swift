//
//  MultipleChoiceCell.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 2/9/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class MultipleChoiceCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var titleQuestion: UILabel!
    @IBOutlet weak var questionsList: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("REGISTRANDO!!!!!")
        self.questionsList.delegate = self
        self.questionsList.dataSource = self
        let nib = UINib(nibName: "ChoiceCell", bundle: nil)
        self.questionsList.register(ChoiceCell.self, forCellReuseIdentifier: Cells.choiceCell.rawValue)
        self.questionsList.register(nib, forCellReuseIdentifier: Cells.choiceCell.rawValue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setInfo(selected: Bool){
        if selected {
            self.contentView.frame.size.height = 150
        } else {
            self.contentView.frame.size.height = 35
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMBER ROWS!!!!")
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idendifier = Cells.choiceCell.rawValue
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idendifier, for:indexPath) as? ChoiceCell else {
            let cellCreated = ChoiceCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: idendifier)
            return cellCreated
        }
        return cell
    }
    
}
