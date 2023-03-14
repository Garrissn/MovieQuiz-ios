//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Игорь Полунин on 11.03.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    func testGetValueInRange () throws {  // тест на успешное взятие элемента по индексу
       
        //Given
        let array = [1,1,2,3,5]
        
        //When
        let value = array[safe:  2]
        
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
    }
    func testGetValueOutOfRange () throws {  // тест на успешное взятие элемента по енправильному индексу
       
        //Given
        let array = [1,1,2,3,5]
        
        
        //When
        let value = array[safe:  22]
        
        
        //Then
        XCTAssertNil(value)
        
    }
}
