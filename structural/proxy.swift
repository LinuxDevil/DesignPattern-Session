// Proxy Design Pattern
// --------------------

// The Proxy pattern is a structural design pattern that
// provides a surrogate or placeholder object to control
// access to another object. The proxy object has the same
// interface as the real object, so it can be used as a
// substitute for the real object. The proxy object can
// intercept calls to the real object and perform additional
// actions before or after the call is forwarded to the
// real object.

// Proxy is a structural design pattern that lets you provide
// a substitute or placeholder for another object. 
// A proxy controls access to the original object,
// allowing you to perform something either before
// or after the request gets through to the original object.

// Problem:
// Imagine the you want to create a payment service that
// makes payments using a payment gateway. The payment
// service is a very expensive object to create, so you
// want to create it only when it’s actually needed.
// You could implement lazy initialization: create this object
// only when it’s actually needed. All of the object’s clients
// would need to execute some deferred initialization code.
// Unfortunately, this would probably cause a lot of code duplication.
// The Proxy pattern suggests that you create a new proxy class with
// the same interface as an original service object. Then you update 
// your app so that it passes the proxy object to all of the
// original object’s clients. Upon receiving a request from a client,
// the proxy creates a real service object and delegates all
// of the work to it.

protocol PaymentServiceInterface {
    func makePayment(amount: Double, currency: String) -> Bool
}

class PaymentService: PaymentServiceInterface {
    func makePayment(amount: Double, currency: String) -> Bool {
        // Make payment using payment gateway
        return true
    }
}

class PaymentServiceProxy: PaymentServiceInterface {
    private let paymentService: PaymentService
    private var cachedPayments: [String: Bool] = [:]

    init(paymentService: PaymentService) {
        self.paymentService = paymentService
    }

    func makePayment(amount: Double, currency: String) -> Bool {
        let paymentKey = "\(amount)-\(currency)"
        if let cachedResult = cachedPayments[paymentKey] {
            print("Payment cached, returning cached result")
            return cachedResult
        } else {
            let paymentResult = paymentService.makePayment(amount: amount, currency: currency)
            cachedPayments[paymentKey] = paymentResult
            return paymentResult
        }
    }
}

// Example usage
let paymentService = PaymentService()
let paymentServiceProxy = PaymentServiceProxy(paymentService: paymentService)

paymentServiceProxy.makePayment(amount: 50.0, currency: "USD")
paymentServiceProxy.makePayment(amount: 100.0, currency: "USD")

// ==============================
// Another Example
// ==============================

protocol APIService {
    func fetchLargeData() -> [String: Any]
}

class RemoteAPIService: APIService {
    func fetchLargeData() -> [String: Any] {
        // Simulate fetching a large amount of data from an API
        return ["data": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]]
    }
}

class CachingAPIServiceProxy: APIService {
    private let remoteAPIService: RemoteAPIService
    private var cache: [String: [String: Any]] = [:]

    init(remoteAPIService: RemoteAPIService) {
        self.remoteAPIService = remoteAPIService
    }

    func fetchLargeData() -> [String: Any] {
        let cacheKey = "large-data"
        if let cachedResult = cache[cacheKey] {
            print("Data cached, returning cached result")
            return cachedResult
        } else {
            let remoteResult = remoteAPIService.fetchLargeData()
            cache[cacheKey] = remoteResult
            print("Data fetched remotely, caching and returning remote result")
            return remoteResult
        }
    }
}

// Example usage
let remoteAPIService = RemoteAPIService()
let cachingAPIServiceProxy = CachingAPIServiceProxy(remoteAPIService: remoteAPIService)

cachingAPIServiceProxy.fetchLargeData() 
// Data fetched remotely, caching and returning remote result
cachingAPIServiceProxy.fetchLargeData() 
// Data cached, returning cached result


// Use the proxy when for Lazy initialization (virtual proxy).
// This is when you have a heavyweight service object that wastes
// system resources by being always up, even though you only need 
// it from time to time.
// Caching request results (caching proxy).
// This is when you need to cache results of client
// requests and manage the life cycle of this cache,
// especially if results are quite large.