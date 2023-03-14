//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 09.02.2023.
//

import Foundation


protocol MovieQuizViewControllerProtocol: AnyObject {
    
        func show(quiz step: QuizStepViewModel)
        func show(quiz result: QuizResultsViewModel)
        func highLightImageBorder(isCorrectAnswer: Bool)
        func showLoadingIndicator()
        func hideLoadingIndicator()
        func showNetworkError(message: String)
}
