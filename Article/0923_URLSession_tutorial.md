# URL Session Tutorial 

[원본 출처 - raywenderlich](https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started)



### URLSession Overview

![이미지](https://koenig-media.raywenderlich.com/uploads/2019/05/02-URLSession-Diagram.png)



URLSession과 그것을 구성하는 클래스들에 대해 알아보자.

- URLSession은 HTTP와 HTTPS 기반 요청을 다루기 위한 클래스들로 구성되어있다. 
- request의 요청과 응답에 대한 책임을 지닌 핵심 오브젝트이다. 

URLSession은 `URLSessionConfiguration` 을 통해서 3가지 기호대로 생성할 수 있습니다.



### Type of URLSessionConfiguration 

- ##### default

  -  기본 설정으로 생성시, disk-persisted 글로벌 캐시, `credential(인증)` 및 `cookie storage` 오브젝트를 사용합니다. 

- ##### ephemeral(임시) 

  - default 생성방식과는 **모든 세션 관련 데이터를 메모리에 저장**한다는 차이가 존재합니다. 일종의 `private(비공개) 세션`으로 간주하면 됩니다.

- ##### background

  - 세션이 백그라운드에서 작동합니다. upload 또는 download 작업 수행에 적합합니다.
  - 앱 자체가 시스템에 의해 일시 중단되거나 종료된 경우에도 전송이 계속 됩니다. 

**`URLSessionConfiguration`** 은 timeout values, caching policies, HTTP headers와 같은 세션 프로퍼티를 설정할 수 있습니다.

**`URLSessionTask`** 은 태스크를 다루기 위한 추상클래스 입니다. 

`URLSession` 은 fetching data나 파일 업로드/다운로드 같은 실제 작업을 위해 하나 이상의 태스크를 생성합니다.



### Understanding Session Task Types

URLSessionTask는 크게 세 가지로 나뉜다. 크게 GET / POST(PUT) / 파일 다운로드로 구분가능.

- ***URLSessionDataTask*** 

  - GET :`server` 로부터 클라이언트 메모리로 데이터를 얻어오는 GET 요청을 수행하기 위해 사용된다.

- ***URLSessionUploadTask***

  - POST / PUT : 클라이언트 디스크로부터 웹서비스로 POST / PUT 메서드를 통해  file을 업로드 하기 위해 사용된다.

- ***URLSessionDownloadTask***

  - 외부 원격 서비스로부터 임시 파일 저장위치로 파일을 다운로드 받기 위해 사용된다. 

  ![이미지](https://koenig-media.raywenderlich.com/uploads/2019/05/03-Session-Tasks.png)

- 세션 태스크에는 Task를 suspend / resume / cancel 하기 위한 api 가 존재한다.
- DownloadTask에는 특별하게 향후 재개를 위한 일시중지 기능이 제공된다.



#### 일반적으로, URLSession은 데이터를 2가지 방법으로 반환합니다.

- 1) **completion handler** 사용 
  - 태스크가 성공적으로 완료되었을 때나 에러가 발생할 때 모두 쓸 수 있습니다. 
- 2) delegate를 통한 메서드 호출 
  - 세션을 생성할때 설정한 delegate에서 메서드를 호출합니다.



### DataTask and DownloadTask

