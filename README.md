# Introduction

Cyberpay provides you with the most convenient and fastest process of making and collecting payments from your customers all over the world

# About the SDK

The mobile SDK will serve as an easy to use library to quickly integrate Cyberpay to your mobile application.

The will serve as a wrapper on the existing Cyberpay web services and create a mobile entry point for making both Card and Bank transactions.

The SDK will provide custom views/layouts for checkout, pin, otp, sucured3d as well as handles all business logics taking the bulk of the job and exposing just three call backs representing the status of the transaction.

The SDK introduces a nice error wrapper class on the primary network component, introducing a painless and detailed error messages.

The SDK is designed and written in Kotlin, using the singleton pattern so only one instance is available throughout the life of the application.

## Releases

We recommend that you install the Cyberpay SDK using the Cocoapods package manager.

## Requirements

The Cyberpay iOS SDK is compatible with iOS Apps supporting iOS 10 and above.

## Getting Started

### Install and Configure the SDK using Cocoapods

1. If you haven't already, install the latest version of CocoaPods
2. Add this line to your podfile
   `pod 'cyberpay'`

3. Run the following command in your terminal after navigating to your project directory.
   `pod install`

4. Ensure you use the **.xcworkspace** file to open your project in Xcode instead of **.xcodeproj**.

### Using our Drop-In UI

**Step 1**: Import the cyberpay sdk

    ```swift
        import cyberpay
    ```

**Step 2**: Complete integration with Our Drop-In UI

```swift
         CyberpaySdk.shared.initialise(with: CYBERPAY_INTEGRATION_KEY, mode: .Debug)
           .setTransaction(forCustomerEmail: CUSTOMER_EMAIL, amountInKobo: CUSTOMER_AMOUNT_IN_KOBO)
           .dropInCheckout(rootController: self, onSuccess: {result in
                //Transaction was successful
                print(result.reference)

           }, onError: { (result, error) in
              //Transaction failed, returns an error
               print(error)

           }, onValidate: {result in
                //Not Needed
           })
```

**Note** : Ensure when going live, you change from `.Debug` to `.Live`, and also change the _integration key_. This key can be gotten from the merchant dashboard on the cyberpay merchant portal
