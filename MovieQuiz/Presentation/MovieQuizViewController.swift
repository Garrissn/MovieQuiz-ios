import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate,AlertPresenterDelegate {
   
    @IBOutlet weak var noButtonClicked: UIButton!
    
    @IBOutlet weak var yesButtonClicked: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counetLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = 0  // счетчик правильных ответов
//    private  var currentQuestionIndex : Int = 0 // индекс текущего вопроса
//    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    private let presenter = MovieQuizPresenter()
    
    
    
    func present(_ alertController: UIAlertController) {
        alertController.view.accessibilityIdentifier = "Game results"
        present(alertController, animated: true)
    }
  
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didFailToLoadData(with error: Error) {
        
        showNetworkError(message: error.localizedDescription)//  в качестве сообщения описание ошибки
    
    }
    
    
    func didLoadDataFromServer() {
      //  activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion() // показать первый вопрос
    }
    
    
    func didFailToLoadImage (errorMessage: String) {
        showNetworkError(message: errorMessage)
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation(totalAccuracy: 0, gamesCount: 0)
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    
    
    private func showLoadingIndicator() {
       // activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        //activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private   func didRecieveAlertModel(alertModel: AlertModel) {
           
           alertPresenter?.makeAlertController(alertModel: alertModel)
             }
    
    
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        didRecieveAlertModel(alertModel: AlertModel(title: "Ошибка",
                                                    message: message,
                                                    buttonText: "Попробовать еще раз!",
                                                    completion: {[weak self] in
            
            guard let self = self else {return}
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.loadData()
        }))
    }
    
    
//    private func convert(model : QuizQuestion) -> QuizStepViewModel {// конвертация из  данных в модель которую надо //показать на экране
//
//        return QuizStepViewModel (
//            image: UIImage(data: model.image) ?? UIImage(), // Распаковка картинки
//            question: model.text, // берем текст вопроса
//            questionNumber: "\(currentQuestionIndex + 1) / \(questionsAmount)"  // высчитываем номер вопроса
//        )
//
//    }
    
    
    private func show(quiz step: QuizStepViewModel) {  // здесь мы заполняем нашу картинку, текст и счётчик данными
        
        imageView.image = step.image
        textLabel.text = step.question
        counetLabel.text = "\(step.questionNumber)"
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { // счетчик правильных ответов
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButtonClicked.isEnabled = false
        noButtonClicked.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in //задержка 1 сек перед показом след вопроса
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.yesButtonClicked.isEnabled = true
            self.noButtonClicked.isEnabled = true
            
        }
    }
    
    private func showNextQuestionOrResults() {
        guard let statisticService = statisticService else {return}
        if self.presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let text = correctAnswers == presenter.questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!":
            
            "Ваш результат:\(correctAnswers)/10 \n " +
            "Количество сыгранных квизов:\(statisticService.gamesCount) \n" +
            "Рекорд: \(statisticService.bestGame.correct)/ \(statisticService.bestGame.total) ( \(statisticService.bestGame.date.dateTimeString))\n" +
          
            "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
          
            didRecieveAlertModel(alertModel: AlertModel(title: "Этот раунд окончен!",
                                                        message: text,
                                                        buttonText: "Сыграть еще раз",
                                                        completion: {[weak self] in
                
                guard let self = self else {return}
                self.presenter.resetQuestionIndex() 
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }))
        } else{
            self.presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}