- GET 요청의 샘플 코드이다. (출처 : raywenderlich.com)

  ```swift
  class QueryService {
      //
      // MARK: - Constants
      //
      // TODO 1
      let defaultSession = URLSession(configuration: .default)
      //
      // MARK: - Variables And Properties
      //
      // TODO 2
      var dataTask : URLSessionDataTask?
      var errorMessage = ""
      var tracks: [Track] = []
  
      //
      // MARK: - Type Alias
      typealias JSONDictionary = [String: Any]
      typealias QueryResult = ([Track]?, String) -> Void
  
      //
      // MARK: - Internal Methods
      func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
          // TODO 3
          // 1. stop previous task if exists
          dataTask?.cancel()
          // 2. do dataTask
          if var urlComponent = URLComponents(string: "https://itunes.apple.com/search"){
            	urlComponent.query = "media=music&entity=song&term=\(searchTerm)"
            // 3. check url with query string is valid
            	guard let url = urlComponent.url else {
            	 	 return
            	}
            // 4. dataTask 작업 (만약 POST/PUT/DELETE라면 url이 아니라 URLRequest를 넣어서 생성)
            	dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in defer {
              		self?.dataTask = nil
              }
              //5. check whether get data task is error or success
              if let error = error {
              		self?.errorMessage += "DataTask error: "+error.localizedDescription+"\n"
              }else if
               	 let data = data,
               	 let response = response as? HTTPURLResponse,
               	 response.statusCode == 200 {
               	 			self?.updateSearchResults(data)
               				DispatchQueue.main.async {
               				   completion(self?.tracks, self?.errorMessage ?? "")
              			  }
              		}
            	}
          }
          // 7. call the dataTask
          dataTask?.resume()
      }
    //...
  }
  ```

  



## 주의 !!

- ##### 만약 POST / PUT / DELETE를 요청하려면, `URLReqeust` with `url` 를 생성하고, 요청의 `HTTPMethod` 프로퍼티를 원하는 HTTP Method로 설정해야 합니다. 그리고 일반적인 Get 요청과 달리 `URL` 이 아니라 `URLRequest` 를 통해 dataTask를 생성해야 합니다.



## [ POST/PUT/DELETE 참고 코드 출처](http://www.digipine.com/index.php?mid=macios&document_srl=768)

```swift
import Foundation

class Request {
    let session: URLSession = URLSession.shared
    // GET METHOD
    func get(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    // POST METHOD
    func post(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    // PUT METHOD
    func put(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    // PATCH METHOD
    func patch(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    // DELETE METHOD
    func delete(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url) 
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
 
let request: Request = Request()
let url: URL = URL(string: "https://api.example.com/path/to/resource")!
let body: NSMutableDictionary = NSMutableDictionary()
body.setValue("value", forKey: "key")
try request.post(url: url, body: body, completionHandler: { data, response, error in
    // code
}) 
```



## [ POST/PUT/DELETE 참고 코드 출처2](https://www.tutorialspoint.com/how-to-make-an-http-post-request-on-ios-app-using-swift)

- 1) 세션 오브젝트를 생성한다.

  ```swift
  let configuration = URLSessionConfiguration.default
  let session = URLSession(configuration: configuration)
  ```

- 2) URL Request를 생성한다. GET/POST/DELETE/PUT 등이 사용가능하다. 아래 예제는 POST request 설정 방법 예이다.

  ```swift
  let url = URL(string: URLString)
  //let url = NSURL(string: urlString as String)
  var request : URLRequest = URLRequest(url: url!)
  request.httpMethod = "POST"
  request.addValue("application/json", forHTTPHeaderField: "Content-Type")
  request.addValue("application/json", forHTTPHeaderField: "Accept")
  request.httpBody = jsonData // 미리 설정한 jsonData 존재시 
  ```

- 3) **URLRequest** 객체를 생성하고 나면 dataTask를 URLRequest을 통해 실행시킨다. 예제코드에서는 url을 그냥 입력하였지만, 그 경우 GET 요청이 된다. 

  ```swift
  let dataTask = session.dataTask(with: request) { data,response,error in
     guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
     else {
        print("error: not a valid http response")
        return
     }
     switch (httpResponse.statusCode) {
        case 200: //success response.
           break
        case 400:
           break
        default:
           break
     }
  }
  dataTask.resume()
  ```



## [3번째 예제. JSON 데이터를 직접 Encode하고 POST 하는 예제](https://medium.com/@sdrzn/networking-and-persistence-with-json-in-swift-4-part-2-e4f35a606141)

