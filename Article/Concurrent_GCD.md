# Concurrent Programming & GCD

- Concurrent vs Parallel vs Serial
  - https://takuti.me/note/parallel-vs-concurrent/
- Sync vs Async



##  Preview

- Process : 메모리 자원을 할당받아 실행중인 프로그램. Instruction의 집합
- Thread : Process 내 작업단위
- **프로세스 vs 스레드**
  - 프로세스는 실행되고 있는 하나의 프로그램을 의미. (프로그램 인스턴스) 
  - 프로세스는 time-sharing 시스템의 작업단위를 의미하기도 한다. 하나의 시스템은 여러 프로세스의 집합으로 구성
  - 쓰레드는 한 프로그램 내에서 실행되는 흐름의 단위. 스케줄러에 의해 독립적으로 관리 가능. 명령 코드나 데이터 공유, 병렬처리가 가능.
  - **쓰레드는 sub-process**임. 스레드는 명령코드와 데이터 공유가 가능하나 프로세스는 불가능하다.





## Concurrent

- 여러 작업에 대해 처리하는 대상(논리적인 프로세서)가 하나. 

## Parallel 

- 여러 작업을 여러 처리 시스템(물리적으로 다중 프로세서)이 처리함

  

### NSThread class

- Thread를 low-level에서 다루기 위한 클래스



### Perform Selector (NSObject methods)

- performSelectorOnMainThread:withObject:waitUntilDone:
- performSelector:withObject:afterDelay:
- performSelectorOnMainThread:withObject:waitUntilDone:modes:

  ...



### Concurrent Programming (Advent of these two)

**Benefit**

- UI keeps responsive while processing
- Faster operation by parallel execution

- 스레드를 효율적으로 관리하기 위해 **GCD도 자체적으로 스레드 풀을 지니고 있음.**

**Cost**

- Writing good multi-threaded code is **EXTREMELY hard!!**
- General Problem of executing multiple tasks in a scalable way
- 멀티스레딩 환경에서 유의할 점
  - 가령, 여러 thread가 하나의 클래스에 대해 동시에 접근하여 쓰는 것을 허용하면 app이 shut down됨
  - File Write에 대해 Lock을 설정해야 할 필요가 있음
  - 혹은 Ref Type(class) 보다 Value Type(struct)로 작업을 하면 Copy On Write 정책으로 안전.







### cf. Operation Queue

- iOS 2 부터 사용 

- **Operation Objects**

  - Operation 
    - 커스텀 operation을 만들기 위한 상위 클래스
  - BlockOperation.init(block: () - Void )
    - block(objective-C의 블록은 swift의 클로저에 대응됨) 기반 operation 객체 만들기
  - **Operation Queue**
    - GCD 큐의 추상화 클래스
    - 작업 취소가 불가능 (큐에 들어가면 무조건 실행됨) / 대신 코드레벨에서 취소 가능.

  ```swift
  let operationQueue
  ```

  

### GCD (Grand Central Dispatch)

- iOS 4부터 사용

- Technology Stack
  - Application / UIKit / lldbSystem / GCD / Kernel
  - OS 레벨에서 커널 바로 윗단에 존재
- Operation Queue와 동작방식이 유사. 
  - 큐 존재
  - 좀 더 세부적으로 큐를 다룰 수 있음
  - 스레드 풀 존재 (스레드 리 사이클링)
- Simplifying Your Code (GCD  장점)
  - Efficiency
    - More CPU cycles available for your code
  - Better metaphors
    - Blocks are easy to use
    - Queues are inherently producer/consumer
  - Systemwide perspective
    - Only the OS can balance unrelated subsystems
- Simplifying Your Code with GCD (compatibility)
  - 보일러플레이트 코드가 거의 없어짐
  - 명시적인 스레드 관리 코드가 필요없음
  - 큐에 들어온 것이 반드시 동작할 것을 보장 / 취소작업 만들기 어려움
  - Existing threading and synchronisation primitives are 100% compatible
  - GCD threads are wrapped POSIX threads
    - Do not cancel, exit, kill, join, or detach GCD threads
  - GCD reuse thread (스레드 Pool 사용하므로)
    - GCD는 OperationQueue와 달리 매번 스레드를 만들지 않고 재사용한다.



cf. **autoreleasepool**

- 스레드 풀 작업간에 쌓인 메모리를 해제하는 키워드



cf. 데이터 정합성 관련

- Lock을 걸어도 데이터 정합성 문제가 생길수는 있음

- Operation을 합쳐서 순서를 보장하든가, operation 간의 순서를 지정할 수 있음

  

**Locking**

- Enforce mutually exclusive access to critical sections

- Serialize access to shared state bet threads

- Ensure data integrity



### Inter-Thread Communication (perform selectors)

performSelector(onMainThread:#Selector, with: Any?, waitUntilDone:Bool)

performSelector(aSelector:Selector,...

performSelector( …TimeInterval)

performSelector( inBackground: Selector, with:)



#### WaitUntilDone: **No** 

DispatchQueue.main.**async**{	//화면 작업과 동시에 아래 메서드를 수행가능

​	myObject.doSomething(foo, withData: bar)

}

#### WaitUntilDone: **Yes**

DispatchQueue.main.**sync**{	//화면작업 중에 아래의 코드 작업을 기다림

​	myObject.doSomething(foo, withData: bar)

}



#### 어떤 작업, 시간 이후에 작업하도록 비동기 순서 보장

DispatchQueue.main.**asyncAfter**(deadline: .now() + .milliseconds(500)){

​	myObject.doSomething(foo, withData: bar)

}



#### performSelector(inBackground:with:)

DispatchQueue.**global()**.async {		// global() 큐는 main 외의 작업에 활용하는 백그라운드 작업용 큐

​	myObject.doSomething(foo, withData: bar)

}



### Queues (Serialization)

- 작은 단위의 블록 리스트 수행에 적합하다. Lightweight list of blocks
- Enqueue와 dequeue는 FIFO로 진행된다.
- 시리얼 큐는 한번에 하나의 작업만 수행한다.





### Queues (concurrency)

- 동시성 큐들은 여러 블록을 동시에 수행한다.
- 동시적으로 실행되는 블록들은 순서에 상관없이 완료된다.
- 큐들은 다른 큐들에 대해 동시적으로 실행된다. 
- 시분할 단위로 쪼개서 작업을 수행한다.



### Queues (API)



### Queues(API)

- Suspending

- Managing



- 유의할 점
  - 일반적인 목적의 데이터 구조가 아님
  - 흐름 제어를 위한 것
  - 큐에 블록을 한 번 추가하면 반드시 실행된다.
  - 동기화 API 사용할 때는 조심할 것.



### Queues Type

- Global queue (Concurrent)
  - DispatchQueue.global(qos: )
- Main Queue (Serial)
  - DispatchQueue.main

- Custom Queue (Serial/Concurrent Queue)
  - DispatchQueue.init(label: String, qos: attributes:)





### GCd Design Patterns

Low-level event notifications

- Similar approach to UI event-driven programming
- Don't poll or block a thread waiting for external events
  - Waiting on a socket
  - Polling for directory chages
- Dispatch sources
  - Monitor external OS events
  - Respond on-demand



