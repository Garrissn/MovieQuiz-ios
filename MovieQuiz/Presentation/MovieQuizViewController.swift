import UIKit

final class MovieQuizViewController: UIViewController {
   
    @IBOutlet weak var noButtonClicked: UIButton!
    
    @IBOutlet weak var yesButtonClicked: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counetLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
 //   private var correctAnswers: Int = 0  // счетчик правильных ответов
//    private  var currentQuestionIndex : Int = 0 // индекс текущего вопроса
//    private let questionsAmount: Int = 10
   // private var questionFactory: QuestionFactoryProtocol?
   // private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    private var presenter: MovieQuizPresenter!
    
    
    
//    func present(_ alertController: UIAlertController) {
//        alertController.view.accessibilityIdentifier = "Game results"
//        present(alertController, animated: true)
//    }
  
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didReceiveNextQuestion(question: question)
//    }
    
//    func didFailToLoadData(with error: Error) {
//
//        showNetworkError(message: error.localizedDescription)//  в качестве сообщения описание ошибки
//
//    }
    
    
//    func didLoadDataFromServer() {
//      //  activityIndicator.isHidden = true // скрываем индикатор загрузки
//        questionFactory?.requestNextQuestion() // показать первый вопрос
//    }
    
    
//    func didFailToLoadImage (errorMessage: String) {
//        showNetworkError(message: errorMessage)
//    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        //presenter.viewController = self
       // alertPresenter = AlertPresenter(delegate: self)
       // questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        //statisticService = StatisticServiceImplementation(totalAccuracy: 0, gamesCount: 0)
        showLoadingIndicator()
        //questionFactory?.loadData()
    }
    
    
    
     func showLoadingIndicator() {
       // activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
     func hideLoadingIndicator() {
        //activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
//    private   func didRecieveAlertModel(alertModel: AlertModel) {
//
//           alertPresenter?.makeAlertController(alertModel: alertModel)
//             }
    
    
    
     func showNetworkError(message: String) {
        hideLoadingIndicator()
        
         let alert = UIAlertController(
                     title: "Ошибка",
                     message: message,
                     preferredStyle: .alert)

                     let action = UIAlertAction(title: "Попробовать ещё раз",
                     style: .default) { [weak self] _ in
                         guard let self = self else { return }

                         self.presenter.restartGame()
                     }

                 alert.addAction(action)
             }
         
         
         
         
         
         
//         presenter.didRecieveAlertModel(alertModel: AlertModel(title: "Ошибка",
//                                                    message: message,
//                                                    buttonText: "Попробовать еще раз!",
//                                                    completion: {[weak self] in
//
//            guard let self = self else {return}
//            self.presenter.restartGame()
//
//
//        }))
    
    
    

    
    
     func show(quiz step: QuizStepViewModel) {  // здесь мы заполняем нашу картинку, текст и счётчик данными
        
        imageView.image = step.image
        textLabel.text = step.question
        counetLabel.text = "\(step.questionNumber)"
         imageView.layer.borderWidth = 0
         
     }
    

    
    func  highLightImageBorder(isCorrectAnswer: Bool) {
                imageView.layer.masksToBounds = true
                imageView.layer.borderWidth = 8
                imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
               
               // imageView.layer.borderWidth = 0
        
        self.yesButtonClicked.isEnabled = true
        self.noButtonClicked.isEnabled = true
    }
    
    
    func show(quiz result:QuizResultsViewModel) {
    
       let message = presenter.makeResultsMessage()

       let alert = UIAlertController(
        title: result.title,
                                     message: message,
                                     preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.presenter.restartGame()
        }

    alert.addAction(action)

    self.present(alert, animated: true, completion: nil)
 }

    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
       
        presenter.noButtonClicked()
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {

        
        presenter.yesButtonClicked()
    }
}


