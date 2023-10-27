# Capstone-Recycling_Resource_Recognition_Model
2023년 졸업작품 - AI 기반 소비자 참여 재활용 자원 선순환 플랫폼 개발 (2023.02.01 ~ 진행중)

## 프로젝트 개요

재활용 가능 자원의 폐기율을 줄이고 재활용율을 높이기 위해, 재활용 자원 거래 플랫폼 개발 프로젝트

## 주요 기능

- 이미지에서 재활용 가능한 자원('나무류', '종이류', '플라스틱류', '스티로폼류', '페트병류', '캔류', '유리병류', '의류', '비닐류') 인식
- 자원 분류 및 분석
- 실시간 예측 및 결과 시각화

## 주요 역할

- Figma 앱 디자인, Flutter 프론트 엔드 개발
- 이미지 전송 효율을 위해 Flask 를 활용한 이미지 전송 api 구현
- EfficientNet B0 아키텍처를 사용한 재활용 자원 인식 모델 구현 및
Tensorflow lite 변환으로 모바일 어플리케이션에 AI 모델 탑재
- 프로젝트의 진행 비용 단축 및 Linux 서버의 이해도를 높이고자 개인 서버를 구축하여 개발
- 재활용 자원 가격 API를 활용하여 Linux Cran 기능 활용 매월 1일 자동을 API 호출 및 데이터 자동 처리, 시각화

## 사용 언어 및 모델 프레임워크

- 언어: Dart, Python, Java
- 모델 프레임워크: Flutter, Spring, Spring Boot, Spring Security, Flask, Tensorflow
- 데이터베이스: MySQL, MongoDB
- 한국환경공단 재활용 자원 가격 API
- 재활용 자원 인식 모델
https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Recognition_Model

## 프로젝트 관련 이미지

### 프로세스
![프로세스](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/d0044913-1b71-442f-97b0-b55360ea036e)

### WBS
![WBS](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/c6272411-81a2-4ee2-8dd1-27377b634a76)

### Figma
![Figma](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/1f6f06c7-6d86-4506-aade-db7506472d09)

### Flow Chart
![Flow Chart](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/8b77bf55-c249-428a-9dac-44b5ba52e6e8)


## 시연 영상 및 이슈

### 로그인
![로그인](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/a2186860-11ed-410c-add3-b62f6853a57b)

### 회원가입
![signup1](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/7a8e4dc8-fedf-44e7-98b2-a1fd06219ef4)
![signup2](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/329b277c-5b8d-45b4-b970-43610964eadf)
![signup21](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/434b767f-2a48-43d0-98aa-4d9dc08fbb52)

![signup3](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/afce455e-299a-4006-8ecf-5565ec8e797e)
![signup4](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/c57290c9-a6c9-40d1-bbb6-b1d4f9ea0a08)
![signup5](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/7b5e6505-d31a-4a1e-a509-286e145fc9a7)

### 재활용 자원 거래, 재활용 자원 가격 데이터
![자원 거래 기능 1](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/9cc7c96e-5084-44df-b8fc-75e419006df5)
![자원 거래 기능 2](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/e47cb512-a8ad-45a4-a63a-92f3c5b45d78)
![자원 거래 기능 3](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/eed09caf-78b3-4075-97fd-79e4ad5d7972)

