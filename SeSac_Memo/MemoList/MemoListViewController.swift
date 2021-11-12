//
//  MemoListViewController.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/08.
//

import UIKit
import RealmSwift
import Toast

class MemoListViewController: UIViewController {
    
    static let identifier = "MemoListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let localRealm = try! Realm()
    
    var tasks: Results<Memo>!
    
    var searchText: String = "" {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaults 초기화(처음 화면 보여줄 때 사용)
//        for key in UserDefaults.standard.dictionaryRepresentation().keys {
//            UserDefaults.standard.removeObject(forKey: key.description)
//        }
        
        tasks = localRealm.objects(Memo.self)
        
        // 내비게이션바 설정
        setNavigationBar()
        
        // searchController 설정
        setSearchController()
        
        // editButton 설정
        setEditButton()
        
        // 처음왔을 때 화면 출력해주는 부분
        firstViewShow()
        
        // 테이블뷰 설정
        setTableView()
        
        print(localRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        setTitle()
    }
    
    // 내비게이션바 설정
    func setNavigationBar() {
        // 타이틀 large Title로 설정
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setTitle()
    }
    
    // 타이틀 텍스트 설정
    func setTitle() {
        let result = getNumberFormatString(count: tasks.count)
        
        self.navigationItem.title = "\(result)개의 메모"
    }
    
    // 숫자를 3개 단위로 잘라서 리턴해줌
    func getNumberFormatString(count: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let price = count
        let result = numberFormatter.string(for: price)!
        
        return result
    }
    
    // searchController 설정
    func setSearchController() {
        // searchController 선언
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .systemOrange
        
        self.navigationItem.searchController = searchController
    }
    
    // editButton 설정
    func setEditButton() {
        editButton.title = ""
        editButton.image = UIImage(systemName: "square.and.pencil")
        editButton.tintColor = .systemOrange
    }
    
    // 처음왔을 때 화면 출력해주는 부분
    func firstViewShow() {
        let userDefaults = UserDefaults.standard
        
        let value = userDefaults.bool(forKey: "first")
    
        // 처음왔다면
        if !value {
            // true로 설정해줌
            userDefaults.set(true, forKey: "first")
            
            let storyboard = UIStoryboard(name: "FirstView", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: FirstViewController.identifier) as! FirstViewController
            //  상위 뷰컨트롤러로 보여줌
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            
            self.navigationController?.present(vc, animated: false, completion: nil)
        }
    }
    
    // 테이블뷰 설정
    func setTableView() {
        // 델리게이트 권한 위임
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .black
        
        // 검색결과를 스크롤 하는 경우 키보드 내려줌
        tableView.keyboardDismissMode = .onDrag
    }
    
    // 새 메모버튼 클릭
    @IBAction func newMemoButtonClicked(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "EditMemo", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: EditMemoViewController.identifier) as! EditMemoViewController
        
        vc.backButtonTitle = "생성"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// 테이블뷰 익스텐션
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 출력해야할 메모리스트를 리턴해주는 메서드
    func getCellList(section: Int) -> Results<Memo> {
        if section == 2 {
            return tasks.filter("title CONTAINS[c] '\(searchText)' OR content CONTAINS[c] '\(searchText)'")
        }
        
        // 일단 section에 맞는 값을 전부다 리턴함
        let allMemoList = tasks.filter("mark == %@", (section == 0)).sorted(byKeyPath: "date", ascending: false)
        // 만약 검색값이 없다면 전체 리스트를 담고, 검색값이 있다면 필터해서 담아줌
        let memoList = (searchText == "") ? allMemoList : allMemoList.filter("title CONTAINS[c] '\(searchText)' OR content CONTAINS[c] '\(searchText)'")
        
        return memoList
    }
    
    // row의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 검색값이 있다면 메모들 안보여주고 검색메모들만 보여줌
        if searchText != "" && (section == 0 || section == 1){
            return 0
        }
        return getCellList(section: section).count
    }
    
    // section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // 헤더뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 셀 개수 리턴
        let searchList = getCellList(section: section)
        
        
        // 검색값이 있다면 검색값만 보여줌
        if (searchText != "" && (section == 0 || section == 1)) ||
            (searchText == "" && section == 2) {
            return nil
        }
        
        // 라벨 생성
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        // 리스트가 없다면
        if searchList.count == 0 {
            return nil
        }
        
        let count = (searchText == "") ? "" : getNumberFormatString(count: searchList.count)
        
        switch section {
        case 0: myLabel.text = "고정된 메모"
        case 1: myLabel.text = "메모"
        case 2: myLabel.text = "\(count)개 검색됨"
        default: break
        }

        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
    
