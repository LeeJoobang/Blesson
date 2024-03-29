## Blesson

### 앱 소개

| <p align = "center"><img src = "https://user-images.githubusercontent.com/84652513/193572589-aaf84b6e-55a6-4c71-bf89-dd36dd12a8b6.gif"></p> | <p align="center"><img src="https://user-images.githubusercontent.com/84652513/193572863-01bfc8b7-9f5a-4ea8-b239-1644b685d303.gif"></p> |
| :----------------------------------------------------------: | :----------------------------------------------------------: |

- 프리랜서 강의 활동시 일정이 일정치 않아 인원 및 수입 관리 내용을 확인하는데 번거로움이 있습니다. 이에 사용자에게 현재 등록된 학생에 대한 관리를 돕기 위해 서비스를 제공하는 앱을 만들었습니다. 개인 학생 별 - 등록 횟수 및 레슨비, 일별 수업 참가인원 명단, 개인 학생별 메세지 발송, 메세지 템플릿 작성 등의 서비스를 제공합니다.

------

### 개발 기간 및 사용 기술

#### 개발기간

- '22. 08. 29. - 진행중.

#### 프로젝트 진행사항

|      날짜       |                             내용                             |                    비고                    |
| :-------------: | :----------------------------------------------------------: | :----------------------------------------: |
| 2022/8/29 - 9/7 | [Blesson 기획서](https://inframince.notion.site/Blesson-9c5e1d97a191471484ee99ab168cf786) |                                            |
|   2022/09/13    | [9월 13일 개발일지](https://www.notion.so/inframince/2022-09-13-1820353f445942c9b3f2fb9c4ff8ad3e) |                                            |
|   2022/09/14    | [9월 14일 개발일지](https://inframince.notion.site/2022-09-14-4553a358f5464ec9aa1f632a51b38b8a) |                                            |
|   2022/09/15    | [9월 15일 개발일지](https://inframince.notion.site/2022-09-15-03bbf6faa72e4a59bb774815d8e81b68) |                                            |
|   2022/09/17    | [9월 17일 개발일지](https://inframince.notion.site/2022-09-17-50d83235c9ed430b813ee78e8c9d320c) |                                            |
|   2022/09/18    | [9월 18일 개발일지](https://inframince.notion.site/2022-09-18-3b68421e30834d43b0c83b5f4a4c7dc3) |                                            |
|   2022/09/19    | [9월 19일 개발일지](https://inframince.notion.site/2022-09-19-60808a839789436fb020b2ba20948c87) |                                            |
|   2022/09/20    | [9월 20일 개발일지](https://inframince.notion.site/2022-09-20-9b03ff35b6954aebbc3f194e1c3f2122) |                                            |
|   2022/09/21    | [9월 21일 개발일지](https://inframince.notion.site/2022-09-21-33d152047e314b069eaa83a51544c9c0) |                                            |
|   2022/09/22    | [9월 22일 개발일지](https://inframince.notion.site/2022-09-22-7aab5e0320184ef7b8e2eb786b63dccc) |                                            |
|   2022/09/24    | [9월 24일 개발일지](https://inframince.notion.site/2022-09-24-b1db9d15e36c473a9f363c204a22fa99) |                                            |
|   2022/09/25    | [9월 25일 개발일지](https://inframince.notion.site/2022-09-25-a41fcc93a53d495b89c3583ae665c338) |                                            |
| 2022/09/26 - 27 | [9월 26 - 27일 개발일지](https://inframince.notion.site/2022-09-26-27-4df22322e7774a7fb5db37307f375ef4) |                                            |
|   2022/10/02    | [Blesson 소개 자료](https://inframince.notion.site/Blesson-8ebfff4cdb474d96b9f72229ad579d3c) |                                            |
|   2022/10/03    | [Blesson 회고1](https://inframince.notion.site/2022-10-02-de9dd0be55a842ef878c914cf4f7c370) [Blesson 회고2](https://velog.io/@hii5074/Blesson-%EA%B0%9C%EB%B0%9C-%ED%9A%8C%EA%B3%A0) |                                            |
|   2022/10/12    | [업데이트 방향](https://inframince.notion.site/Blesson-bb28fcd031724a488df50302481f4e29) |                                            |
|   2023/03/05    | [버전 업데이트](https://inframince.notion.site/bb28fcd031724a488df50302481f4e29) | UI 개선 및 기능 추가, 버그 수정, 권한 요청 |

#### 사용기술

- UIKit, Autolayout, Realm, SnapKit, Firebase, FSCalendar, SPM, Figma, MessageUI

------

### 고민과 해결

- 신규회원 정보 입력에 구성된 데이터 테이블이 각기 다른 뷰에서 사용될 때 중복 데이터 저장 방지를 위하여 정규화를 진행하였음. 이를 통해 데이터의 독립성을 높이고자 하였음.

- 뷰 객체에 대한 UI나 레이아웃, Import 등 뷰 컨트롤러에서 공통적으로 작성되는 코드를 구조화함으로써 가독성을 높이고, 코드 중복을 줄이기 위해 BaseViewController를 사용

- Firebase Cloud Messaging(FCM)을 이용해 푸시 알림 설정



### 회고

- 링크: [Blesson 개발 회고](https://velog.io/@hii5074/Blesson-개발-회고)
