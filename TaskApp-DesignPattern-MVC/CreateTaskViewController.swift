//
//  CreateTaskViewController.swift
//  TaskApp-DesignPattern-MVC
//
//  Created by yodaaa on 2019/04/08.
//  Copyright © 2019 yodaaa. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    fileprivate var createTaskView: CreateTaskView!
    fileprivate var dataSource: TaskDataSource!
    fileprivate var taskText: String?
    fileprivate var taskDeadline: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        /*
         CreateTaskView を生成し、デリゲートに self をセットしている */
        createTaskView = CreateTaskView()
        createTaskView.delegate = self
        view.addSubview(createTaskView)
        /* TaskDataSource を生成。 */
        dataSource = TaskDataSource()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*
         CreateTaskView のレイアウトを決めている */
        createTaskView.frame = CGRect(x: view.safeAreaInsets.left,
                                      y: view.safeAreaInsets.top,
                                      width: view.frame.size.width -
                                        view.safeAreaInsets.left -
                                        view.safeAreaInsets.right,
                                      height: view.frame.size.height
        - view.safeAreaInsets.bottom)
    }

    /*
     保存が成功した時のアラート
     保存が成功したら、アラートを出し、前の画面に戻っている
     */
    fileprivate func showSaveAlert() {
        let alertController = UIAlertController(title: "保存しました", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) {
            (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    /*
     タスクが未入力の時のアラート
     タスクが未入力の時に保存して欲しくない
     */
    fileprivate func showMissingTaskTextAlert() {
        let alertController = UIAlertController(title: "タスクを入力してください",
            message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel,
                                   handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    /*
     締切日が未入力の時のアラート
     締切日が未入力の時に保存して欲しくない
     */
    fileprivate func showMissingTaskDeadlineAlert() {
        let alertController = UIAlertController(title: "締切日を入力してください",
            message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel,
                                   handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}


// CreateTaskViewDelegate メソッド
extension CreateTaskViewController: CreateTaskViewDelegate {
    func createView(taskEditting view: CreateTaskView, text: String)
    {
        /*
         タスク内容を入力している時に呼ばれるデリゲードメソッド CreateTaskView からタスク内容を受け取り、taskText に代入している
         */
        taskText = text
    }
    func createView(deadlineEditting view: CreateTaskView, deadline:
        Date) {
        /*
         締め切り日時を入力している時に呼ばれるデリゲードメソッド
         CreateTaskView から締め切り日時を受け取り、taskDeadline に代入している */
        taskDeadline = deadline
    }
    func createView(saveButtonDidTap view: CreateTaskView) {
        /*
         保存ボタンが押された時に呼ばれるデリゲードメソッド
         taskText が nil だった場合 showMissingTaskTextAlert() を呼び、
         taskDeadline が nil だった場合 showMissingTaskDeadlineAlert() を呼んで いる
         どちらもnilでなかった場合に、taskText, taskDeadlineからTaskを生成し、 dataSource.save(task: task)を呼んで、taskを保存している
         保存完了後 showSaveAlert() を呼んでいる
         */
        guard let taskText = taskText else {
            showMissingTaskTextAlert()
            return }
        guard let taskDeadline = taskDeadline else {
            showMissingTaskDeadlineAlert()
            return }
        let task = Task(text: taskText, deadline: taskDeadline)
        dataSource.save(task: task)
        showSaveAlert()
    }
}