    // 섹션헤더의 타이틀 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        // 검색값이 있다면 안보이게 해줌
        if searchText != "" {
            return (section == 2) ? 40 : 0
        }
        
        let searchList = getCellList(section: section)
        
        // 만약 각 섹션에 맞는 데이터가 없다면 0 리턴
        if searchList.count == 0 {
            return 0
        }
        
        return 40
    }
    
    // 어떤 cell을 리턴할것인지 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        // 출력할 셀값
        let cellData = getCellList(section: indexPath.section)[indexPath.row]

        // attributeString을 가져옴
        let titleText = cellData.title.searchData(text: cellData.title, searchText: searchText, defaultValue: "타이틀 정보 없음")
        
        // 날짜 타입에 맞게 변환
        let dateType = Date().getDateFormat(date: cellData.date)
        let date = Date().getStringFormat(date: cellData.date, format: dateType)
        
        // 콘텐츠
        let contentText = NSMutableAttributedString(string: "\(date) ")
        // cell에 보여줄 때 \n 없애고 보여줌
        if let rawContentData = cellData.content?.replacingOccurrences(of: "\n", with: "") {
            let contentData = rawContentData.searchData(text: rawContentData, searchText: searchText, defaultValue: "콘텐츠 없음")
            
            contentText.append(contentData)
        }
        else {
            contentText.append(NSAttributedString(string: "콘텐츠 없음"))
        }
        
        // 셀 설정
        cell.textLabel?.attributedText = titleText
        cell.detailTextLabel?.attributedText = contentText
        
        // 최대 1줄로 만들어줌
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.numberOfLines = 1
        
        // 배경색 설정
        cell.backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
        
        return cell
    }
    
    // 셀을 선택했을 때 수정화면으로 변경
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "EditMemo", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: EditMemoViewController.identifier) as! EditMemoViewController
        
        vc.memoItem = getCellList(section: indexPath.section)[indexPath.row]
        vc.backButtonTitle = "수정"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 왼쪽 스와이프(고정)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 섹션의 셀 데이터 가져옴
        let memo = getCellList(section: indexPath.section)[indexPath.row]
        
        // handler처리
        let fixButton = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in

            // 내가 지금 mark될 예정이고, 5개가 넘었다면 toast 띄워줌
            if memo.mark == false && self.tasks.filter("mark == true").count >= 5 {
                self.view.makeToast("고정은 5개 이상 할 수 없습니다.", duration: 1.0, position: .top)
            }
            // mark될 예정이 아니거나, 5개가 넘지않는 경우에는 메모 mark를 변경해줌
            else {
                // 데이터 변경(이때는 날짜를 안바꿔줌)
                try! self.localRealm.write {
                    memo.mark = !memo.mark
                }
            }
            
            // reloadData해줌
            self.tableView.reloadData()
        }
        
        // 고정되어있다면 고정 아이콘, 아니라면 pin.slash 아이콘 출력
        fixButton.image = memo.mark == true ? UIImage(systemName: "pin.slash") : UIImage(systemName: "pin.fill")
        
        fixButton.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [fixButton])
    }
    
    // 오른쪽 스와이프(삭제)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete 만들어줌
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            // 우선 alert를 띄워주고, 그다음에 삭제 해줌
            let alert = UIAlertController(title: "메모를 삭제하시겠습니까?", message: "삭제를 원하시면 삭제 버튼을 클릭해주세요.", preferredStyle: UIAlertController.Style.alert)
            
            // 취소버튼(아무런 행위를 안하므로 handler nil로 설정)
            let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
                // 테이블뷰 reload해줌
                self.tableView.reloadData()
            }
            
            // 확인버튼(데이터베이스에서 삭제한 컬럼 삭제해줌)
            let okAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                
                // 삭제하고자하는 object 받아옴
                let deleteMemo = self.getCellList(section: indexPath.section)[indexPath.row]
                
                // 메모 삭제
                try! self.localRealm.write {
                    self.localRealm.delete(deleteMemo)
                }
                
                // reloadData해줌
                tableView.reloadData()
                
                // 타이틀 변경
                self.setTitle()
                
                // 삭제했다고 toast 띄워줌
                self.view.makeToast("메모가 삭제되었습니다.", duration: 1.0, position: .top)
            }
            
            // 액션 alert에 추가해줌
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        // 삭제 스와이프 버튼 추가
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// 검색 관련 extension
extension MemoListViewController: UISearchResultsUpdating {
    
    // 텍스트 업데이트 했을때
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.searchText = text
    }
}
