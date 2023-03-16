//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 16.03.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    
    func alertPresent ( _ alert: UIAlertController)
}
