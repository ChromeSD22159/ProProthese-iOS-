//
// StopProthesenTimerIntent.swift
//
// This file was automatically generated and should not be edited.
//

#if canImport(Intents)

import Intents

@available(iOS 12.0, macOS 11.0, watchOS 5.0, *) @available(tvOS, unavailable)
@objc(StopProthesenTimerIntent)
public class StopProthesenTimerIntent: INIntent {

}

/*!
 @abstract Protocol to declare support for handling a StopProthesenTimerIntent. By implementing this protocol, a class can provide logic for resolving, confirming and handling the intent.
 @discussion The minimum requirement for an implementing class is that it should be able to handle the intent. The confirmation method is optional. The handling method is always called last, after confirming the intent.
 */
@available(iOS 12.0, macOS 11.0, watchOS 5.0, *) @available(tvOS, unavailable)
@objc(StopProthesenTimerIntentHandling)
public protocol StopProthesenTimerIntentHandling: NSObjectProtocol {

    @available(*, renamed: "handle(intent:)")
    @objc(handleStopProthesenTimer:completion:)
    func handle(intent: StopProthesenTimerIntent, completion: @escaping (StopProthesenTimerIntentResponse) -> Swift.Void)
    
    /*!
     @abstract Handling method - Execute the task represented by the StopProthesenTimerIntent that's passed in
     @discussion Called to actually execute the intent. The app must return a response for this intent.

     @param  intent The input intent
     @param  completion The response handling block takes a StopProthesenTimerIntentResponse containing the details of the result of having executed the intent

     @see  StopProthesenTimerIntentResponse
     */
    @available(iOS 13.0, macOS 11.0, watchOS 6.0, *)
    @objc(handleStopProthesenTimer:completion:)
    func handle(intent: StopProthesenTimerIntent) async -> StopProthesenTimerIntentResponse

    @available(*, renamed: "confirm(intent:)")
    @objc(confirmStopProthesenTimer:completion:)
    optional func confirm(intent: StopProthesenTimerIntent, completion: @escaping (StopProthesenTimerIntentResponse) -> Swift.Void)

    /*!
     @abstract Confirmation method - Validate that this intent is ready for the next step (i.e. handling)
     @discussion Called prior to asking the app to handle the intent. The app should return a response object that contains additional information about the intent, which may be relevant for the system to show the user prior to handling. If unimplemented, the system will assume the intent is valid, and will assume there is no additional information relevant to this intent.

     @param  intent The input intent
     @param  completion The response block contains a StopProthesenTimerIntentResponse containing additional details about the intent that may be relevant for the system to show the user prior to handling.

     @see StopProthesenTimerIntentResponse
     */
    @available(iOS 13.0, macOS 11.0, watchOS 6.0, *)
    @objc(confirmStopProthesenTimer:completion:)
    optional func confirm(intent: StopProthesenTimerIntent) async -> StopProthesenTimerIntentResponse

}

/*!
 @abstract Constants indicating the state of the response.
 */
@available(iOS 12.0, macOS 11.0, watchOS 5.0, *) @available(tvOS, unavailable)
@objc public enum StopProthesenTimerIntentResponseCode: Int {
    case unspecified = 0
    case ready
    case continueInApp
    case inProgress
    case success
    case failure
    case failureRequiringAppLaunch
}

@available(iOS 12.0, macOS 11.0, watchOS 5.0, *) @available(tvOS, unavailable)
@objc(StopProthesenTimerIntentResponse)
public class StopProthesenTimerIntentResponse: INIntentResponse {

    /*!
     @abstract The response code indicating your success or failure in confirming or handling the intent.
     */
    @objc public fileprivate(set) var code: StopProthesenTimerIntentResponseCode = .unspecified

    /*!
     @abstract Initializes the response object with the specified code and user activity object.
     @discussion The app extension has the option of capturing its private state as an NSUserActivity and returning it as the 'currentActivity'. If the app is launched, an NSUserActivity will be passed in with the private state. The NSUserActivity may also be used to query the app's UI extension (if provided) for a view controller representing the current intent handling state. In the case of app launch, the NSUserActivity will have its activityType set to the name of the intent. This intent object will also be available in the NSUserActivity.interaction property.

     @param  code The response code indicating your success or failure in confirming or handling the intent.
     @param  userActivity The user activity object to use when launching your app. Provide an object if you want to add information that is specific to your app. If you specify nil, the system automatically creates a user activity object for you, sets its type to the class name of the intent being handled, and fills it with an INInteraction object containing the intent and your response.
     */
    @objc(initWithCode:userActivity:)
    public convenience init(code: StopProthesenTimerIntentResponseCode, userActivity: NSUserActivity?) {
        self.init()
        self.code = code
        self.userActivity = userActivity
    }

}

#endif