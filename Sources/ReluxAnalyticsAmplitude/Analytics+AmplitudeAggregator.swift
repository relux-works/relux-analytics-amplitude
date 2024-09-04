import Amplitude
import ReluxAnalytics

public extension Analytics {
    actor AmplitudeAggregator: Analytics.IAnalyticsAggregator {
        
        private let licenseKeyProvider: Analytics.LicenseKeyProviding
        private var amplitudeSDK: Amplitude?
        
        enum AmplitudeAggregator: Error {
            case sdkNotInitialized
            case emptyLicenseKey
        }
        
        public init(licenseKeyProvider: Analytics.LicenseKeyProviding) {
            self.licenseKeyProvider = licenseKeyProvider
        }
        
        public func setup(userId: String) async throws {
            amplitudeSDK = .init()
            guard let amplitudeSDK else {
                throw AmplitudeAggregator.sdkNotInitialized
            }
            let licenseKey = try await licenseKeyProvider.licenseKey
            guard licenseKey.isEmpty == false else {
                throw AmplitudeAggregator.emptyLicenseKey
            }
            amplitudeSDK.initializeApiKey(licenseKey)
            try await identifyClient(by: userId)
        }
        
        public func setUserProperties(_ userProperties: Analytics.Data) async throws {
            guard let amplitudeSDK else {
                throw AmplitudeAggregator.sdkNotInitialized
            }
            amplitudeSDK.setUserProperties(userProperties)
        }
        
        public func track(_ event: Analytics.Event, _ data: Analytics.Data?) async throws {
            guard let amplitudeSDK else {
                throw AmplitudeAggregator.sdkNotInitialized
            }
            amplitudeSDK.logEvent(event.rawValue, withEventProperties: data)
            return
        }
        
        // MARK: Private
        
        private func identifyClient(by id: String) async throws {
            guard let amplitudeSDK else {
                throw AmplitudeAggregator.sdkNotInitialized
            }
            amplitudeSDK.setUserId(id)
        }
    }
}
