//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 04.02.2023.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func didFailToLoadImage(errorMessage: String) // сообщение об ошибке загрузки картинки
}
