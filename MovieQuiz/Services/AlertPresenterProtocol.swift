//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 16.03.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    
    func makeAlertController(alertmodel: AlertModel)
}
