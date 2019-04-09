//
//  CreateTaskView.swift
//  TaskApp-DesignPattern-MVC
//
//  Created by yodaaa on 2019/04/08.
//  Copyright © 2019 yodaaa. All rights reserved.
//

import Foundation
import UIKit

protocol CreateTaskViewDelegate: class {
    func createView(taskEditting view: CreateTaskView, text: String)
    func createView(deadlineEditting view: CreateTaskView, deadline:
        Date)
    func createView(saveButtonDidTap view: CreateTaskView)
}

class CreateTaskView: UIView {
    private var taskTextField: UITextField! // タスク内容を入力するUITextField
    private var datePicker: UIDatePicker! // 締め切り時間を表示するUIPickerView
    private var deadlineTextField: UITextField! // 締め切り時間を入力するUITextField
    private var saveButton: UIButton! // 保存ボタン
    weak var delegate: CreateTaskViewDelegate? // デリゲート
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        taskTextField = UITextField()
        taskTextField.delegate = self
        taskTextField.tag = 0
        taskTextField.placeholder = "予定を入れてください"
        addSubview(taskTextField)
        deadlineTextField = UITextField()
        deadlineTextField.tag = 1
        deadlineTextField.placeholder = "期限を入れてください"
        addSubview(deadlineTextField)
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action:
            #selector(datePickerValueChanged(_:)),
                             for: .valueChanged)
        /*
         UITextField が編集モードになった時に、キーボードではなく、 UIDatePicker になるようにしている
         */
        deadlineTextField.inputView = datePicker
        saveButton = UIButton()
        saveButton.setTitle("保存する", for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 4.0
        saveButton.addTarget(self, action:
            #selector(saveButtonTapped(_:)),
                             for: .touchUpInside)
        addSubview(saveButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        /*
         save ボタンが押された時に呼ばれるメソッド
         押したという情報を CreateTaskViewController へ伝達している。 */
        delegate?.createView(saveButtonDidTap: self)
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        /*
         UIDatePicker の値が変わった時に呼ばれるメソッド
         sender.date がユーザーが選択した締め切り日時で、DateFormatter を用いて
         String に変換し、
         deadlineTextField.text に代入している
         また、日時の情報を CreateTaskViewController へ伝達している */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd HH:mm"
        let deadlineText = dateFormatter.string(from: sender.date)
        deadlineTextField.text = deadlineText
        delegate?.createView(deadlineEditting: self, deadline:
            sender.date)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        taskTextField.frame = CGRect(x: bounds.origin.x + 30,
                                     y: bounds.origin.y + 30,
                                     width: bounds.size.width - 60,
                                     height: 50)
        deadlineTextField.frame = CGRect(x: taskTextField.frame.origin.x,
                                         y: taskTextField.frame.maxY + 30,
                                         width: taskTextField.frame.size.width,
                                         height: taskTextField.frame.size.height)
        let saveButtonSize =  CGSize(width: 100, height: 50)
        saveButton.frame = CGRect(x: (bounds.size.width -
            saveButtonSize.width) / 2,
                                  y: deadlineTextField.frame.maxY + 20,
                                  width: saveButtonSize.width,
                                  height: saveButtonSize.height)
    }
}

extension CreateTaskView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 0 {
            /*
             textField.tag で識別している もし tag が 0 の時、textField.text すな
             わち、 している
             ユーザーが入力したタスク内容の文字を CreateTaskViewController に伝達
             */
            delegate?.createView(taskEditting: self, text:
                textField.text ?? "")
        }
        return true }
    
    // 確実にテキストフィールドに入れた文字列をハンドリングできるように、以下を追加した
    // キーボード閉じた後に、 CreateTaskViewController 入力文字列を伝達
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField:UITextField){
        if textField.tag == 0 {
            delegate?.createView(taskEditting: self, text:
                textField.text ?? "")// ユーザーの入力完了後の文字が入ってる
        }
    }
    
}
