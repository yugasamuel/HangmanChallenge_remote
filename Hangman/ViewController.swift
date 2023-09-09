//
//  ViewController.swift
//  Hangman
//
//  Created by Yuga Samuel on 08/09/23.
//

import UIKit

class ViewController: UIViewController {
    var hangmanImage: UIImageView!
    var scoreLabel: UILabel!
    var hintLabel: UILabel!
    var words = [String]()
    var answer: String!
    
    var answerLetters = [AnswerLetter]()
    
    var lettersStack: UIStackView!
    var letterButtons = [UIButton]()
    
    var letters: [String] = {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return letters.map { String($0) }
    }()
    
    var incorrectCount = 0 {
        didSet {
            hangmanImage.image = UIImage(named: "hangman\(incorrectCount)")
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var hint = "" {
        didSet {
            hintLabel.text = "Hint: \(hint)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incorrectCount = 0
        loadRound()
    }
    
    func loadRound() {
        hint = "Animal"
        
        if let fileURL = Bundle.main.url(forResource: "animals", withExtension: "txt") {
            if let contents = try? String(contentsOf: fileURL) {
                words = contents.components(separatedBy: "\n")
                words.removeLast()
                
                answer = words.randomElement()!
                
                for letter in answer {
                    let letterLabel = UILabel()
                    letterLabel.text = "_"
                    letterLabel.font = UIFont.boldSystemFont(ofSize: 45)
                    
                    answerLetters.append(AnswerLetter(label: letterLabel, letter: String(letter)))
                }
            }
        }
        
        for index in 0..<answerLetters.count {
            lettersStack.addArrangedSubview(answerLetters[index].label)
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let titleImage = UIImageView()
        titleImage.image = UIImage(named: "title")
        titleImage.contentMode = .scaleAspectFit
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleImage)
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 70
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalStack)
        
        hangmanImage = UIImageView()
        hangmanImage.contentMode = .scaleAspectFit
        hangmanImage.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addArrangedSubview(hangmanImage)
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .fill
        verticalStack.spacing = 35
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addArrangedSubview(verticalStack)
        
        lettersStack = UIStackView()
        lettersStack.axis = .horizontal
        lettersStack.alignment = .center
        lettersStack.distribution = .fill
        lettersStack.spacing = 20
        lettersStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(lettersStack)
        
        let buttonsView = UIView()
        buttonsView.layer.borderWidth = 6
        buttonsView.layer.borderColor = UIColor.black.cgColor
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(buttonsView)
        
        let horizontalStack2 = UIStackView()
        horizontalStack2.axis = .horizontal
        horizontalStack2.alignment = .center
        horizontalStack2.distribution = .fill
        horizontalStack2.spacing = 70
        horizontalStack2.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(horizontalStack2)
        
        hintLabel = UILabel()
        hintLabel.text = "Hint: \(hint)"
        hintLabel.font = UIFont.systemFont(ofSize: 32)
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack2.addArrangedSubview(hintLabel)
        
        scoreLabel = UILabel()
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont.systemFont(ofSize: 32)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack2.addArrangedSubview(scoreLabel)
        
        let width = 85
        let height = 85
        
        for row in 0...4 {
            for col in 0...5 {
                let letterButton = UIButton(type: .system)
                letterButton.frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
                letterButton.setTitleColor(CustomColor.customBlue, for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                buttonsView.addSubview(letterButton)
                
                if row == 4 && (col == 0 || col == 1 || col == 4 || col == 5) {
//                     empty value
                } else {
                    letterButtons.append(letterButton)
                }
            }
        }
        
        for (index, letter) in letters.enumerated() {
            letterButtons[index].setTitle(letter, for: .normal)
        }
        
        NSLayoutConstraint.activate([
            titleImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            titleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleImage.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            
            horizontalStack.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 40),
            horizontalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            horizontalStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            hangmanImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            hangmanImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 510),
            buttonsView.heightAnchor.constraint(equalToConstant: 425),
            
            verticalStack.widthAnchor.constraint(equalTo: buttonsView.widthAnchor)
        ])
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonLetter = sender.titleLabel?.text else { return }
        
        if answer.contains(buttonLetter) {
            for answer in answerLetters {
                if answer.letter == buttonLetter {
                    answer.label.text = buttonLetter
                }
            }
            
            if !answerLetters.contains(where: { $0.label.text == "_"}) {
                showAlert(isWin: true)
            }
        } else {
            incorrectCount += 1
            if incorrectCount == 7 {
                showAlert(isWin: false)
            }
        }
        sender.isHidden = true
    }
    
    func showAlert(isWin: Bool) {
        let alertTitle: String!
        
        if isWin == true {
            alertTitle = "You nailed it!"
            score+=1
        } else {
            alertTitle = "Better luck next time!"
        }
            
        let ac = UIAlertController(title: alertTitle, message: "Would you like to play again?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Bring it on!", style: .default) { [weak self] action in
            self?.playAgain()
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func playAgain() {
        incorrectCount = 0
        answerLetters.removeAll()
        
        for subview in lettersStack.arrangedSubviews {
            lettersStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        loadRound()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
}
