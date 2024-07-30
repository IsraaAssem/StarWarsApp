//
//  CustomTabBar.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import UIKit

class CustomTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius=40
        layer.masksToBounds=true
        layer.maskedCorners=[.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }

}
