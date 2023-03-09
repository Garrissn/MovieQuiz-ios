//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 04.03.2023.
//

import Foundation

///
///отвечает за загрузку данных по URL

struct NetworkClient {
    
    
    private enum NetworkError: Error {
        case codeError
    }
    
    
    func fetch(url: URL, handler: @escaping (Result <Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)// создаем запрос из url
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //Проверяем пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                print("нет соединения с интернетом")
                
                return
            }
            
            //Проверяем, что нам пришел успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
             handler(.failure(NetworkError.codeError))
                return
            }
            
            //Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
            print("Успешная сессия")
        }
        task.resume()
    }
}
