/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public protocol QuestionViewControllerDelegate {
  func questionViewController(_ viewController: QuestionViewController,
                              didCancel questionGroup: QuestionGroup,
                              at questionIndex: Int)
  
  func questionViewController(_ viewController: QuestionViewController,
                              didComplete questionGroup: QuestionGroup)
  
}

public class QuestionViewController: UIViewController {

  // MARK: - Instance Properties
  public var questionView: QuestionView! {
    guard isViewLoaded else { return nil }
    return (view as! QuestionView)
  }
  
  private lazy var questionIndexItem: UIBarButtonItem = { [unowned self] in
    let buttonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    self.navigationItem.rightBarButtonItem = buttonItem
    return buttonItem
  }()
  // MARK: - View Lifecycle
  
  public var questionGroup = QuestionGroup.basicPhrases() {
    didSet {
      navigationItem.title = questionGroup.title
    }
  }
  public var questionIndex = 0
  
  public var correctCount = 0
  public var incorrect = 0
  
  public var delegate: QuestionViewControllerDelegate?
    
  public override func viewDidLoad() {
    super.viewDidLoad()
    showQuestion()
    setUpCancelButton()
  }
  
  private func showQuestion() {
    let question = questionGroup.questions[questionIndex]
    questionView.promptLabel.text = question.prompt
    questionView.aswerLabel.text = question.answer
    questionView.hintLabel.text = question.hint
    
    questionView.aswerLabel.isHidden = true
    questionView.hintLabel.isHidden = true

    questionIndexItem.title = "\(questionIndex + 1)  \(questionGroup.questions.count)"
  }
  
  // MARK: - Actions
  @IBAction func toggleAnswerLabels(_ sender: Any) {
    questionView.aswerLabel.isHidden =  !questionView.aswerLabel.isHidden
    questionView.hintLabel.isHidden =  !questionView.hintLabel.isHidden
  }
  
  @IBAction func handleCorrect(_ sender: Any) {
    correctCount += 1
    questionView.correctCountLabel.text = "\(correctCount)"
    showNextQuestion()
  }
  
  @IBAction func handleIncorrect(_ sender: Any) {
    incorrect += 1
    questionView.incorrectCountLabel.text = "\(incorrect)"
    showNextQuestion()
  }
  
  func setUpCancelButton() {
    let action = #selector(handleCancel(_:))
    let image = UIImage(named: "ic_menu")
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                       landscapeImagePhone: nil,
                                                       style: .plain,
                                                       target: self,
                                                       action: action)
  }
  
  @IBAction func handleCancel(_ sender: Any) {
    delegate?.questionViewController(self, didCancel: questionGroup, at: questionIndex)
  }
  
  private func showNextQuestion() {
    questionIndex += 1
    
    guard questionIndex < questionGroup.questions.count else {
      delegate?.questionViewController(self, didComplete: questionGroup)
      return
    }
    
    showQuestion()
  }
}
