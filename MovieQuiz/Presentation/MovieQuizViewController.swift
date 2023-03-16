import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterDelegate {
    
    func alertPresent( _ alert: UIAlertController) {
        alert.view.accessibilityIdentifier = "Game results"
        present(alert, animated: true)
    }
    
    
    @IBOutlet weak var noButtonClicked: UIButton!
    
    @IBOutlet weak var yesButtonClicked: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counetLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(alertDelegate: self)
    }
    
    
    func showLoadingIndicator() {
        
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        
        activityIndicator.stopAnimating()
    }
    
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        
        
        
        
        alertPresenter?.makeAlertController(alertmodel: AlertModel(title: "Ошибка",
                                                                   message: message,
                                                                   buttonText: "Попробовать ещё раз",
                                                                   completion: {[weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }))
        
    }
    
    
    func show(quiz step: QuizStepViewModel) {  // здесь мы заполняем нашу картинку, текст и счётчик данными
        
        imageView.image = step.image
        textLabel.text = step.question
        counetLabel.text = "\(step.questionNumber)"
        imageView.layer.borderWidth = 0
        self.yesButtonClicked.isEnabled = true
        self.noButtonClicked.isEnabled = true
        
    }
    
    
    
    func  highLightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        
        
        self.yesButtonClicked.isEnabled = false
        self.noButtonClicked.isEnabled = false
    }
    
    
    func show(quiz result: QuizResultsViewModel) {
        
        let message = presenter.makeResultsMessage()
        // должно быть ф-я презент и показ модели
        
        alertPresenter?.makeAlertController(alertmodel: AlertModel(title: result.title,
                                                                   message: message,
                                                                   buttonText: result.buttonText,
                                                                   completion: {[weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }))
        
        
        
    }
    
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        
        presenter.noButtonClicked()
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        
        presenter.yesButtonClicked()
    }
}


