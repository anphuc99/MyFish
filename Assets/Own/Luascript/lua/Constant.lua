Lib.CheckGlobal("Constant")

Constant = {
    MAX_AQUARIUM = 3,
    PoppupID = {
        Popup_Bag = "Popup_Bag",
        Popup_BuyFish = "Popup_BuyFish",
        Popup_Notification = "Popup_Notification",
        Popup_Shop = "Popup_Shop",
        Popup_YesNoSimple = "Popup_YesNoSimple",
        Popup_YesNoSimple_ForSellFish = "Popup_sellfish",
        Popup_setting = "Popup_setting",
        Popup_inform_normal = "Popup_InformNormal",
        Popup_Email = "Popup_Mail",
        Popup_EmailDetail = "Popup_MailDetail",
        Popup_LevelUp = "Popup_LevelUp",
        Popup_Chat = "Popup_Chat",
        Popup_Toat = "Popup_Toat",
        Popup_createUser = "Popup_createUser",
        Popup_dialog = "Popup_dialog",
        Popup_Breed = "Popup_Breed",
        Popup_Reward = "Popup_Reward",
        Popup_profile = "Popup_profile",
        Popup_Purchase_GPoint = "Popup_Purchase_GPoint",
        Popup_InfoFriend = "Popup_InfoFriend",
        Popup_ExchangeDiamond = "Popup_ExchangeDiamond",
        Popup_ExchangeGold = "Popup_ExchangeGold",
        Popup_BagFriend = "Popup_BagFriend",
        Popup_BuyAmount = "Popup_BuyAmount",
        Popup_Ranking = "Popup_Ranking",
        Popup_Quests = "Popup_Quests"
    },
    Scene = {
        Login = "Login",
        GamePlay = "GamePlay",
        CreateUser = "CreateUser",
        FriendZone = "FriendZone"
    },
    Data = {
        sound = "sound",
        volume = "volume",
        curAquarium = "curAquarium"
    },
    Firebase = {

    },

    Event = {
        OnAddBagItem = "OnAddBagItem",
        OnSubtractBagItem = "OnSubtractBagItem",
        DataOnChangeBagItem = "DataOnChangeBagItem",
        OnAddDecorItem = "OnAddDecorItem",
        OnSubtractDecorItem = "OnSubtractDecorItem",
        FeedFish = "FeedFish",
        AddFish = "AddFish",
        UpdateNotify = "UpdateNotify",
        CurrencyCoin = "currency_coin",
        CurrencyEnergy="energy_lastUpdate",
        CurrencyPoint = "currency_point",
        CurrencyDiamond = "currency_diamond",
        LvLevel = "lv_level",
        LvExp = "lv_exp",
        Avatar = "avatar",
        ReceiveMail = "ReceiveMail",
        OnBuyFish = "OnBuyFish",
        OnBuyDecoration = "OnBuyDecoration",
        OnBuyStall = "OnBuyStall",
        OnChangeVolume = "OnChangeVolume",
        OnChangeAquarium = "OnChangeAquarium",
        OnServerSendChat = "OnServerSendChat",
        FishOnFull = "FishOnFull",
        OnVisitFriend = "OnVisitFriend",
        UpdateFishCount = "UpdateFishCount",
        OnOutFriendZone = "OutFriendZone",
        UpdateFriend = "UpdateFriend",
        ServerChangePlayer = "ServerChangePlayer",
        PLAYER_ONLINE = "PLAYER_ONLINE",
        OnSetBuyAmount = "OnSetBuyAmount",
        SellAdultFish = "SellAdultFish"
    },

    VisualScriptingEvent = {
        OnSelectFishBreed = "OnSelectFishBreed"
    },

    Request = {
        Pos = {
            ZoneFishLeft = "ZoneFishLeft",
            ZoneFishRight = "ZoneFishRight"
        },
        DataChat = "DataChat",
        Canvas = "Canvas"
    },

    SoundEffect = {
        Button = "Button",
        CollectPoints = "CollectPoints",
        LevelUp = "LevelUp",
        Gift = "Gift"
    },
    Energy = {
        Energy1 = 142000,
        Energy2 = 142001,
    },
    Food = {
        Food1 = 141000,
        Food2 = 141001,
    },
    Chat = {
        Chanel = {
            [1] = "Kênh thế giới"
        }
    },

    StallType = {
        Food = 1,
        Energy = 2,
        MarterialBreed = 3,
        BreedFish = 11
    },

    Currency = {
        Gold = "100001",
        Diomond = "100002",
        Coin = "100003",
        Exp = "100004"
    },

    Exchange = {
        Diamond = "diamond",
        Coin = "coin"
    },
    
    StateManchine = {
        Trigger = {
            OnFull = "OnFull",
            OnOutOfFood = "OnOutOfFood",
            OnAte = "OnAte",
            OnNormal = "OnNormal",
            OnThinking = "OnThinking",
            OnAdult = "OnAdult",
            OnClickFish = "OnClickFish",
            OnSwin = "OnSwin",
            Show = "Show",
            Hide = "Hide",
            Next = "Next"
        },

        Bool = {
            OnFeed = "OnFeed", 
            OnHungry = "OnHungry"
        }
    },

    Gender = {
        Male = 1,
        Female = 2
    },
    IAP = {
        GPoint20K = "com.devmini.myfish.gpoint20k",
        GPoint50K = "com.devmini.myfish.gpoint50k",
        GPoint100K = "com.devmini.myfish.gpoint100k",
        GPoint200K = "com.devmini.myfish.gpoint200k",
        GPoint500K = "com.devmini.myfish.gpoint500k",
    },

    FriendStatus = {
        Online = "ONLINE",
        Offline = "OFFLINE",
        Pending = "pending",
        Accepted = "accepted",
        Declined = "declined",
        Blocked= "blocked",
    },
    Ranking = {
        Level = "Level",
        Coin = "Coin",
        Point = "Point",
        FishOpen = "FishOpen"
    }
}
