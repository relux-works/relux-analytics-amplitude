import Amplitude
import ReluxAnalytics

extension Analytics {
    actor AmplitudeAggregator: Analytics.IAnalyticsAggregator {
        
        private let licenseKeyProvider: Analytics.LicenseKeyProviding
        private var amplitudeSDK: Amplitude?
        
        enum AmplitudeAggregator: Error {
            case sdkNotInitialized
            case emptyLicenseKey
        }
        
        init(licenseKeyProvider: Analytics.LicenseKeyProviding) {
            self.licenseKeyProvider = licenseKeyProvider
        }
        
        func setup(userId: String) async throws {
            amplitudeSDK = .init()
            guard let amplitudeSDK else {
                throw AmplitudeAggregator.sdkNotInitialized
            }
            let licenseKey = try await licenseKeyProvider.licenseKey
            guard licenseKey.isEmpty == false else {
                throw AmplitudeAggregator.emptyLicenseKey
            }
            amplitudeSDK.initializeApiKey(licenseKey)
            amplitudeSDK.defaultTracking.appLifecycles = true
            try await identifyClient(by: userId)
        }
        
        func setUserProperties(_ userProperties: Analytics.Data) async throws {
            guard let amplitudeSDK else {
                throw AmplitudeAggregator.sdkNotInitialized
            }
            amplitudeSDK.setUserProperties(userProperties)
        }
        
        func track(_ event: Analytics.Event, _ data: Analytics.Data?) async throws {
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
