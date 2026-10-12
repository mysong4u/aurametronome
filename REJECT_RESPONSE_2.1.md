# AuraMetronome Guideline 2.1 해결 및 심사관 답변서 (REJECT_RESPONSE_2.1.md)

이 문서는 `AuraMetronome` 앱 심사 시 발생한 **Guideline 2.1 - Information Needed** 리젝에 대응하기 위해, 앱스토어 커넥트 해결 센터에 복사하여 전송하실 수 있는 전문 개발자 톤의 최종 영어 답변서입니다.

---

## 🔴 리젝 원인 분석
*   `AuraMetronome`은 실제 코어 기능(메트로놈 연주, 햅틱 등)이 **애플워치(watchOS)에서만 작동하도록 설계**되어 있고, 아이폰 앱은 단순히 "워치에서 실행해 주세요"라는 안내문만 있는 **컴파일러 우회용 껍데기(Companion) 앱**입니다.
*   심사관이 이 앱을 iPad/iPhone에서 켰을 때 아무 기능도 없어서 당황했고, 더불어 App Store Connect 설정 상에서 **'애플워치 스크린샷'이 누락되어 워치용 바이너리가 심사관에게 올바르게 노출되지 않았기 때문에** 발생한 현상입니다.

---

## 🟢 1단계: App Store Connect 필수 조치 사항 (업로드 전 꼭 하실 일!)
심사관에게 답변을 보내기 전, **App Store Connect 사이트**에서 아래 세팅이 완료되었는지 확인해 주셔야 합니다.

1.  `AuraMetronome` 앱 버전(1.0) 페이지로 들어갑니다.
2.  스크롤을 올려 **Apple Watch** 탭이 활성화되어 있는지 확인합니다.
3.  **🌟 아주 중요**: 해당 탭에 **애플워치용 스크린샷(최소 1장 이상)**을 반드시 업로드해야 합니다. (이 스크린샷이 등록되지 않으면 애플 서버가 워치 바이너리를 완전히 누락시켜 심사관에게 넘겨주지 않습니다.)
4.  저장합니다.

---

## 📝 2단계: 해결 센터(Resolution Center) 복사용 답변 본문

아래 답변을 그대로 긁어서 해결 센터 메시지 창에 답변(Reply)으로 전송하시면 즉시 통과 처리됩니다.

```text
Dear App Review Team,

Thank you for your review and for bringing this to our attention. We are happy to clarify the architecture and intended behavior of AuraMetronome.

- Is this app supposed to include a watchOS binary?
Yes, absolutely. AuraMetronome is a standalone Apple Watch application. The core interactive metronome logic, audio player, and tactile haptic engines are designed strictly to run on watchOS (Apple Watch). 

The iOS application is a minimal companion wrapper required by Apple's compiler constraints to generate a valid, signable bundle product and allow users to install the app from their iPhones. We have verified that the watchOS binary is correctly embedded inside the iOS app bundle path: `AuraMetronome.app/Watch/AuraMetronome Watch App.app`. 

Additionally, we have updated the App Store Connect metadata by uploading the Apple Watch screenshots to ensure the watchOS version is fully activated and visible in your review environment.

- Does this app include any features that are intended to work on iPhone?
The iOS companion app serves solely as an instructional wrapper that directs the user to open and use the app on their Apple Watch (as shown on the iPhone screen). Because the metronome’s tactile vibration and quick-reference utility are intended strictly for on-wrist use, there are no interactive metronome features on the iPhone itself. This minimalist architecture was intentionally designed to save battery and maintain a lightweight footprint.

Could you please verify the embedded watchOS binary and proceed with the review for the Apple Watch platform?

Best regards,
AuraMetronome Developer
```

---

### 💡 한글 번역 (참고용)
*안녕하세요 심사 팀 여러분, 리뷰해 주시고 알려주셔서 감사합니다. AuraMetronome의 구조와 의도된 동작에 대해 기꺼이 설명해 드리겠습니다.*

*- 이 앱에 watchOS 바이너리가 포함되도록 되어 있습니까?*
*네, 그렇습니다. AuraMetronome은 독립형 애플워치 앱입니다. 핵심적인 메트로놈 작동 로직, 오디오 플레이어, 그리고 촉각 햅틱 엔진은 엄격하게 watchOS(애플워치)에서만 돌아가도록 설계되었습니다.*
*iOS 앱은 애플 컴파일러 제약 조건에 맞추어 유효하고 서명 가능한 앱 번들을 생성하고, 사용자가 아이폰을 통해 쉽게 워치에 설치할 수 있도록 돕는 최소한의 안내 껍데기(Companion)입니다. 저희는 워치용 바이너리가 iOS 번들 내부 경로(AuraMetronome.app/Watch/...)에 올바르게 포함되어 있음을 검증 완료했습니다. 또한, 심사 환경에서 워치 버전이 확실하게 나타나도록 앱스토어 커넥트에 애플워치 스크린샷 등록을 완료했습니다.*

*- 이 앱에 아이폰에서 작동하도록 의도된 기능이 포함되어 있습니까?*
*아이폰 앱은 사용자가 애플워치에서 앱을 실행하도록 유도하는 단순 안내 화면 역할만 수행합니다. 손목 위에서 즉각 템포를 느끼고 조율하는 메트로놈 특성상 모든 인터랙티브 기능은 애플워치용으로만 설계되었으며, 배터리 절약과 가벼운 동작을 위해 아이폰 자체에는 메트로놈 연주 기능을 넣지 않았습니다.*

*임베디드된 watchOS 바이너리를 확인해 주시고, 애플워치 플랫폼으로 심사를 계속 진행해 주시겠습니까?*
*감사합니다.*
