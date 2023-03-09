//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 04.03.2023.
//

import Foundation

// сервис загрузки фильмов из NetWorkClient  и преобразования в модель данных MostPopularMovies

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies,Error>) ->Void )
}

struct MoviesLoader: MoviesLoading {
    
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    
    // MARK: - URL
        private var mostPopularMoviesUrl: URL {
            
            // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
            guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_76t75xir") else {
                preconditionFailure("Unable to construct mostPopularMoviesUrl")
                        }
            
            return url
        }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies,Error>) ->Void ) {
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
         
            
            switch result {
                
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
              
                    handler(.success(mostPopularMovies))
                    print("Удачный парсинг")
                }
                catch {
                    handler(.failure(error))
                    print("ошибка парсинга")
                    
                    
                }
            case .failure(let error):
                handler(.failure(error))
                print("не загружено")
            }
        }
        
        
    }
}