[JSONPlaceholder’s simple REST API](https://jsonplaceholder.typicode.com/) 사이트를 통해 연습을 해봅니다. 



- 1) 다음과 같은 JSON Data 형식이 존재한다고 해봅시다.

  ```json
  {
    "userId": 1,
    "id": 1,
    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
  }
  ```

- 위 데이터를 메모리표현방식으로 모델링하면 다음과 같이 나타낼 수 있습니다. JSON Encoder/Decoder를 위해 Codable 프로토콜을 선언합니다. (사실 Codable은 두 프로토콜 Encodable & Decodable의 typealias 입니다. )

  ```swift
  struct Post: Codable {
      let userId: Int
      let id: Int
      let title: String
      let body: String
  }
  ```

- 이제 메모리에서 임의의 Post 구조체 생성 후 이를 JSON 으로 변형하여 POST하는 방식을 알아봅니다.

  ```swift
  let myPost = Post(userId: 1, id: 1, title: "Hello World", body: "How are you all today?")
  func submitPost(post: Post) {
      // ... 
  }
  ```

- 4) Codable 구조체에 대해 JSONEncoder를 먼저 실시하여 JSON data (bytes 형식)으로 변환합니다. 

- 5) 이 데이터는 우리의 URLRequest의 **HTTP body** 를 통해 전송될 것입니다.

  ```swift
  // 메서드 작동시 에러를 핸들링 하기 위해 completion 클로저를 만들어줍니다. 
  func submitPost(post: Post, completion:((Error?) -> Void)?) {
      var urlComponents = URLComponents()
      urlComponents.scheme = "https"		/// http || https 여부를 정합니다.
      urlComponents.host = "jsonplaceholder.typicode.com"
      urlComponents.path = "/posts"			/// host주소의 상세경로를 입력합니다. 
      guard let url = urlComponents.url else { 
        fatalError("Could not create URL from components") 
      }
  
      // 이 URLRequest 을 POST 메서드에 맞게 만들어줍니다.
      // GET 요청이라면 URLRequest 작업없이 
  	  // 			urlComponents.url을 session.dataTask의 인자로 전달해도 무방합니다.
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      // request의 HTTP body가 JSON으로 인코딩되었음을 알리기 위해
    	// body의 데이터타입(JSON encoded)등에 대한 헤더를 작성해야 합니다.
      var headers = request.allHTTPHeaderFields ?? [:]
      headers["Content-Type"] = "application/json"
      request.allHTTPHeaderFields = headers
      
      // Post 구조체를 JSON data로 인코딩합니다.
      let encoder = JSONEncoder()
      do {
          let jsonData = try encoder.encode(post)
          // URLRequest의 HTTP Body에 JSON Data를 설정합니다.
          request.httpBody = jsonData
          // print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
      } catch {
          completion?(error)
      }
      
      // URLSessionConfiguration를 설정하고, 이를 바탕으로 URLSession 객체를 생성합니다.
      // 이제, 세션객체를 통해 dataTask으로 HTTP/S 통신을 합니다. 
      // dataTask에 JSON encoded 데이터가 담긴 URLRequest를 인자로 전달합니다.
      let config = URLSessionConfiguration.default
      let session = URLSession(configuration: config)
      let task = session.dataTask(with: request) { (responseData, response, responseError) in
          guard responseError == nil else {
              completion?(responseError!)
              return
          }
          
          // APIs usually respond with the data you just sent in your POST request
          if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
              print("response: ", utf8Representation)
          } else {
              print("no readable data received in response")
          }
      }
      task.resume()
  }
  ```

- Post 요청 메서드 작성 후 실제 UI 이벤트 함수에 아래와 같이 작성하여 호출합니다.

  ```swift
  func buttonTapped() {
      let myPost = Post(userId: 1, id: 1, title: "Hello World", body: "How are you all today?")
      submitPost(post: myPost) { (error) in
          if let error = error {
              fatalError(error.localizedDescription)
          }
      }
  }
  ```

  

### Reference

 [Apple’s documentation](https://developer.apple.com/reference/foundation/urlsessionconfiguration)