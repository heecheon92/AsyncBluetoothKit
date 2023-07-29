//
//  CentralStateTestView.swift
//  AsyncBluetoothKitTest
//
//  Created by Heecheon Park on 7/27/23.
//

import SwiftUI
import AsyncBluetoothKit

struct CentralStateTestView: View {
    
    /*
     Wrapping class object into @ObservedObject implicitly makes the object
     conforms to MainActor, hence, may break fetching data from async stream
     within task modifier.
     */
    let ble: ABCentralManager
    @State private var bleState: ABCentralState = .unknown
    
    var body: some View {
        VStack {
            Text("BLE State: \(bleState.stringDescription)")
        }
        .padding()
        ._task {
            // 왜 poweredOn 에만 iteration이 돌아가는지 파악중....이해가 안되네...
            // ABCentralManager 안에서도 subscribe 하고 로깅중인데
            // ABCentralManager 안에서는 정상동작 함...
            
            // 추가로 파악된 사실.... AsyncStream은 multiple subscription을
            // 지원하지 않음... 한번 생성된 비동기 스트림은 한 Task 컨텍스트 안에서만
            // 사용가능...
            
            // 문제 해결완료됨...
            // 문제 1. ble.stateStream이 lazy로 단 1회 초기화된 AsyncStream으로
            // 스위프트는 아직 AsyncStream은 multiple subscription을 지원하지 않음
            // -> https://github.com/apple/swift-async-algorithms/issues/110
            
            // 해결 1. lazy 변수로 1회 초기화 하지 않고 어디서든 ABCentralManager를 통해
            // stateStream을 접근할때 computed property를 이용해 새로운 AsyncStream 인스턴스를 리턴하고
            // ABCentralManager의 프록시가 해당 인스턴스 메모리관리를 하도록 변경.
            
            // 문제 2. ble.stateStream은 struct이고 lazy 변수 초기화 closure 안에서
            // continuation을 세팅하는 과정을 거치는데 이때 이 클로져 안에서의 self는
            // 구조체의 instance를 가리키는 self가 아닌 복사된 self이고
            // 복사된 self의 continuation이 세팅되어서 아래 비동기 for문이 돌지 않았음.
            
            // 참고 2. struct와 enum은 pass-by-value임을 알고 있더라도 놓치기 쉬운 부분으로
            // struct의 lazy멤버 초기화를 통해 다른 멤버 변수를 세팅할 수 없음... (복제된 self의 멤버 변수가 세팅됨)
            
            // 해결 2. ABCentralStateStream을 struct -> class로 변경
            for await new in ble.stateStream {
                TestLog("\(new.stringDescription)")
                bleState = new
            }
        }
    }
}