### 그 외 서비스 (재활용 배출 정보, 업사이클링 제품 쇼핑몰 예시)
![추가 기능](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/99a0d51f-cd26-4b7e-ba1d-da697424e180)
![추가 기능 2](https://github.com/Kimdeokryun/Capstone-Recycling_Resource_Trading_Platform/assets/96904134/abf0db78-1dbe-4612-a2a4-80ddb87105d0)


### 이슈 

#### UI/UX 설계의 어려움
앱 어플리케이션을 실제 서비스화 한다는 목표를 가지고 프로젝트를 진행하였습니다.
그렇기 때문에 실제 앱 서비스에 준하는 UI/UX 를 설계하고 개발하기 위해서 실제 상용화 중인 다양한
앱 어플리케이션들을 벤치마킹하여 프론트엔드를 개발하였습니다.

#### 앱 어플리케이션 자동 로그인 방법
상용화중인 앱 어플리케이션의 경우에는 최초 로그인 이후, 로그아웃되지 않는 다는 점이 있습니다.
이를 반영하기 위한 방법으로 JWT 를 통한 로그인 토큰 반영 및 API 호출 보안을 강화하였습니다. 또한, 
FlutterSecureStorage 에 로그인 유저 기본 정보 및 토큰을 저장하고 관리하여, 자동 로그인 기능을
반영하였습니다.

#### 이미지 전송 API 관리
Spring 에서는 이미지 전송 기능의 구현이 어렵다는 백엔드 개발자 팀원의 의견을 반영하여, DB 에 이미지의
주소를 저장 및 관리하고, 이를 Flask api 를 통해 이미지를 전송하는 방식으로 구현하였습니다. 해당 과정에서
ngrok 를 통한 외부접속을 가능하게 환경을 구성하고, 서비스 이용 딜레이를 감소시키기 위해 비동기 처리로 구성하였습니다


### 추가 기능 구상 (feat.Notion)
====================환경문제를 해결할 수 있는 새로운 방안=================

- 현재까지 진행한 프로젝트에서 사용한 기술과 코드를 최대한 재활용할 수 있는 범주 내에서 찾아봄
- 환경 문제를 해결할 수 있는 특이성이 있어야 함.
- 우리 앱의 정체성과 벗어나서는 안 됨

이러한 생각들을 가지고 생각해본 3가지의 방안

- 일일 챌린지(**매일 새로운 재활용 관련 챌린지를 제공. 예를 들어, "오늘은 어떻게 하면 플라스틱 병 3개를 재활용할 수 있을까?"와 같은 질문으로 시작하는 챌린지.**)
- 실시간 순위판 기능 (현재 거래를 한 횟수가 지정되는 시스템이 있음. 그에 따라서 사용자들은 각자 다른 등급을 부여 받음(뱃지 시스템). 이를 활용하여 사용자의 닉네임과 비공개 처리된 핸드폰 번호를 기반으로 순위표를 작성)
- 소비자 참여 강화 게임 챌린지 (**사용자들이 자원을 새로운 방식으로 활용하도록 독려하는 것은 중요한 과제일 것입니다. 게임 요소를 도입하여 사용자들이 참여할 수 있는 재미있는 경쟁적 환경을 만드는 것은 어떨까요? 예를 들어, 최대한 많은 자원 재활용에 대한 포인트를 얻거나 다른 사용자들과 협력하여 공동 목표 달성 등이 있습니다.**)

- 아이스 버킷 챌린지에서 확장된 무언가를 추가 하고 싶은데…..(**재활용 챌린지, 소셜미디어 연계 홍보**)

- 재활용 버킷 챌린지
    
    **사용자들에게 일주일 동안 특정 종류의 재활용품(예: 플라스틱 병, 종이 상자 등)만 모으도록 도전하게 하는 캠페인을 만들어보세요. 사용자들은 자신의 진행 상황을 사진으로 찍어 앱에 업로드하고, 그 과정에서 포인트를 얻거나 랭킹에 이름을 올릴 수 있습니다.**
    

- 소셜미디어 연계 홍보
    
    **소셜미디어 플랫폼(예: 인스타그램, 페이스북 등)과 연계하여 #RecycleChallenge 와 같은 해시태그를 만든 후 사용자들이 자신의 재활용 활동을 공유하도록 권장합니다. 이는 캠페인의 가시성을 높이고, 더 많은 사람들에게 영향력을 미칠 수 있습니다.**





# ecocycle

A Flutter Project of Capstone Design

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
