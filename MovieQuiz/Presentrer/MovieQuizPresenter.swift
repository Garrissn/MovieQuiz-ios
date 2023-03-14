//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 13.03.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
         
    private var currentQuestion: QuizQuestion?
    
    private weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    
  //  private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService!
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0

    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation(totalAccuracy: 0, gamesCount: 0)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        //alertPresenter = AlertPresenter(delegate: self)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didFailToLoadImage (errorMessage: String) {
        viewController?.showNetworkError(message: errorMessage)
    }
    
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer{
            correctAnswers += 1
            }
   }
    
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
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
    
    
//    func present(_ alertController: UIAlertController) {
//        alertController.view.accessibilityIdentifier = "Game results"
//        present(alertController)
//    }
    
    
    func yesButtonClicked() {
        
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
      
      didAnswer(isYes: false)
  }
    
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highLightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
            
            self.proceedToNextQuestionOrResults()
                }
    }
    
 
    
//       func didRecieveAlertModel(alertModel: AlertModel) {
//
//           alertPresenter?.makeAlertController(alertModel: alertModel)
//             }

    
    func proceedToNextQuestionOrResults() {
        
        // guard let statisticService = statisticService else {return}
        
        if self.isLastQuestion() {
            
            
            let text = correctAnswers == self.questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
            
    func makeResultsMessage() -> String {
            statisticService.store(correct: correctAnswers, total: questionsAmount)

            let bestGame = statisticService.bestGame

            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"

            let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")

            return resultMessage
        }
            
            
            
            
            
            
            
            
            
            
//            //statisticService.store(correct: correctAnswers, total: questionsAmount)
//            let text = correctAnswers == questionsAmount ?
//            "Поздравляем, Вы ответили на 10 из 10!":
//
//            "Ваш результат:\(correctAnswers)/10 \n " +
//            "Количество сыгранных квизов:\(statisticService.gamesCount) \n" +
//            "Рекорд: \(statisticService.bestGame.correct)/ \(statisticService.bestGame.total) ( \(statisticService.bestGame.date.dateTimeString))\n" +
//
//            "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
//
//
//            didRecieveAlertModel(alertModel: AlertModel(title: "Этот раунд окончен!",
//                                                        message: text,
//                                                        buttonText: "Сыграть еще раз",
//                                                        completion: {[weak self] in
//
//                guard let self = self else {return}
//                self.restartGame()
//
//                self.questionFactory?.requestNextQuestion()
//            }))
//        } else {
//            self.switchToNextQuestion()
//            questionFactory?.requestNextQuestion()
//        }
    
}
