using MoonSharp.Interpreter;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Purchasing;

[MoonSharpUserData]
public class APIInAppPurchase
{
    public static Dictionary<string, DynValue> callBackSuccess = new Dictionary<string, DynValue>();
    public static Dictionary<string, DynValue> callBackFail = new Dictionary<string, DynValue>();
    public static void Initialize(Table table)
    {
        List<IAPManager.InitializeBuilder> initializeBuilders = new List<IAPManager.InitializeBuilder>();
        foreach(var t in table.Pairs)
        {
            initializeBuilders.Add(new IAPManager.InitializeBuilder()
            {
                id = t.Key.String,
                productType = (ProductType)t.Value.Number,
            });
        }
        IAPManager.Instance.Initialize(initializeBuilders);
    }

    public static void InitiatePurchase(string productId, DynValue callbackSuccess, DynValue callbackFail)
    {
        if(callbackSuccess != null && callbackSuccess.Type == DataType.Function)
        {
            callBackSuccess[productId] = callbackSuccess;
        }

        if(callbackFail != null && callbackFail.Type == DataType.Function)
        {
            callBackFail[productId] = callbackFail;
        }
        IAPManager.Instance._onSuccess -= ProcessPurchase;
        IAPManager.Instance._onSuccess += ProcessPurchase;
        IAPManager.Instance._onFail -= OnPurchaseFailed;
        IAPManager.Instance._onFail += OnPurchaseFailed;

        IAPManager.Instance.InitiatePurchase(productId);
    }

    private static void ProcessPurchase(PurchaseEventArgs purchaseEvent)
    {
        string productId = purchaseEvent.purchasedProduct.definition.id;
        string receipt = purchaseEvent.purchasedProduct.receipt;
        if(callBackSuccess.ContainsKey(productId))
        {
            DynValue callbackSuccess = callBackSuccess[productId];
            Table t = LuaCore.CreateTable();
            t.Set("productId", DynValue.NewString(productId));
            t.Set("receipt", DynValue.NewString(receipt));
            callbackSuccess.Function.CallFunction(t);
        }
        callBackFail.Remove(productId);
        callBackSuccess.Remove(productId);
    }

    private static void OnPurchaseFailed(Product product, PurchaseFailureReason failureReason)
    {
        string productId = product.definition.id;
        if (callBackFail.ContainsKey(productId))
        {
            DynValue callbackFail = callBackFail[productId];
            Table t = LuaCore.CreateTable();
            t.Set("productId", DynValue.NewString(productId));
            t.Set("failureReason", DynValue.NewNumber(Convert.ToInt32(failureReason)));
            callbackFail.Function.CallFunction(t);
        }
        callBackFail.Remove(productId);
        callBackSuccess.Remove(productId);
    }

    public static string GetPrice(string productId)
    {
        return IAPManager.Instance.GetPrice(productId);
    }
}
