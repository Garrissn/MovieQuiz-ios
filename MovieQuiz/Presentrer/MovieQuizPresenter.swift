//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 13.03.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
     func convert(model : QuizQuestion) -> QuizStepViewModel {// конвертация из  данных в модель которую надо //показать на экране
        
        return QuizStepViewModel (
            image: UIImage(data: model.image) ?? UIImage(), // Распаковка картинки
            question: model.text, // берем текст вопроса
            questionNumber: "\(currentQuestionIndex + 1) / \(questionsAmount)"  // высчитываем номер вопроса
        )
        
    }
    
}
