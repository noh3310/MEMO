//
//  EditMemoViewController.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/08.
//

import UIKit
import RealmSwift
import Toast

class EditMemoViewController: UIViewController {

    static let identifier = "EditMemoViewController"
    
    let localRealm = try! Realm()
    
    var tasks: Results<Memo>!
    
    // 뷰컨트롤러를 통해 값 넘겨줌
    var memoItem: Memo?
    
    // 프로퍼티 옵저버로 백버튼 바꿔줌(이값은 뷰컨트롤러를 통해 넘어옴)
    var backButtonTitle = ""
    
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백버튼 이름 만들어줌
        setBackButton()
        
        // 텍스트뷰 설정
        setMemoTextView()
        
        // 메모정보 있으면 화면에 보여줌
        setMemoInformation()
        
        // 키보드 설정
        setKeyboard()

        
        // 키보드 옵저버 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

        // DB정보 받아옴
        tasks = localRealm.objects(Memo.self)
        
        print(localRealm.configuration.fileURL!)
    }
    
    // 화면이 사라질 때 만약 저장을 하지않았을 경우 저장해줌
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 옵저버 해제(옵저버를 계속 켜놓으면 메모리 낭비가 있다고 한다.)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let list = memoTextView.text.devideMemo(text: memoTextView.text)
        let title = list[0]
        let content = (list[1] == "") ? nil : list[1]
        
        // 기존에 있는 메모를 수정했다면 데이터랑, 날짜 업데이트 해줌
        if let memoItem = memoItem {
            // _id로 오브젝트 받아오기
            let object = tasks.filter("_id == %@", memoItem._id).first!
            
            // 둘중에 하나라도 다르면 DB 업데이트 해줌
            if title != object.title || content != (object.content ?? nil) {
                
                // 만약 데이터가 없어졌다면 DB에서 삭제해줘야함
                let removeTitle = title.getRemoveString(title) ?? nil
                let removeContent = content?.getRemoveString(content) ?? nil
                
                if (removeTitle == "" || removeTitle == nil) && (removeContent == "" || removeContent == nil) {
                    try! localRealm.write {
                        localRealm.delete(object)
                    }
                }
                // 데이터가 있다면 DB값 업데이트
                else {
                    try! localRealm.write {
                        // 타이틀 변경
                        object.title = title

                        // 콘텐츠 변경
                        object.content = content ?? nil

                        // 수정했으면 현재날짜로 업데이트해줌
                        object.date = Date()
                    }
                }
            }
        }
        // 새롭게 메모를 추가했을 경우
        else {
            // 새로운 메모를 추가하는데 정보가 있다면 DB에 등록해줌, 없다면 그냥 패스
            if title.count > 0 {
                try! localRealm.write {
                    let memo = Memo(title: title, content: content)
                    
                    localRealm.add(memo)
                }
            }
        }
    }
    
    // 백버튼 이름 설정
    func setBackButton() {
        self.navigationController?.navigationBar.topItem?.title = backButtonTitle
        self.navigationController?.navigationBar.tintColor = .systemOrange
    }
    
    // 텍스트뷰 설정
    func setMemoTextView() {
        memoTextView.tintColor = .systemOrange
    }
    
    // 내비게이션바 설정
    func setNavigationBar() {
        // "메모" 아니면 "검색"으로 설정해줘야함
        self.navigationItem.backBarButtonItem?.title = "뒤로"
        
        // 공유버튼, 저장버튼 생성
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked(_:)))
        shareButton.tintColor = .systemOrange
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked(_:)))
        saveButton.tintColor = .systemOrange
        
        // navigationBarButton의 오른쪽부터 채워줌
        self.navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
    
    // 공유버튼 클릭했을 때
    @objc func shareButtonClicked(_ button: UIBarButtonItem) {
        
        // 만약에 입력한 정보가 하나도 없다면
        if memoTextView.text.getRemoveString(memoTextView.text) == "" {
            self.view.makeToast("입력한 값이 없어 공유할 수 없습니다.", duration: 1.0, position: .top)
            return
        }
        
        // 공유할 컨텐츠 저장
        let shareContent = [memoTextView.text]
        
        // ActivityViewControlleer 생성
        let vc = UIActivityViewController(activityItems: shareContent as [Any], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // 저장버튼 클릭했을 때
    @objc func saveButtonClicked(_ button: UIBarButtonItem) {
        
        // 뒤 화면으로 돌아감(저장이나 삭제는 viewWillDisappear에서 해줌)
        self.navigationController?.popViewController(animated: true)
    }
    
    // 메모정보 있으면 화면에 보여줌
    func setMemoInformation() {
        // 만약 메모정보가 있다면
        if let memoItem = memoItem {
            var memoText = "\(memoItem.title)"
            if let content = memoItem.content {
                memoText += "\n\(content)"
            }
            
            memoTextView.text = memoText
        }
    }
    
    // 키보드 설정(새 메모를 선택하면 키보드 띄워주고, 아니라면 안띄워줌)
    func setKeyboard() {
        if memoItem == nil {
            memoTextView.becomeFirstResponder()
        }
    }
    
    // 키보드 보일때 저장, 공유버튼 나타남
    @objc func keyboardWillShow(_ notification: NSNotification) {
        setNavigationBar()
        
        // 키보드 textview크기 줄여줌
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            textViewBottom.constant = keyboardHeight
        }
    }
    
    // 키보드 내려왔을 때
    @objc func keyboardWillHide(_ notification: NSNotification) {
        textViewBottom.constant = 20
    }
}
