## 메모 앱

## 앱 기능
- 메모 등록 & 수정
- 메모 검색
- 메모 고정
- 메모 삭제
- 메모 공유

## Issue
- 각 뷰컨트롤러에 중복되는 코드 발생
  - Extension을 활용해 중복되는 코드 제거
- 앱을 처음 실행했을 때 반투명 ViewController 나타나게 하기
    - UserDefaults 사용해 분기 처리
- 반투명 ViewController 나타내는 방법
  ``` Swift
  let vc = storyboard.instantiateViewController(withIdentifier: FirstViewController.identifier) as! FirstViewController

  // View를 컨텍스트에서 유지한채로 Present
  vc.modalPresentationStyle = .overCurrentContext
  vc.modalTransitionStyle = .crossDissolve
  
  self.navigationController?.present(vc, animated: false, completion: nil)
  }
  ```
- 텍스트 공유하는 방법
  ``` Swift
  // 공유할 컨텐츠 저장
  let shareContent = [memoTextView.text]
  
  // ActivityViewControlleer 생성
  let vc = UIActivityViewController(activityItems: shareContent as [Any], applicationActivities: nil)
  vc.popoverPresentationController?.sourceView = self.view
  
  self.present(vc, animated: true, completion: nil)
  ```
- 오늘, 이번주, 그 이외의 날짜 분기처리
  ``` Swift
  enum DateFormat: Int {
    case day
    case week
    case others
    
    func getDateFormat() -> String {
        switch self {
        case .day:
            return "a h:mm" // a는 오전 오후
        case .week:
            return "EEEE" // 일요일, 화요일 처럼 표현
        case .others:
            return "YYYY. MM. dd a h:mm"
        }
    }
  }
  ```


## 아이폰 8 영상



https://user-images.githubusercontent.com/26789278/141436882-4369d63a-46f7-4f5e-a046-fe09802a699b.mp4


## 아이폰 13 Pro Max 영상



https://user-images.githubusercontent.com/26789278/141436937-e1180aed-45b3-4193-bd56-d8d59800cd3f.mp4

