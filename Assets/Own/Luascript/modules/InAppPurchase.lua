ProductType = {
    Consumable = 0,
    NonConsumable = 1,
    Subscription = 2,
}
---@class PurchaseFailureReason
PurchaseFailureReason = {
    -- Purchasing may be disabled in security settings.
    PurchasingUnavailable = 1,

    -- Another purchase is already in progress.
    ExistingPurchasePending = 2,

    -- The product was reported unavailable by the purchasing system.
    ProductUnavailable = 3,

    -- Signature validation of the purchase's receipt failed.
    SignatureInvalid = 4,

    -- The user opted to cancel rather than proceed with the purchase.
    -- This is not specified on platforms that do not distinguish
    -- cancellation from other failure (Amazon, Microsoft).
    UserCancelled = 5,

    -- There was a problem with the payment.
    -- This is unique to Apple platforms.
    PaymentDeclined = 6,

    -- The transaction has already been completed successfully. This error can occur
    -- on Apple platforms if the transaction is finished successfully while the user
    -- is logged out of the app store, using a receipt generated while the user was
    -- logged in.
    DuplicateTransaction = 7,

    -- A catch all for remaining purchase problems.
    -- Note: Use Enum.Parse to use this named constant if targeting Unity 5.3
    -- or 5.4. Its value differs for 5.5+ which introduced DuplicateTransaction.
    Unknown = 8
}

InAppPurchase = {}

function InAppPurchase:Initialize(table)
    APIInAppPurchase.Initialize(table)
end


function InAppPurchase:InitiatePurchase(productId, callbackSuccess, callbackFail)
    APIInAppPurchase.InitiatePurchase(productId, callbackSuccess, callbackFail)
end


---@class IAPPurchase
---@field productId string
---@field receipt string
---@field failureReason PurchaseFailureReason