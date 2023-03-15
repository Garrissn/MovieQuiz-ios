//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Игорь Полунин on 12.03.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    func testGameFinish() {
        sleep(2)
        
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
        
    }
    
    func testAlertDismiss() {
        sleep(2)
        
        for _ in 1...10 {
            
            
            app.buttons["No"].tap()
            sleep(2)
        }
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1 / 10")
        
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] //Yаходим перврначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        
        app.buttons["No"].tap() //находим кнопку да и нажимаем ее
        
        sleep(3)
        
        let secondPoster = app.images["Poster"] //еще раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2 / 10")
    }
    
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] //Yаходим перврначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        
        app.buttons["Yes"].tap() //находим кнопку да и нажимаем ее
        
        sleep(3)
        
        let secondPoster = app.images["Poster"] //еще раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    
    override func setUpWithError() throws {
        
        
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // если один тест не прошел то след тесты запускаться не будут
        continueAfterFailure = false
        
        
    }
    
    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        
    }
    
    
}

