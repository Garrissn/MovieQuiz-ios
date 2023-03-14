import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
   
    @IBOutlet weak var noButtonClicked: UIButton!
    
    @IBOutlet weak var yesButtonClicked: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counetLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
  //  AlertController.view.accessibilityIdentifier = "Game results"
    
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
  
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        
    }
    
   
     func showLoadingIndicator() {
       // activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
     func hideLoadingIndicator() {
        //activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    
     func showNetworkError(message: String) {
        hideLoadingIndicator()
      //  alertController.view.accessibilityIdentifier = "Game results"
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

       let alert = UIAlertController(
                                     title: result.title,
                                     message: message,
                                     preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.presenter.restartGame()
        }

    alert.addAction(action)
        alert.view.accessibilityIdentifier = "Game results"
        self.present(alert, animated: true, completion: nil)
 }

    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
       
        presenter.noButtonClicked()
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {

        
        presenter.yesButtonClicked()
    }
}


