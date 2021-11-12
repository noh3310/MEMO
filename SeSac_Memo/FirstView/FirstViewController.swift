//
//  FirstViewController.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/12.
//

import UIKit

class FirstViewController: UIViewController {
    
    static let identifier = "FirstViewController"

    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // uiview 설정
        setUiView()
        
        // 텍스트라벨 설정
        setTextLabel()
        
        // 버튼 설정
        setStartButton()
    }
    
    // uiview 설정
    func setUiView() {
        uiView.backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
        uiView.layer.cornerRadius = 10
        uiView.clipsToBounds = true
    }
    
    // 텍스트라벨 설정
    func setTextLabel() {
        textLabel.text = "처음 오셨군요!\n환영합니다.\n\n 당신만의 메모를 작성하고 관리해보세요"
        textLabel.numberOfLines = 0
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    // 버튼 설정
    func setStartButton() {
        startButton.setTitle("확인", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .systemOrange
        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
    }
    
    // 확인버튼 클릭했을 때 뒤로가기 하기
    @IBAction func startButtonClicked(_ sender: UIButton) {
        // 화면 뒤로 넘기기
        self.dismiss(animated: true, completion: nil)
    }
}
