//
//  GJPBCalculateViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBCalculateViewController: UIViewController, UIScrollViewDelegate {

    private var financialVC = GJPBFinancialTableViewController()
    
    private var loanVC = GJPBLoanTableViewController()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: UIDevice.screenWidth() * 2, height: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(hex: "#f4f3f8")
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: 44))
        return view
    }()
    
    private lazy var financialTitleButton: UIButton = {
        let button = UIButton()
        button.setTitle("理财计算", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .selected)
        button.setTitleColor(UIColor(hex: "#8EBCFD"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.isSelected = false;
        button.addTarget(self, action: #selector(financialTitleButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var loanTitleButton: UIButton = {
        let button = UIButton()
        button.setTitle("贷款计算", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .selected)
        button.setTitleColor(UIColor(hex: "#8EBCFD"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.isSelected = true;
        button.addTarget(self, action: #selector(loanTitleButtonClick), for: .touchUpInside)
        return button
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupUI()
    }
    
    func setupNav() {
        if let _ = self.titleView.superview {
            return
        }
        
        let vlineView = UIView()
        vlineView.backgroundColor = UIColor(hex: "#8EBCFD")
        titleView.addSubview(vlineView)
        
        vlineView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(25)
        }
        
        titleView.addSubview(financialTitleButton)
        
        financialTitleButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(vlineView.snp.right)
        }
        
        titleView.addSubview(loanTitleButton)
        
        loanTitleButton.snp.makeConstraints { (make) in
            make.left.bottom.top.equalToSuperview()
            make.right.equalTo(vlineView.snp.left)
        }
        
        titleView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(2.5)
            make.width.equalTo(80)
            make.centerX.equalTo(UIDevice.screenWidth() / 4 + scrollView.contentOffset.x / 2)
            make.bottom.equalToSuperview()
        }
        
        navigationController?.navigationBar.addSubview(titleView)
        navigationController?.navigationBar.bringSubviewToFront(titleView)
    }
    
    func setupUI() {
        loanVC.nav = navigationController
        
        financialVC.view.frame = CGRect(x: UIDevice.screenWidth(), y: 0, width: UIDevice.screenWidth(), height: view.height)
        loanVC.view.frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: view.height)
        
        scrollView.addSubview(financialVC.view)
        scrollView.addSubview(loanVC.view)
        
        view.addSubview(scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        titleView.removeFromSuperview()
    }
    
    // MARK: 点击事件
    @objc func financialTitleButtonClick() {
        if financialTitleButton.isSelected {
            return
        }
        
        financialTitleButton.isSelected = true
        loanTitleButton.isSelected = false
        scrollView.contentOffset = CGPoint(x: UIDevice.screenWidth(), y: 0)
    }
    
    @objc func loanTitleButtonClick() {
        if loanTitleButton.isSelected {
            return
        }
        
        loanTitleButton.isSelected = true
        financialTitleButton.isSelected = false
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    // MARK -- UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            if loanTitleButton.isSelected {
                return
            }
            loanTitleButton.isSelected = true
            financialTitleButton.isSelected = false
        }else if scrollView.contentOffset.x == UIDevice.screenWidth() {
            if financialTitleButton.isSelected {
                return
            }
            
            financialTitleButton.isSelected = true
            loanTitleButton.isSelected = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
        let offset = scrollView.contentOffset.x
        
        lineView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(UIDevice.screenWidth() / 4 + offset / 2)
            make.height.equalTo(2.5)
            make.width.equalTo(80)
            make.bottom.equalToSuperview()
        }
    }
    



}
