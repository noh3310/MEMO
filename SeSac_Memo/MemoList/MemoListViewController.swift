//
//  MemoListViewController.swift
//  SeSac_Memo
//
//  Created by 노건호 on 2021/11/08.
//

import UIKit

class MemoListViewController: UIViewController {
    
    static let identifier = "MemoListViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내비게이션바 설정
        setNavigationBar()
        
        // searchController 설정
        setSearchController()
        
        // 델리게이트 권한 위임
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    // 내비게이션바 설정
    func setNavigationBar() {
        // 타이틀 large Title로 설정
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // 타이틀 텍스트 설정(이거 나중에 프로퍼티 옵저버로 할지 고민해봐야함
        self.title = "안녕하세요"
    }
    
    // searchController 설정
    func setSearchController() {
        // searchController 선언
        let searchController = UISearchController()
        self.navigationItem.searchController = searchController
    }
    
    
    // 새 메모버튼 클릭
    @IBAction func newMemoButtonClicked(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "EditMemo", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: EditMemoViewController.identifier) as! EditMemoViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "첫번째 섹션" : "두번째 섹션"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        // 셀의 내용 정하는 방법
        if #available(iOS 14.0, *) {
            // 이렇게 사용하는것이 나중에 사용될것이라고 함
            var content = cell.defaultContentConfiguration()
            
            content.text = "타이틀"
            content.secondaryText = "자세한 타이틀"
            
            cell.contentConfiguration = content
            
        } else {
            // 이 두개가 deperacited 될 것이라고 하고 위의 방법을 사용해야한다고 함
            cell.textLabel?.text = "타이틀"
            cell.detailTextLabel?.text = "aaa"
        }

        cell.backgroundColor = .lightGray
       
        return cell
    }
    
    // 왼쪽 스와이프(미구현)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // handler를 
        let fixButton = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("fix 클릭 됨")
            success(true)
        }
        
        // 만약 고정되어 있다면 pin.slash 사용하기
        fixButton.image = UIImage(systemName: "pin.fill")
        
        
        fixButton.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [fixButton])
    }
    
    // 오른쪽 스와이프(미구현)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete 만들어줌
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("delete 클릭 됨")
            success(true)
        }
        
        // 삭제
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}
