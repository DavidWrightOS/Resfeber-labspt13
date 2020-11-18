//
//  SideMenuController.swift
//  Resfeber
//
//  Created by David Wright on 11/17/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit

private let reuseIdentifer = "MenuOptionCell"

enum MenuOption: Int, CustomStringConvertible, CaseIterable {
    
    case EditProfile
    case LogOut
    
    var description: String {
        switch self {
        case .EditProfile: return "Edit Profile"
        case .LogOut: return "Log Out"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .EditProfile: return UIImage(systemName: "person")?.withTintColor(UIColor.Resfeber.light, renderingMode: .alwaysOriginal)
        case .LogOut: return UIImage(systemName: "escape")?.withTintColor(UIColor.Resfeber.light, renderingMode: .alwaysOriginal)
        }
    }
}

protocol SideMenuDelegate: class {
    func toggleSideMenu(withMenuOption menuOption: MenuOption?)
}

class SideMenuController: UIViewController {
    
    // MARK: - Properties
    
    var profile: Profile = ProfileController.shared.profile
    var tableView: UITableView!
    weak var delegate: SideMenuDelegate?
    
    private lazy var profileMenuHeader: SideMenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 140)
        let view = SideMenuHeader(profile: profile, frame: frame)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Resfeber.red
        configureTableView()
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.backgroundColor = UIColor.Resfeber.red
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.tableHeaderView = profileMenuHeader
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

// MARK: - Table View Delegate & DataSource


extension SideMenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! SideMenuCell
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        cell.iconImageView.image = menuOption?.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        delegate?.toggleSideMenu(withMenuOption: menuOption)
    }
    
}