//
//  WinRicoDotConnectGame.swift
//  FortuneSlotWinRicobet
//
//  Created by SunTory on 2025/3/3.
//

import UIKit
import SpriteKit

class WinRicoDotConnectGame: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var spinButton: UIButton!
    
    var scene: DotConnectScene!
    var availableNumbers: [Int] = Array(1...9)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView3.delegate = self
        pickerView3.dataSource = self
        
        spinButton.addTarget(self, action: #selector(spinNumbers), for: .touchUpInside)
        
        if let view = skView {
            scene = DotConnectScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            skView.backgroundColor = .clear
            scene.backgroundColor = .clear
            view.presentScene(scene)
        }
    }
    
    @objc func spinNumbers() {
        pickerView1.selectRow(Int.random(in: 0..<availableNumbers.count), inComponent: 0, animated: true)
        pickerView2.selectRow(Int.random(in: 0..<availableNumbers.count), inComponent: 0, animated: true)
        pickerView3.selectRow(Int.random(in: 0..<availableNumbers.count), inComponent: 0, animated: true)
        
        checkAndConnectDots()
    }
    
    @IBAction func btnBack(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkAndConnectDots() {
        let selected1 = availableNumbers[pickerView1.selectedRow(inComponent: 0)]
        let selected2 = availableNumbers[pickerView2.selectedRow(inComponent: 0)]
        let selected3 = availableNumbers[pickerView3.selectedRow(inComponent: 0)]
        
        let selectedDots = [selected1, selected2, selected3].sorted()
        
        if scene.connectDots(selectedDots) {
            if scene.isGameComplete() {
                showAlert(title: "🎉 You Win!", message: "All dots connected! New puzzle generated.")
                scene.generateNewPuzzle()
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.text = "\(availableNumbers[row])"
        label.textAlignment = .center
        label.backgroundColor = .clear
        
        label.font = UIFont(name: "Hiragino Mincho ProN W6", size: 22)
        label.textColor = .white
        
        return label
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

// **Dot Connect Puzzle Scene**
class DotConnectScene: SKScene {
    var dots = [SKShapeNode]()
    var connectedDots = [Int]()
    
    override func didMove(to view: SKView) {
        setupGrid()
        generateNewPuzzle()
    }
    
    func setupGrid() {
        let gridSize = 3
        let dotSize: CGFloat = 20
        let spacing = size.width / CGFloat(gridSize + 1)
        
        for i in 1...9 {
            let dot = SKShapeNode(circleOfRadius: dotSize / 2)
            dot.fillColor = .gray
            dot.position = getPosition(for: i, spacing: spacing)
            dot.name = "dot_\(i)"
            addChild(dot)
            dots.append(dot)
        }
    }
    
    func getPosition(for index: Int, spacing: CGFloat) -> CGPoint {
        let row = (index - 1) / 3
        let col = (index - 1) % 3
        
        let x = CGFloat(col + 1) * spacing
        let y = size.height - (CGFloat(row + 1) * spacing)
        
        return CGPoint(x: x, y: y)
    }
    
    func connectDots(_ selectedDots: [Int]) -> Bool {
        if isSequential(selectedDots) {
            for index in selectedDots {
                if let dot = childNode(withName: "dot_\(index)") as? SKShapeNode {
                    dot.fillColor = .green
                    if !connectedDots.contains(index) {
                        connectedDots.append(index)
                    }
                }
            }
            drawLines()
            return true
        }
        return false
    }
    
    func isSequential(_ selectedDots: [Int]) -> Bool {
        for i in 0..<selectedDots.count - 1 {
            if selectedDots[i] + 1 != selectedDots[i + 1] {
                return false
            }
        }
        return true
    }
    
    func drawLines() {
        for child in children where child.name?.hasPrefix("line_") == true {
            child.removeFromParent()
        }
        
        for index in connectedDots {
            if let dot1 = childNode(withName: "dot_\(index)")?.position {
                for neighbor in getSequentialNeighbors(index) {
                    if connectedDots.contains(neighbor), let dot2 = childNode(withName: "dot_\(neighbor)")?.position {
                        let line = SKShapeNode()
                        let path = UIBezierPath()
                        path.move(to: dot1)
                        path.addLine(to: dot2)
                        
                        line.path = path.cgPath
                        line.strokeColor = .blue
                        line.lineWidth = 4
                        line.name = "line_\(index)_\(neighbor)"
                        addChild(line)
                    }
                }
            }
        }
    }
    
    func getSequentialNeighbors(_ index: Int) -> [Int] {
        // Only allow sequential connections (e.g., 1→2→3 or 4→5→6)
        let validSequences = [
            [1, 2, 3], [4, 5, 6], [7, 8, 9], // Rows
            [1, 4, 7], [2, 5, 8], [3, 6, 9]  // Columns
        ]
        
        return validSequences.first(where: { $0.contains(index) }) ?? []
    }
    
    func isGameComplete() -> Bool {
        return connectedDots.count == 9
    }
    
    func generateNewPuzzle() {
        connectedDots.removeAll()
        for dot in dots {
            dot.fillColor = .gray
        }
        
        for child in children where child.name?.hasPrefix("line_") == true {
            child.removeFromParent()
        }
    }
}

