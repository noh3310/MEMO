## 메모 앱
애플 기본 메모앱을 따라 제작했습니다. 

기능은 아래와 같습니다.

- 메모 등록 & 수정
- 메모 검색
- 메모 고정(최대 5개)
- 메모 삭제
- 메모 공유

## 정보
- 최소버전
  - 13.0

### 사용 기술
- Storyboard
- Autolayout
- Calendar
- IQKeyboardManager
- UserDefault
- Realm
- Toast

## 수행한 것

- **Storyboard**로 **UI** 구현
- **UserDefault**를 사용해 앱을 처음 실행했는지 확인 후 분기처리
- **Realm**을 사용해서 메모정보 관리
- 메모정보 공유

## 배운 것

- 반투명한 **ViewController** 나타나게 하는 방법
- **Calendar**를 사용하여 날짜 처리하는 방법
- **ViewController** 생명주기

## Issue
- 뷰컨트롤러에 중복되는 코드 발생
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
- 홈화면에서 메모 최종작성날짜 enum 사용해 분기처리
  ``` Swift
  enum DateFormat: Int {
    case day
    case week
    case others
    
    func getDateFormat() -> String {
        switch self {
        case .day:
            return "a h:mm" // a는 오전, 오후
        case .week:
            return "EEEE" // 요일로 표현
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

