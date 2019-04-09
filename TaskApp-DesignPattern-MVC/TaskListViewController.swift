//
//  ViewController.swift
//  TaskApp-DesignPattern-MVC
//
//  Created by yodaaa on 2019/04/08.
//  Copyright © 2019 yodaaa. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    
    var dataSource: TaskDataSource!
    var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = TaskDataSource()
        
        tableview = UITableView(frame: view.bounds, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(TaskListCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableview)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonTapped(_:)))
        navigationItem.rightBarButtonItem = barButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(backButtonTapped(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadData()
        tableview.reloadData()
    }
    
    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        let controller = CreateTaskViewController()
        let navi = UINavigationController(rootViewController: controller)
        //present(navi, animated: true, completion: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem){
        Logger.debugLog("OK")
    }

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TaskListCell
        let task = dataSource.date(at: indexPath.row)
        
        cell.task = task
        return cell
    }
    
    
}
