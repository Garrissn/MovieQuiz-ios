//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Игорь Полунин on 10.03.2023.
//

import XCTest
@testable import MovieQuiz





final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func alertPresent(_ alert: UIAlertController) {
        
    }
    
    
   
    
    func highLightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
}

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData,
                                    text: "Question Text",
                                    correctAnswer: true)
        
        let viewModel = sut.convert(model: question)
        
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1 / 10")
    }
}
