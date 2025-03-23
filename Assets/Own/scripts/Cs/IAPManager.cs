using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Purchasing;

public class IAPManager : MonoBehaviour, IStoreListener
{
    public static IAPManager Instance;
    public class InitializeBuilder
    {
        public string id;
        public ProductType productType;
    }
    private IStoreController _storeController;
    public Action<PurchaseEventArgs> _onSuccess;
    public Action<Product, PurchaseFailureReason> _onFail;
    private void Awake()
    {
        Instance = this;
    }

    public void Initialize(List<InitializeBuilder> initializeBuilders)
    {
        if(_storeController == null)
        {
            var builder = ConfigurationBuilder.Instance(StandardPurchasingModule.Instance());
            foreach(var init in initializeBuilders)
            {
                builder.AddProduct(init.id, init.productType);
            }
            UnityPurchasing.Initialize(this, builder);
        }
    }

    public void OnInitialized(IStoreController controller, IExtensionProvider extensions)
    {
        Debug.Log("IAP Initialized Success");
        _storeController = controller;
    }

    public void InitiatePurchase(string productId)
    {
        _storeController.InitiatePurchase(productId);
    }

    public PurchaseProcessingResult ProcessPurchase(PurchaseEventArgs purchaseEvent)
    {
        _onSuccess?.Invoke(purchaseEvent);
        return PurchaseProcessingResult.Complete;
    }

    public void OnPurchaseFailed(Product product, PurchaseFailureReason failureReason)
    {
        _onFail?.Invoke(product, failureReason);        
    }

    public void OnInitializeFailed(InitializationFailureReason error)
    {
        Debug.LogError("IAP Initialized Failed" + error);
    }

    public void OnInitializeFailed(InitializationFailureReason error, string message)
    {
        Debug.LogError("IAP Initialized Failed" + error + message);
    }

    public string GetPrice(string productId)
    {
        if (_storeController != null)
        {
            Product product = _storeController.products.WithID(productId);
            if (product != null && product.availableToPurchase)
            {
                return product.metadata.localizedPriceString;
            }
        }

        return "N/A";
    }
}
