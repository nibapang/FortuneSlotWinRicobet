//
//  WinRicoSecondGame.swift
//  FortuneSlotWinRicobet
//
//  Created by SunTory on 2025/3/3.
//

import UIKit

class WinRicoSecondGame: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var spinButton: UIButton!
    @IBOutlet weak var answerTextField2: UITextField!
    @IBOutlet weak var answerTextField3: UITextField!
    @IBOutlet weak var puzzleLabel: UILabel!
    
    var numbers = Array(1...20)
    var correctAnswers = [Int]()
    var currentPuzzle = [(String, Int)]()
    var q2AnsweredCorrectly = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        
        confirmButton.isHidden = true
        confirmButton.addTarget(self, action: #selector(checkFinalAnswers), for: .touchUpInside)
        spinButton.addTarget(self, action: #selector(spinNumbers), for: .touchUpInside)
        
        generatePuzzle()
    }
    
    func generatePuzzle() {
        let dog = Int.random(in: 3...8)
        let bow = Int.random(in: 2...7)
        let house = Int.random(in: 1...5)
        
        let puzzle1 = ("🐶 + 🐶 + 🐶 =", dog * 3)
        let puzzle2 = ("🐶 + 🐶 + 🎀 = ?", dog * 2 + bow)
        let puzzle3 = ("🎀 - 🏡 = ?", bow - house)
        
        currentPuzzle = [puzzle1, puzzle2, puzzle3]
        correctAnswers = [puzzle1.1, puzzle2.1, puzzle3.1]
        
        // Show only Q1 and Q2 initially
        puzzleLabel.text = """
        1️⃣ \(puzzle1.0) \(puzzle1.1) ✅
        2️⃣ \(puzzle2.0)
        3️⃣ \(puzzle3.0)
        """
        
        confirmButton.isHidden = true
        answerTextField2.isHidden = false
        answerTextField3.isHidden = true
        answerTextField2.isEnabled = true
        answerTextField3.isEnabled = false  // ✅ Q3 is disabled until Q2 is correct
        answerTextField2.text = ""
        answerTextField3.text = ""
        resetTextFieldBorders()
        q2AnsweredCorrectly = false
    }
    
    @objc func spinNumbers() {
        pickerView1.selectRow(Int.random(in: 0..<numbers.count), inComponent: 0, animated: true)
        pickerView2.selectRow(Int.random(in: 0..<numbers.count), inComponent: 0, animated: true)
        checkSelectedNumbers()
    }
    
    @IBAction func btnBack(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkFinalAnswers() {
        let userAnswer2 = Int(answerTextField2.text ?? "") ?? -1
        let userAnswer3 = Int(answerTextField3.text ?? "") ?? -1

        // First check Q2
        if !q2AnsweredCorrectly {
            if userAnswer2 == correctAnswers[1] {
                answerTextField2.layer.borderColor = UIColor.green.cgColor
                answerTextField2.isEnabled = false // ✅ Disable Q2 text field after correct answer
                q2AnsweredCorrectly = true
                answerTextField3.isHidden = false  // ✅ Show Q3 input field
                answerTextField3.isEnabled = true  // ✅ Enable Q3 input
                
                confirmButton.isHidden = true  // ✅ Hide confirm button for Q3
                
                // ✅ Update puzzle label to show correct answer for Q2
                updatePuzzleLabel(showQ2Answer: true)
                
            } else {
                answerTextField2.layer.borderColor = UIColor.red.cgColor
                showAlert(title: "❌ Incorrect", message: "Try again for Question 2!")
                return
            }
        } else {
            // Now check Q3 only if Q2 was correct
            if userAnswer3 == correctAnswers[2] {
                answerTextField3.layer.borderColor = UIColor.green.cgColor
                showWinAlert()
            } else {
                answerTextField3.layer.borderColor = UIColor.red.cgColor
                showAlert(title: "❌ Incorrect", message: "Try again for Question 3!")
            }
        }
    }
    
    func checkSelectedNumbers() {
        let selected1 = numbers[pickerView1.selectedRow(inComponent: 0)]
        let selected2 = numbers[pickerView2.selectedRow(inComponent: 0)]
        
        let selectedNumbers = [selected1, selected2]
        
        // ✅ First check for Question 2 only
        if !q2AnsweredCorrectly {
            if selectedNumbers.contains(correctAnswers[1]) {
                confirmButton.isHidden = false
                showQuestionAlert(for: 2, correctAnswer: correctAnswers[1])
                return
            }
        }
        
        if q2AnsweredCorrectly {
            if selectedNumbers.contains(correctAnswers[2]) {
                confirmButton.isHidden = false
                showQuestionAlert(for: 3, correctAnswer: correctAnswers[2])
            }
        }
    }

    func showQuestionAlert(for questionNumber: Int, correctAnswer: Int) {
        let alert = UIAlertController(title: "Maybe This is Correct Answer?", message: "Is this for Question \(questionNumber)?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.enableAnswerField(for: questionNumber)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func enableAnswerField(for questionIndex: Int) {
        let textField = getTextField(for: questionIndex - 2)
        textField?.isHidden = false
        textField?.layer.borderWidth = 2
        textField?.layer.borderColor = UIColor.black.cgColor
    }
    
    func getTextField(for index: Int) -> UITextField? {
        switch index {
        case 0: return answerTextField2
        case 1: return answerTextField3
        default: return nil
        }
    }
    
    func resetTextFieldBorders() {
        answerTextField2.layer.borderWidth = 2
        answerTextField2.layer.borderColor = UIColor.black.cgColor
        answerTextField3.layer.borderWidth = 2
        answerTextField3.layer.borderColor = UIColor.black.cgColor
    }
    
    func updatePuzzleLabel(showQ2Answer: Bool) {
        if showQ2Answer {
            puzzleLabel.text = """
            1️⃣ \(currentPuzzle[0].0) \(correctAnswers[0]) ✅
            2️⃣ \(currentPuzzle[1].0) \(correctAnswers[1]) ✅
            3️⃣ \(currentPuzzle[2].0)
            """
        }
    }
    
    func showWinAlert() {
        let alert = UIAlertController(title: "🎉 You Win!", message: "All answers are correct!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Next Puzzle", style: .default, handler: { _ in
            self.generatePuzzle()
        }))
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.text = "\(numbers[row])"
        label.textAlignment = .center
        label.backgroundColor = .clear
        
        label.font = UIFont(name: "Hiragino Mincho ProN W6", size: 22)
        label.textColor = .white
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        checkSelectedNumbers()
    }
}
