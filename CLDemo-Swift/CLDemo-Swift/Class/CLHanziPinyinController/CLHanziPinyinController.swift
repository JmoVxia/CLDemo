//
//  CLHanziPinyinController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/12/1.
//

import UIKit

class CLHanziPinyinController: CLController {

    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var outputTextView: UITextView!
    
    @IBOutlet weak var pinyinButton: CLActivityButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension CLHanziPinyinController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        inputTextField.returnKeyType = .done
        inputTextField.placeholder = "请输入中文..."
        outputTextView.text = nil
        inputTextField.delegate = self
        pinyinButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(inputTextFieldTextChanged(_:)), name: UITextField.textDidChangeNotification, object: inputTextField)
    }
}
extension CLHanziPinyinController {
    @IBAction func pinyinAction(_ sender: Any) {
        guard let text = inputTextField.text else {
            return
        }
        outputTextView.text = nil

        inputTextField.resignFirstResponder()
        let startTime = Date().timeIntervalSince1970
        pinyinButton.startAnimating()
        CLHanziToPinyin.stringToPinyin(string: text, outputFormat: .default, separator: " ") { pinyin in
            let endTime = NSDate().timeIntervalSince1970
            let totalTime = endTime - startTime
            self.outputTextView.text += "text: \(text)\n\n耗时: \(totalTime)\n\n长: \(pinyin.long)\n\n短: \(pinyin.short)"
            self.pinyinButton.stopAnimating()
        }
    }
    @IBAction func newArchivedAction(_ sender: CLActivityButton) {
        outputTextView.text = nil
        sender.startAnimating()
        do {
            self.outputTextView.text += "开始写入汉字拼音文件..."
            CLLog("开始写入多音字词组文件...")
            let path = "\(NSHomeDirectory())/hanyupinyin"
            guard let resourcePath = Bundle.main.path(forResource: "hanyupinyin.txt", ofType: nil) else { return }
            let unicodeToPinyinText = try String(contentsOf: URL(fileURLWithPath: resourcePath))
            var pinyinTable = [String: String]()
            for pinyin in unicodeToPinyinText.components(separatedBy: "\n") {
                let components = pinyin.components(separatedBy: " ")
                guard components.count > 1 else { continue }
                pinyinTable.updateValue(components[1], forKey: components[0])
            }
            let data = try NSKeyedArchiver.archivedData(withRootObject: pinyinTable, requiringSecureCoding: true)
            try data.write(to: URL(fileURLWithPath: path))
            self.outputTextView.text += "\n\n写入汉字拼音文件 Success"
            CLLog("写入汉字拼音文件 Success\n文件地址：\(path)")
        } catch {
            self.outputTextView.text += "\n\n写入汉字拼音文件 Error：\(error)"
            CLLog("写入汉字拼音文件 Error：\(error)")
            sender.stopAnimating()
        }
        do {
            self.outputTextView.text += "\n\n开始写入多音字词组文件..."
            CLLog("开始写入多音字词组文件...")
            let path = "\(NSHomeDirectory())/sentencepinyin"
            guard let resourcePath = Bundle.main.path(forResource: "sentencepinyin.txt", ofType: nil) else { return }
            let unicodeToPinyinText = try String(contentsOf: URL(fileURLWithPath: resourcePath))
            var pinyinTable = [String: String]()
            for pinyin in unicodeToPinyinText.components(separatedBy: "\n") {
                let components = pinyin.components(separatedBy: ":")
                guard components.count > 1 else { continue }
                pinyinTable.updateValue(components[1], forKey: components[0])
            }
            let data = try NSKeyedArchiver.archivedData(withRootObject: pinyinTable, requiringSecureCoding: true)
            try data.write(to: URL(fileURLWithPath: path))
            self.outputTextView.text += "\n\n写入多音字词组文件 Success"
            CLLog("写入多音字词组文件 Success\n文件地址：\(path)")
        } catch {
            self.outputTextView.text += "\n\n写入多音字词组文件 Error：\(error)"
            CLLog("写入多音字词组文件 Error：\(error)")
            sender.stopAnimating()
        }
        sender.stopAnimating()
    }
    @IBAction func dissmissAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
extension CLHanziPinyinController {
    @objc func inputTextFieldTextChanged(_ notification: Notification) {
        pinyinButton.isEnabled = (inputTextField.text?.count ?? 0) > 0
    }
}
extension CLHanziPinyinController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
}
