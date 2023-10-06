# AVIRO 
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FJeon0976%2FAVIRO&count_bg=%233DC8AC&title_bg=%231173B4&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

<img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/ad/78/8a/ad788a0c-00b4-3859-fca1-310cf17bfb43/0d867ebd-4237-4046-b0d5-61dbb3d2d0de_1290_2796-1.png/1290x2796bb.png" width="280" height="560"> <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/a0/61/45/a061455a-880c-8d21-3c83-9a624a1263b0/ed9198bf-8d10-42b2-ad9b-261381a6abfe_1290_2796-2.png/1290x2796bb.png" width="280" height="560">

<img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/ad/d0/0c/add00c09-7f4c-5603-5030-16c24fb1794c/c32a953e-88ea-445c-a9f2-82387b1e378b_1290_2796__U00281_U0029.jpg/1290x2796bb.png" width="190" height="360"> <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/ac/eb/10/aceb1044-29fa-38c3-a0b6-091b7195179a/a5d98c00-c3ce-4bdc-abdb-5808d5431db9_1290_2796__U00282_U0029.jpg/1290x2796bb.png" width="190" height="360"> <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/23/db/70/23db70b4-0692-f038-cfe2-104355df2393/6b9d391f-a4da-4265-b4b8-ac6b2d0e4b7e_1290_2796__U00283_U0029.jpg/1290x2796bb.png" width="190" height="360"> <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/2e/20/a2/2e20a2d4-c158-3324-ee45-0bc660031bc1/502eb4f5-f458-4f5b-a93c-f6119dd57928_1290_2796__U00284_U0029.jpg/1290x2796bb.png" width="190" height="360">

