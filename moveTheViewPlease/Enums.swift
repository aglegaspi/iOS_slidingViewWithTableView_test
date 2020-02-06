//
//  Enums.swift
//  moveTheViewPlease
//
//  Created by Radharani Ribas-Valongo on 2/6/20.
//  Copyright © 2020 aglegaspi. All rights reserved.
//

import Foundation

struct Enums {
    
    enum categories: String {
        case History, Art, Science, Religion, Yeet
    }
    
    enum cellIdentifiers: String {
        case categoryCell, StopCell
    }
    
    enum sliderViewStates: String {
        case closed, halfOpen, fullOpen
    }
}
