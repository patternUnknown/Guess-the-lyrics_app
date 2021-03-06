//
//  ViewController.swift
//  Guess the lyrics_app
//
//  Created by DDDD on 13/02/2020.
//  Copyright © 2020 MeerkatWorks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel! //label
    var answersLabel: UILabel! //labes
    var currentAnswer: UITextField! //raspunsul la moment
    var scoreLabel: UILabel! // score label
    var letterButtons = [UIButton]() //butoanele cu lyrics
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    var level = 1
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // additional settings should be added
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        //activating the layout constraints
        NSLayoutConstraint.activate([scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                                     scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                     
                                     cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                                     cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
                                     cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
                                     
                                     
                                     answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                                     answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
                                     answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
                                     answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
                                     
                                     currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                                     currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
                                     
                                     submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
                                     submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
                                     submit.heightAnchor.constraint(equalToConstant: 44),
                                     
                                     clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
                                     clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
                                     clear.heightAnchor.constraint(equalToConstant: 44),
                                     
                                     buttonsView.widthAnchor.constraint(equalToConstant: 750),
                                     buttonsView.heightAnchor.constraint(equalToConstant: 320),
                                     buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
                                     buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        // adding constraints to buttons so it would be easier to reference them
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("text", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    //what happens when the letters are tapped
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle + " ")
//currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        
        activatedButtons.append(sender)
        sender.isHidden = true //hides the button so it cannot be pressed multiple times
         
    }
    
    //will search through the solutions array a button, and if found - will show its position
    @objc func submitTapped(_ sender: UIButton) {
        
        guard let answerTextRead = currentAnswer.text else { return }
        if let solutionPosition = solutions.firstIndex(of: answerTextRead) {

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerTextRead

            answersLabel.text = splitAnswers?.joined(separator: "\n")

            
            currentAnswer.text = ""
            score += 1

            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
                            activatedButtons.removeAll()
            }

        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }

    //clear out all the text in the fields, and remove all items form the array
    @objc func clearTapped(_ sender: UIButton) {
        
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    // creating a function for loading levels
    func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var wordBits = [String]()
        
        // creating the path file
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ") //separation between lyrics and artist/song
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n" //adding the nr of reference to each line in order to display
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: " ")
                    
                    let usingForWordsNr = solutionWord.split(separator: " ", maxSplits: Int.max)
                    
                    solutionsString += "\(usingForWordsNr.count) words\n"
                    solutions.append(solutionsString)
                    
                    let bits = answer.components(separatedBy: "|")  //the bits of words as lyrics
                    wordBits += bits
                    
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        if letterButtons.count == wordBits.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(wordBits[i], for: .normal)
                
            }
        }
    }
}

//TODO: to fix the issue that letterButtons.count has to be the same as wordBits.count
// this would not allow more words in a lyrics
// some lyrics might not make sense with few words


