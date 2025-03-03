//
//  ViewController.swift
//  FortuneSlotWinRicobet
//
//  Created by SunTory on 2025/3/3.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var spinButton: UIButton!
    
    var scene: GameScene!
    var numbers = [1, 2, 3, 4, 5, 6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView3.delegate = self
        pickerView3.dataSource = self
        
        spinButton.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
        
        if let view = skView {
            scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            skView.backgroundColor = .clear
            scene.backgroundColor = .clear
            view.presentScene(scene)
        }
    }
    
    @objc func spinButtonTapped() {
        pickerView1.selectRow(Int.random(in: 0..<numbers.count), inComponent: 0, animated: true)
        pickerView2.selectRow(Int.random(in: 0..<numbers.count), inComponent: 0, animated: true)
        pickerView3.selectRow(Int.random(in: 0..<numbers.count), inComponent: 0, animated: true)
        checkSelectedNumbers()
    }
    
    @IBAction func btnBack(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row])"
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
    
    func checkSelectedNumbers() {
        let selected1 = numbers[pickerView1.selectedRow(inComponent: 0)]
        let selected2 = numbers[pickerView2.selectedRow(inComponent: 0)]
        let selected3 = numbers[pickerView3.selectedRow(inComponent: 0)]
        
        let selectedSequence = [selected1, selected2, selected3].sorted()

        if selectedSequence[1] == selectedSequence[0] + 1 && selectedSequence[2] == selectedSequence[1] + 1 {
            scene.connectMatchingSequence(selectedSequence)
            scene.checkWinCondition()
        }
    }
}

class GameScene: SKScene {
    let gridSize = 6
    var grid = [[Int]]()
    var cellSize: CGFloat = 0
    var connectedCells = Set<String>()
    
    override func didMove(to view: SKView) {
        self.size = view.bounds.size
        cellSize = min(size.width, size.height) / CGFloat(gridSize)
        generateGrid()
        drawGrid()
    }
    
    func generateGrid() {
        let possibleNumbers = [1, 2, 3, 4, 5, 6]
        for _ in 0..<gridSize {
            var row = [Int]()
            for _ in 0..<gridSize {
                row.append(possibleNumbers.randomElement()!)
            }
            grid.append(row)
        }
    }
    
    func drawGrid() {
        let startX = (size.width - CGFloat(gridSize) * cellSize) / 2
        let startY = (size.height - CGFloat(gridSize) * cellSize) / 2
        
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                let number = grid[i][j]
                drawCellBackground(i: i, j: j)
                let label = SKLabelNode(text: "\(number)")
                label.position = CGPoint(x: startX + CGFloat(j) * cellSize + cellSize / 2, y: startY + CGFloat(i) * cellSize + cellSize / 2)
                label.fontName = "Futura Bold"
                label.fontSize = cellSize * 0.4
                label.fontColor = getColor(for: number)
                label.name = "cell_\(i)_\(j)"
                addChild(label)
            }
        }
    }
    
    func drawCellBackground(i: Int, j: Int) {
        let startX = (size.width - CGFloat(gridSize) * cellSize) / 2
        let startY = (size.height - CGFloat(gridSize) * cellSize) / 2
        
        let rect = CGRect(x: startX + CGFloat(j) * cellSize, y: startY + CGFloat(i) * cellSize, width: cellSize, height: cellSize)
        let path = UIBezierPath(rect: rect)
        let shapeNode = SKShapeNode(path: path.cgPath)
        shapeNode.strokeColor = .black
        shapeNode.lineWidth = 2
        shapeNode.fillColor = .white
        shapeNode.name = "bg_\(i)_\(j)"
        addChild(shapeNode)
    }
    
    func getColor(for number: Int) -> UIColor {
        switch number {
        case 1: return .green
        case 2: return .blue
        case 3: return .magenta
        case 4: return .cyan
        case 5: return .yellow
        case 6: return .orange
        default: return .white
        }
    }
    
    func connectMatchingSequence(_ numbers: [Int]) {
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                if numbers.contains(grid[i][j]) {
                    let cellKey = "\(i)_\(j)"
                    if !connectedCells.contains(cellKey) {
                        connectedCells.insert(cellKey)
                        if let label = childNode(withName: "cell_\(i)_\(j)") as? SKLabelNode {
                            label.fontColor = .white
                            
                            if let bgNode = childNode(withName: "bg_\(i)_\(j)") as? SKShapeNode {
                                bgNode.fillColor = getColor(for: grid[i][j]) // Highlight matched sequence
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkWinCondition() {
        if connectedCells.count == gridSize * gridSize {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "You Win!", message: "Game Completed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
                    self.resetGame()
                }))
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
            }
        }
    }
    
    func resetGame() {
        removeAllChildren()
        connectedCells.removeAll()
        grid.removeAll()
        generateGrid()
        drawGrid()
    }
}
