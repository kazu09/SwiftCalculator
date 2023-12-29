//
//  ViewController.swift
//  SwiftCalculator
//
//  Created by kazu on 2023/12/27.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var calculationArea: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func acButton(_ sender: Any) {
        // "AC"Button
        clearLabelText()
    }
    
    @IBAction func cpButton(_ sender: Any) {
        // "CP"Button
        let title = ""
        let message = "コピーしました"
        // ラベルの文字列をコピー
        UIPasteboard.general.string = getLabelText()
        openDialog(title: title, message: message)
    }
    @IBAction func dividedButton(_ sender: Any) {
        // "÷"Button
        addText("÷")
    }
    
    @IBAction func sevenButton(_ sender: Any) {
        // "7" Button
        addText("7")
    }
    
    @IBAction func eightButton(_ sender: Any) {
        // "8"Button
        addText("8")
    }
    
    @IBAction func nineButton(_ sender: Any) {
        // "9"Button
        addText("9")
    }
    
    @IBAction func timesButton(_ sender: Any) {
        // "×"Button
        addText("×")
    }
    
    @IBAction func fourButton(_ sender: Any) {
        // "4"Button
        addText("4")
    }
    
    @IBAction func fiveButton(_ sender: Any) {
        // "5"Button
        addText("5")
    }
    
    @IBAction func sixButton(_ sender: Any) {
        // "6"Button
        addText("6")
    }
    
    @IBAction func minusButton(_ sender: Any) {
        // "-"Button
        addText("-")
    }
    
    @IBAction func oneButton(_ sender: Any) {
        // "1"Button
        addText("1")
    }
    
    @IBAction func twoButton(_ sender: Any) {
        // "2"Button
        addText("2")
    }
    
    @IBAction func threeButton(_ sender: Any) {
        // "3"Button
        addText("3")
    }
    
    @IBAction func plusButton(_ sender: Any) {
        // "+"Button
        addText("+")
    }
    
    @IBAction func zeroButton(_ sender: Any) {
        // "0"Button
        addText("0")
    }
    
    @IBAction func pointButton(_ sender: Any) {
        // "."Button
        addText(".")
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        // "✖︎"Button
        let labelText = getLabelText()
        if (labelText == "") {
            return
        }
        calculationArea.text = String(labelText.dropLast())
    }
    
    @IBAction func equalButton(_ sender: Any) {
        // "="Button
        let label = getLabelText()
        if !checkbeforeNumText(labelText: label) {
            let title = ""
            let message = "式が無効です。再度入力をお願いします。"
            calculationArea.text = ""
            openDialog(title: title, message: message)
            return
        }
        let parseList = parseLabelText(label)
        if parseList == [] {
            return
        }
        if parseList.count == 1 {
            let title = ""
            let message = "式が無効です。再度入力をお願いします。"
            calculationArea.text = ""
            openDialog(title: title, message: message)
        }
        calculation(parseTexts: parseList)
    }
    
    /**
     Labelから入力数値を取得
     
     :returns: text label
     */
    func getLabelText() -> String {
        // calculationAreaから文字を取得
        guard let text = calculationArea.text else { return "" }
        return text
    }
    
    /**
     Labelエリアを削除する
     */
    func clearLabelText() {
        calculationArea.text = ""
    }
    
    /**
     入力した数値を表示させる
     
     :param: str 文字
     */
    func addText(_ str: String) {
        var labelText = getLabelText()
        if (checkbeforeNumText(labelText: labelText)) {
            // 文字列の最後が数値だった場合
            labelText.append(str)
            calculationArea.text = labelText
        } else if (!checkbeforeNumText(labelText: labelText) && checkInputText(inputText: str)) {
            // 文字列の最後が数値でないかつ押したボタンが数値だった場合
            labelText.append(str)
            calculationArea.text = labelText
        }
    }
    
    /**
     文字列の最後の文字を判定する
     
     :param: labelText labelに入力されている文字列
     :returns: フラグ true 数値 / false 数値以外
     */
    func checkbeforeNumText(labelText: String) -> Bool {
        guard let char = labelText.last else { return false }
        let text = String(char)
        let pattern = "[0-9]$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let matches = regex.numberOfMatches(in: text, range: NSRange(text.startIndex..., in: text))
        return matches > 0
    }
    
    /**
     押したボタンが数値かどうかを判定する
     
     :param: inputText 押したボタンの文字
     :returns: フラグ true 数値 / false 数値以外
     */
    func checkInputText(inputText: String) -> Bool {
        let pattern = "[0-9]"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let matches = regex.numberOfMatches(in: inputText, range: NSRange(inputText.startIndex..., in: inputText))
        return matches > 0
    }
    
    /**
     ダイアログを表示する
     
     :param: title ダイアログタイトル
     :param: message ダイアログメッセージ
     */
    func openDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     割り算、掛け算の記号を変換する
     
     :param: labelText labelに入力されている文字列
     :returns: 記号を変換した引数に渡された文字列
     */
    func replaceDividedAndTimes(labelText: String) -> String {
        var label:String = labelText
        if (label.contains("÷")) {
            //　"÷"があったとき
            label = label.replacingOccurrences(of: "÷", with: "/")
        }
        if (label.contains("×")) {
            //　"×"があったとき
            label = label.replacingOccurrences(of: "×", with: "*")
        }
        return label
    }
    
    /**
      入力した文字列を解析する
     
     :param: labelText labelに入力されている文字列
     :returns: 配列
     */
    func parseLabelText(_ labelText: String) -> [String] {
        let replaceText = replaceDividedAndTimes(labelText: labelText)
        var result: [String] = []
        var currentNumber = ""

        // labelに入力されていた文字列を1文字ずつ解析する
        for character in replaceText {
            if character.isNumber || character == "." {
                // 数値または小数点の場合
                currentNumber.append(character)
                if isOverPointCount(currentNumber: currentNumber) {
                    // 小数点が2つあったとき
                    let title = ""
                    let message = "式が無効です。再度入力をお願いします。"
                    calculationArea.text = ""
                    openDialog(title: title, message: message)
                    return []
                }
                
            } else {
                if !currentNumber.isEmpty {
                    result.append(currentNumber)
                }
                result.append(String(character))
                currentNumber = ""
            }
        }
        
        if !currentNumber.isEmpty {
            result.append(currentNumber)
        }
        return result
    }
    
    /**
     小数点が1つ以上ないかをチェックする
     
     :param: currentNumber 数値変換した文字列
     :returns: 小数点が1正しいかどうか true 少数が1を超えている / false 小数点が1以下の場合
     */
    func isOverPointCount(currentNumber: String) -> Bool {
        var pointCount = 0
        for character in currentNumber {
            if character == "." {
                pointCount += 1
            }
            if pointCount > 1 {
                return true
            }
        }
        return false
    }
    
    /**
     値を計算する
     :param: parseTexts 解析した配列
     */
    func calculation(parseTexts: [String]) {
        var expressionStr = ""
        
        for parseText in parseTexts {
            // 配列の全てをappendする
            expressionStr.append(parseText)
        }
        
        let expression = NSExpression(format: expressionStr)
        
        if let result = expression.expressionValue(with: nil, context: nil) as? Double {
            var resultStr = String(result)
            
            // 小数点＋0を削除する
            if let formatResult = (resultStr.range(of: ".0")) {
                resultStr.replaceSubrange(formatResult, with: "")
            }
            print("result :  \(resultStr)")
            
            // UIラベルに結果を表示する
            calculationArea.text = resultStr
            
        } else {
            let title = ""
            let message = "計算に失敗しました。再度入力をお願いします。"
            calculationArea.text = ""
            openDialog(title: title, message: message)
        }
    }
}

