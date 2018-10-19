//
//  GJPBRecordShowTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBRecordShowTableViewController: UITableViewController {

    private var viewModel: GJPBRecordShowViewModel
    
    init(billModel: Bill) {
        viewModel = GJPBRecordShowViewModel(billModel: billModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "账单记录详情"
        
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "修改", style: .done, target: self, action: #selector(rightClick))
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(hex: "#f4f3f8")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = UIColor(hex: "#eaeaea")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerCell(GJPBRecordShowMsgTableViewCell.self)
    }
    
    @objc func rightClick() {
        //修改记录
        navigationController?.pushViewController(GJPBCreateRecordTableViewController(model: viewModel.billModel, successCourse: { [weak self] (bill) in
            self?.viewModel.billModel = bill
            self?.tableView.reloadData()
        }), animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.row(section: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBRecordShowMsgTableViewCell
        
        cell.configure(dataSource: viewModel.cellMsg(indexPath:indexPath))
        
        return cell
    }
    

}
