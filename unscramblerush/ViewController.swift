//
//  ViewController.swift
//  unscramblerush
//
//  Created by Clement Gan on 26/12/2024.
//

import UIKit

// Game Page (Shuffled Word Game)
class ShuffledWordViewController: UIViewController {

    var score = 0
    var timeLeft = 30
    var lives = 3
    var timer: Timer?
    var originalWord = ""
    var shuffledWord = ""
    
    let scoreLabel = UILabel()
    let timerLabel = UILabel()
    let hintButton = UIButton()
    let hintLabel = UILabel()
    let shuffledWordLabel = UILabel()
    let userInputTextField = UITextField()
    let enterButton = UIButton()  // New button to check the entered word
    let quitButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set background image for game page
        view.backgroundColor = UIColor(patternImage: UIImage(named: "image_bg_2")!) // Add background image to your assets

        setupUI()
        startGame()
    }

    func setupUI() {
        // Score Label
        scoreLabel.frame = CGRect(x: 16, y: 60, width: 120, height: 40)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 22)
        scoreLabel.textAlignment = .center
        scoreLabel.backgroundColor = .white
        scoreLabel.layer.borderWidth = 2
        scoreLabel.layer.borderColor = UIColor.black.cgColor
        scoreLabel.layer.cornerRadius = 20
        scoreLabel.clipsToBounds = true
        view.addSubview(scoreLabel)

        // Timer Label
        timerLabel.frame = CGRect(x: view.frame.width - 170, y: 60, width: 150, height: 40)
        timerLabel.text = "Time Left: \(timeLeft)"
        timerLabel.font = UIFont.boldSystemFont(ofSize: 22)
        timerLabel.textAlignment = .center
        timerLabel.backgroundColor = .white
        timerLabel.layer.borderWidth = 2
        timerLabel.layer.borderColor = UIColor.black.cgColor
        timerLabel.layer.cornerRadius = 20
        timerLabel.clipsToBounds = true
        view.addSubview(timerLabel)

        // Shuffled Word Label (display shuffled word)
        shuffledWordLabel.frame = CGRect(x: (view.frame.width - 300) / 2, y: 150, width: 300, height: 40)
        shuffledWordLabel.text = "Word: "
        shuffledWordLabel.font = UIFont.boldSystemFont(ofSize: 30)
        shuffledWordLabel.textAlignment = .center
        shuffledWordLabel.backgroundColor = .white
        shuffledWordLabel.layer.borderWidth = 2
        shuffledWordLabel.layer.borderColor = UIColor.black.cgColor
        shuffledWordLabel.layer.cornerRadius = 20
        shuffledWordLabel.clipsToBounds = true
        view.addSubview(shuffledWordLabel)

        // Hint Button
        hintButton.frame = CGRect(x: (view.frame.width - 220) / 2, y: 200, width: 220, height: 50)
        hintButton.setTitle("Get Hint (Lives: \(lives))", for: .normal)
        styleButton(hintButton)
        hintButton.layer.cornerRadius = 20
        hintButton.clipsToBounds = true
        hintButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
        view.addSubview(hintButton)

        // Hint Label
        hintLabel.frame = CGRect(x: (view.frame.width - 220) / 2, y: 260, width: 220, height: 40)
        hintLabel.text = ""
        hintLabel.font = UIFont.boldSystemFont(ofSize: 25)
        hintLabel.textAlignment = .center
        hintLabel.backgroundColor = .white
        hintLabel.layer.borderWidth = 2
        hintLabel.layer.borderColor = UIColor.black.cgColor
        hintLabel.layer.cornerRadius = 20
        hintLabel.clipsToBounds = true
        view.addSubview(hintLabel)
        hintLabel.isHidden = true

        // User Input TextField (centered)
        userInputTextField.frame = CGRect(x: (view.frame.width - 300) / 2, y: view.frame.height / 2 + 30, width: 300, height: 40)
        userInputTextField.borderStyle = .roundedRect
        userInputTextField.placeholder = "Type the correct word"
        userInputTextField.font = UIFont.systemFont(ofSize: 18)
        userInputTextField.textAlignment = .center
        userInputTextField.returnKeyType = .done
        userInputTextField.autocapitalizationType = .none
        userInputTextField.autocorrectionType = .no
        view.addSubview(userInputTextField)

        // Enter Button to check the word
        enterButton.frame = CGRect(x: (view.frame.width - 100) / 2, y: userInputTextField.frame.maxY + 20, width: 100, height: 50)
        enterButton.setTitle("Enter", for: .normal)
        styleButton(enterButton)
        enterButton.layer.cornerRadius = 20
        enterButton.clipsToBounds = true
        enterButton.addTarget(self, action: #selector(checkEnteredWord), for: .touchUpInside)
        view.addSubview(enterButton)

        // Quit Button (centered at bottom)
        quitButton.frame = CGRect(x: (view.frame.width - 100) / 2, y: view.frame.height - 100, width: 100, height: 50)
        quitButton.setTitle("Quit", for: .normal)
        styleButton(quitButton)
        quitButton.layer.cornerRadius = 20
        quitButton.clipsToBounds = true
        quitButton.addTarget(self, action: #selector(quitGame), for: .touchUpInside)
        view.addSubview(quitButton)

        // Hide the back button
        self.navigationItem.hidesBackButton = true
    }

    func styleButton(_ button: UIButton) {
        // Apply gradient background and white bold title to all buttons
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        
        // Apply gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        button.layer.insertSublayer(gradientLayer, at: 0)
    }

//    func startGame() {
//        hintLabel.text = ""
//        hintLabel.isHidden = true
//        
//        // Randomly choose a word and shuffle it
//        originalWord = getRandomWord()
//        shuffledWord = shuffleWord(originalWord)
//
//        // Display shuffled word on screen
//        shuffledWordLabel.text = "Word: \(shuffledWord)"
//        hintLabel.text = ""
//
//        // Reset score and timer
//        score = 0
//        timeLeft = 30
//        lives = 3
//        scoreLabel.text = "Score: \(score)"
//        timerLabel.text = "Time Left: \(timeLeft)"
//        hintButton.setTitle("Get Hint (Lives: \(lives))", for: .normal)
//
//        // Start the countdown timer
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
//    }
    
    func startGame() {
        hintLabel.text = ""
        hintLabel.isHidden = true
        
        // Randomly choose a word and shuffle it
        originalWord = getRandomWord()
        shuffledWord = shuffleWord(originalWord)

        // Display shuffled word on screen
        shuffledWordLabel.text = "Word: \(shuffledWord)"
//        hintLabel.text = ""

        // Reset score and lives (but not the timer)
        score = 0
        lives = 3
        scoreLabel.text = "Score: \(score)"
        hintButton.setTitle("Get Hint (Lives: \(lives))", for: .normal)

        // Start the countdown timer if it's not already started
        if timer == nil {
            timeLeft = 30
            timerLabel.text = "Time Left: \(timeLeft)"
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    func proceedToNextWord() {
        hintLabel.text = ""
        hintLabel.isHidden = true
        
        // Randomly choose a word and shuffle it
        originalWord = getRandomWord()
        shuffledWord = shuffleWord(originalWord)
        
        // Display shuffled word on screen
        shuffledWordLabel.text = "Word: \(shuffledWord)"
    }

    @objc func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1
            timerLabel.text = "Time Left: \(timeLeft)"
        } else {
            timer?.invalidate()
            timer = nil
            
            showGameOverAlert()
        }
    }

    @objc func checkEnteredWord() {
        if let enteredWord = userInputTextField.text {
            // Compare the entered word and the original word case-insensitively
            if enteredWord.lowercased() == originalWord.lowercased() {
                score += 10
                scoreLabel.text = "Score: \(score)"
//                startGame() // Restart with new word, keeping the same timer
                userInputTextField.text = ""
                proceedToNextWord()
            } else {
                score -= 5
                scoreLabel.text = "Score: \(score)"
            }
        }
    }

    @objc func showHint() {
        // Provide a hint and reduce lives
        if lives > 0 {
            hintLabel.isHidden = false
//            hintLabel.text = "Hint: \(originalWord.prefix(2))..." // Example hint: first two letters
            hintLabel.text = "Hint: \(originalWord)" // Example hint: first two letters
            lives -= 1
            hintButton.setTitle("Get Hint (Lives: \(lives))", for: .normal)
        } else {
            hintLabel.isHidden = false
            hintLabel.text = "No lives left !" //"No lives left for hint!"
            
            timer?.invalidate()
            timer = nil
            showGameOverAlert()
        }
    }

    @objc func quitGame() {
        // Save the score and current time into UserDefaults
        saveScoreAndTime()

        // Navigate back to the menu
        navigationController?.popToRootViewController(animated: true)
    }

    func saveScoreAndTime() {
        // Get the current date and time
            let currentTime = Date()

            // Prepare the data dictionary
            let scoreData: [String: Any] = [
                "score": score,
                "time": currentTime
            ]

            // Fetch existing score data from UserDefaults
            var scoreHistory = UserDefaults.standard.array(forKey: "scoreHistory") as? [[String: Any]] ?? []

            // Append the new score and time to the array
            scoreHistory.append(scoreData)

            // Save the updated score history array back to UserDefaults
            UserDefaults.standard.set(scoreHistory, forKey: "scoreHistory")
    }

    func getRandomWord() -> String {
        let words = [
            "apple", "banana", "orange", "grape", "mango", "pineapple", "strawberry", "blueberry", "peach", "pear",
            "dog", "cat", "rabbit", "elephant", "tiger", "lion", "monkey", "giraffe", "zebra", "kangaroo",
            "mountain", "river", "lake", "ocean", "forest", "desert", "island", "canyon", "waterfall", "valley",
            "car", "bus", "bike", "plane", "train", "boat", "truck", "motorcycle", "helicopter", "submarine",
            "computer", "laptop", "tablet", "phone", "headphones", "keyboard", "mouse", "monitor", "printer", "camera",
            "sun", "moon", "star", "cloud", "rain", "snow", "wind", "fog", "storm", "lightning",
            "book", "notebook", "pen", "pencil", "eraser", "marker", "scissors", "ruler", "glue", "stapler",
            "chocolate", "candy", "cookie", "cake", "pie", "ice cream", "brownie", "cupcake", "donut", "biscuit",
            "football", "basketball", "baseball", "soccer", "tennis", "golf", "hockey", "volleyball", "swimming", "gymnastics",
            "teacher", "student", "school", "classroom", "library", "homework", "exam", "graduation", "university", "college",
            "doctor", "nurse", "patient", "hospital", "clinic", "medicine", "surgery", "treatment", "diagnosis", "prescription",
            "happy", "sad", "angry", "excited", "nervous", "relaxed", "bored", "confused", "surprised", "scared",
            "hot", "cold", "warm", "cool", "wet", "dry", "spicy", "sweet", "bitter", "salty"
        ]
        return words.randomElement()!
    }

    func shuffleWord(_ word: String) -> String {
        return String(word.shuffled())
    }

    func showGameOverAlert() {
        // Show game over alert
        let alertController = UIAlertController(title: "Game Over", message: "Your final score is \(score)", preferredStyle: .alert)

        // Play Again action
        let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { _ in
            self.startGame()
        }
        alertController.addAction(playAgainAction)

        // Exit action
        let exitAction = UIAlertAction(title: "Exit", style: .destructive) { _ in
            self.quitGame()
        }
        alertController.addAction(exitAction)

        present(alertController, animated: true, completion: nil)
    }
}




