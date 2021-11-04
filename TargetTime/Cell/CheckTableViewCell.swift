//
//  CheckTableViewCell.swift
//  TodoList
//
//  Created by Constantin Razvan on 2021-11-03.
//

import UIKit

protocol CheckTableViewCellDelegate: AnyObject {
  func checkTableViewCell(_ cell: CheckTableViewCell, didChagneCheckedState checked: Bool)
}

class CheckTableViewCell: UITableViewCell {

  @IBOutlet weak var checkbox: Checkbox!
  @IBOutlet weak var label: UILabel!
  
  weak var delegate: CheckTableViewCellDelegate?

  
  @IBAction func checked(_ sender: Checkbox) {
    updateChecked()
    delegate?.checkTableViewCell(self, didChagneCheckedState: checkbox.checked)
  }
  
  func set(title: String, checked: Bool) {
    label.text = title
    set(checked: checked)
  }
  
  func set(checked: Bool) {
    checkbox.checked = checked
    updateChecked()
  }
  
  private func updateChecked() {
    let attributedString = NSMutableAttributedString(string: label.text!)
    
    if checkbox.checked {
      attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
    } else {
      attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
    }
    label.attributedText = attributedString
  }
  

}
