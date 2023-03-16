//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 16.03.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var alertDelegate: AlertPresenterDelegate?
    
    init(alertDelegate: AlertPresenterDelegate) {
        self.alertDelegate = alertDelegate
    }
    
    func makeAlertController(alertmodel: AlertModel) {
        
        let alert = UIAlertController( title: alertmodel.title,
                                       message: alertmodel.message,
                                       preferredStyle: .alert)
      
        let action = UIAlertAction(title: alertmodel.buttonText,
                                   style: .default) {  _ in
            alertmodel.completion()}
        alert.addAction(action)
        alertDelegate?.alertPresent(alert)
    }
}