## 설명 
- 비건 식당, 카페, 술집 등 음식점에 비건 음식이있거나, 모든 음식이 비건인 식당을 구분해서 공유하는 플랫폼입니다. 
- 식당을 직접 추가하거나 삭제할 수 있습니다. 
- 메뉴의 요청사항을 따로 기입할 수 있습니다. 
- 식당의 후기를 작성해서 유저들끼리 정보를 공유할 수 있습니다.
## 스킬  
- UIKit 
- MVP 
- Code Base UI 
## 활용 도구 
- SwiftLint
- NaverMap SDK 
- Amplitude SDK
## 기타 외부 라이브러리
- Lottie
- Toast-Swift
- KeychainSwift
## 구조도 
```
.
├── AVIRO.entitlements
├── Custom
│   ├── Constants
│   │   ├── Enum+.swift
│   │   ├── UIColor+Extension.swift
│   │   ├── UIFont+Extension.swift
│   │   └── UIImage+Extension.swift
│   ├── Extension
│   │   ├── Double+Extension.swift
│   │   ├── Marker+Extension.swift
│   │   ├── String+Extension.swift
│   │   ├── UIButton+Extension.swift
│   │   ├── UILabel+Extension.swift
│   │   ├── UIView+Extension.swift
│   │   └── UIViewController+Extension.swift
│   ├── SubClass
│   │   ├── UIButton
│   │   │   ├── CategoryButton.swift
│   │   │   ├── GenderButton.swift
│   │   │   ├── HomeMapReferButton.swift
│   │   │   ├── HomeTopButton.swift
│   │   │   ├── MenuPlusButton.swift
│   │   │   ├── MyPage
│   │   │   │   └── EditNickNameButton.swift
│   │   │   ├── NextPageButton.swift
│   │   │   ├── PlaceView
│   │   │   │   ├── EditInfoButton.swift
│   │   │   │   ├── ReviewWriteButton.swift
│   │   │   │   └── ShowMoreButton.swift
│   │   │   └── VeganOptionButton.swift
│   │   ├── UISegmentedControl
│   │   │   └── UnderlineSegmentedControl.swift
│   │   ├── UITextField
│   │   │   ├── EnrollField.swift
│   │   │   ├── MainField.swift
│   │   │   ├── MenuField.swift
│   │   │   ├── RegistrationField.swift
│   │   │   └── SearchField.swift
│   │   └── UITextLabel
│   │       ├── NoResultLabel.swift
│   │       ├── PlaceView
│   │       │   ├── MenuTypeLabel.swift
│   │       │   └── ReviewLabel.swift
│   │       └── TutorialTopLabel.swift
│   └── Utility
│       ├── LocationUtility.swift
│       └── TimeUtility.swift
├── Manager
│   ├── APIManager
│   │   ├── APIManagerProtocol.swift
│   │   ├── APITypes.swift
│   │   ├── AVIROManager
│   │   │   ├── AVIROAPIManager.swift
│   │   │   ├── AVIROAPIManagerProtocol.swift
│   │   │   ├── AVIRODeleteAPI.swift
│   │   │   ├── AVIROPostAPI.swift
│   │   │   └── AVIRORequestAPI.swift
│   │   ├── KakaoMapManager
│   │   │   ├── KakaoAPIManager.swift
│   │   │   ├── KakaoAPIManagerProtocol.swift
│   │   │   └── KakaoMapRequestAPI.swift
│   │   └── PublicManager
│   │       ├── PublicAPIManager.swift
│   │       ├── PublicAPIRequestComponents.swift
│   │       └── PublicXMLParserDelegate.swift
│   └── FacadeManager
│       ├── BookmarkManager.swift
│       ├── MarkerModelManager.swift
│       └── SearchHistoryManager.swift
├── Model
│   ├── APIResonseModel
│   │   ├── AVIRO
│   │   │   ├── AVIROGet
│   │   │   │   ├── CheckPlace
│   │   │   │   │   ├── AVIROCheckPlace+DTO.swift
│   │   │   │   │   └── AVIROPlaceReportCheck+DTO.swift
│   │   │   │   ├── DetailPlace
│   │   │   │   │   ├── AVIROOperationHours+DTO.swift
│   │   │   │   │   ├── AVIROPlaceInfo+DTO.swift
│   │   │   │   │   ├── AVIROPlaceMenus+DTO.swift
│   │   │   │   │   ├── AVIROPlaceReviews+DTO.swift
│   │   │   │   │   └── AVIROPlaceSummary+DTO.swift
│   │   │   │   ├── Marker
│   │   │   │   │   ├── AVIROBookmark+DTO.swift
│   │   │   │   │   └── AVIROMapMarker+DTO.swift
│   │   │   │   └── MyPage
│   │   │   │       └── AVIROMyContributionCount+DTO.swift
│   │   │   └── AVIROPost
│   │   │       ├── AVIROResult+DTO.swift
│   │   │       ├── Compare
│   │   │       │   └── AVIROMainSearchCompare+DTO.swift
│   │   │       ├── Edit
│   │   │       │   ├── AVIROEditCommonBeforeAfterDTO.swift
│   │   │       │   ├── AVIROEditLocation+DTO.swift
│   │   │       │   ├── AVIROEditMenuModel+DTO.swift
│   │   │       │   ├── AVIROEditOperationTime+DTO.swift
│   │   │       │   ├── AVIROEditPhone+DTO.swift
│   │   │       │   └── AVIROEditURL+DTO.swift
│   │   │       ├── Enroll
│   │   │       │   ├── AVIROEnrollPlace+DTO.swift
│   │   │       │   └── AVIROReview+DTO.swift
│   │   │       ├── Report
│   │   │       │   ├── AVIROReportPlace+DTO.swift
│   │   │       │   └── AVIROReportReview+DTO.swift
│   │   │       ├── Update
│   │   │       │   └── AVIROUpdateBookmark+DTO.swift
│   │   │       └── User
│   │   │           └── AVIROUser+DTO.swift
│   │   ├── KakaoMap
│   │   │   ├── KakaoAddressPlace+DTO.swift
│   │   │   ├── KakaoCoordinateSearchDTO.swift
│   │   │   ├── KakaoKeywordPlace+DTO.swift
│   │   │   └── KakaoKeywordResultDTO.swift
│   │   └── Public
│   │       └── PublicAddress+DTO.swift
│   ├── EnrollViewModel
│   │   ├── MenuModel.swift
│   │   ├── RequestTableFieldModel.swift
│   │   └── VeganTableFieldModel.swift
│   ├── HomeViewModel
│   │   ├── EditModel
│   │   │   ├── EditMenuChangedMarkerModel.swift
│   │   │   └── EditOperationHoursModel.swift
│   │   ├── HomeSearchViewModel
│   │   │   ├── HistoryTableModel.swift
│   │   │   ├── MatchedPlaceCellModel.swift
│   │   │   └── MatchedPlaceModel.swift
│   │   ├── MarkerModel.swift
│   │   ├── PlaceViewModel
│   │   │   └── PlaceTopModel.swift
│   │   └── ReportModel
│   │       └── ReportReviewModel.swift
│   ├── LocalDataModel
│   │   ├── LocalBookmarkData.swift
│   │   └── LocalMarkerData.swift
│   ├── MyPageModel
│   │   └── MyDataModel.swift
│   ├── PlaceListModel
│   │   ├── PlaceListCellModel.swift
│   │   └── PlaceListModel.swift
│   ├── SingletonModel
│   │   ├── APISingleton
│   │   │   └── KakaoAPISortingQuery.swift
│   │   ├── CoordinateSingleton
│   │   │   ├── CenterCoordinate.swift
│   │   │   └── MyCoordinate.swift
│   │   ├── MyData
│   │   │   └── MyData.swift
│   │   └── ViewLogic
│   │       └── AppController.swift
│   └── UserModel
│       └── AppleUserLoginModel.swift
├── Scene
│   ├── Presenter
│   │   ├── EnrollPlace
│   │   │   ├── EnrollPlacePresenter.swift
│   │   │   └── PlaceList
│   │   │       └── PlaceListSearchViewPresenter.swift
│   │   ├── Home
│   │   │   ├── EditPresenter
│   │   │   │   ├── ChangeableAddressPresenter
│   │   │   │   │   └── ChangeableAddressPresenter.swift
│   │   │   │   ├── EditMenuPresenter.swift
│   │   │   │   └── EditPlaceInfoPresenter.swift
│   │   │   ├── HomeSearchPresenter
│   │   │   │   └── HomeSearchPresenter.swift
│   │   │   ├── HomeViewPresenter.swift
│   │   │   └── ReportPresenter
│   │   │       └── ReportReviewPresenter.swift
│   │   ├── Login
│   │   │   ├── LoginViewPresenter.swift
│   │   │   └── RegistrationPresenter
│   │   │       ├── FirstRegistrationPresenter.swift
│   │   │       ├── SecondRegistrationPresenter.swift
│   │   │       └── ThridRegistrationPresenter.swift
│   │   └── Mypage
│   │       ├── MyPageViewPresenter.swift
│   │       └── NickNameChangeblePresenter.swift
│   └── View
│       ├── Login
│       │   ├── LoginViewController.swift
│       │   └── Registration
│       │       ├── FinalRegistrationViewController.swift
│       │       ├── FirstRegistrationViewController.swift
│       │       ├── SecondRegistrationViewController.swift
│       │       ├── TermsTableCell.swift
│       │       └── ThridRegistrationViewController.swift
│       ├── TabBar
│       │   ├── Enroll
│       │   │   ├── EnrollPlaceList
│       │   │   │   ├── PlaceListCell.swift
│       │   │   │   └── PlaceListSearchViewController.swift
│       │   │   ├── EnrollPlaceViewController.swift
│       │   │   └── SubView
│       │   │       ├── EnrollMenuTableView.swift
│       │   │       ├── EnrollStoreInfoView.swift
│       │   │       ├── EnrollVeganDetailView.swift
│       │   │       └── MenuTableView
│       │   │           ├── NormalTableViewCell.swift
│       │   │           └── RequestTableViewCell.swift
│       │   ├── Home
│       │   │   ├── Edit
│       │   │   │   ├── EditMenu
│       │   │   │   │   ├── EditMenuViewController.swift
│       │   │   │   │   └── SubView
│       │   │   │   │       ├── EditMenuBottomView.swift
│       │   │   │   │       └── EditMenuTopView.swift
│       │   │   │   └── EditPlaceInfo
│       │   │   │       ├── EditPlaceInfoSubView
│       │   │   │       │   ├── ChangeableAddressViewController
│       │   │   │       │   │   ├── ChangeableAddressViewController.swift
│       │   │   │       │   │   └── EditLocationSubView
│       │   │   │       │   │       ├── EditLocationAddressMapView.swift
│       │   │   │       │   │       ├── EditLocationAddressTextTableViewCell.swift
│       │   │   │       │   │       └── EditLocationAddressTextView.swift
│       │   │   │       │   ├── EditHomePageView.swift
│       │   │   │       │   ├── EditLocationBottomView.swift
│       │   │   │       │   ├── EditLocationTopView.swift
│       │   │   │       │   ├── EditOperatingHoursView.swift
│       │   │   │       │   ├── EditPhoneView.swift
│       │   │   │       │   └── EditoperatingHoursSubView
│       │   │   │       │       ├── EditOperatingHourView.swift
│       │   │   │       │       ├── EditOperationHourChangebleView.swift
│       │   │   │       │       └── EditTimeChangebleView.swift
│       │   │   │       └── EditPlaceInfoViewController.swift
│       │   │   ├── HomeSearch
│       │   │   │   ├── HomeSearchViewController.swift
│       │   │   │   └── SubView
│       │   │   │       ├── HeaderView
│       │   │   │       │   ├── HistoryHeaderView.swift
│       │   │   │       │   └── PlaceListHeaderView.swift
│       │   │   │       ├── HistoryTableViewCell.swift
│       │   │   │       ├── HomeSearchViewTableViewCell.swift
│       │   │   │       ├── NoHistoryLabelView.swift
│       │   │   │       └── NoHistoryView.swift
│       │   │   ├── HomeViewController.swift
│       │   │   ├── PlaceDetail
│       │   │   │   ├── PlaceView.swift
│       │   │   │   └── SubView
│       │   │   │       ├── OperationHours
│       │   │   │       │   ├── PlaceOperationHoursViewController.swift
│       │   │   │       │   └── PlaceOperationSubView
│       │   │   │       │       ├── OperationHourView.swift
│       │   │   │       │       └── OperationHoursView.swift
│       │   │   │       ├── PlaceSegmentedControlView.swift
│       │   │   │       ├── PlaceSummaryView.swift
│       │   │   │       └── SegmentedControlSubView
│       │   │   │           ├── PlaceHomeView.swift
│       │   │   │           └── SubView
│       │   │   │               ├── PlaceInfoView.swift
│       │   │   │               ├── PlaceMenuView.swift
│       │   │   │               ├── PlaceReviewWriteView.swift
│       │   │   │               ├── PlaceReviewsView.swift
│       │   │   │               ├── SubView
│       │   │   │               │   └── PushCommentView.swift
│       │   │   │               └── TableView
│       │   │   │                   ├── PlaceMenuTableViewCell.swift
│       │   │   │                   └── PlaceReviewTableViewCell.swift
│       │   │   ├── Report
│       │   │   │   ├── ReportCellView.swift
│       │   │   │   └── ReportReviewViewController.swift
│       │   │   └── ViewController
│       │   │       └── ChangedViewAction.swift
│       │   ├── MyPage
│       │   │   ├── MyPageViewController.swift
│       │   │   ├── NickNameChangebleView
│       │   │   │   └── NickNameChangebleViewController.swift
│       │   │   └── SubView
│       │   │       ├── MyInfoView.swift
│       │   │       ├── OtherActionsView.swift
│       │   │       └── SettingCell.swift
│       │   └── TabBarViewController.swift
│       └── Tutorial
│           ├── TutorialCell
│           │   ├── BottomCell.swift
│           │   └── TopCell.swift
│           └── TutorialViewController.swift
└── Utils
```
