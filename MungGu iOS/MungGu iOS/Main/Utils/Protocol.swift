//
//  HomeDelegate.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//
import UIKit

protocol HomeControllerDelegate {
    func handleToggleMenu(btn: UIButton)
}

protocol MasterViewControllerDelegate: class {
    func didselect(with data: File)
}

protocol TestViewControllerDelegate: class {
    func didTap()
}
