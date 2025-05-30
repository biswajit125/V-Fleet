//
//  UIStoryboard+Loader.swift
//  HubBusiness
//
//  Created by yapapp on 12/27/19.
//  Copyright © 2019 yapapp.com. All rights reserved.
//

import UIKit

fileprivate enum Storyboards: String {
    case authentication = "Authentication"
    case home = "Home"
    case vipSignup = "VipSignup"
    case othersProfile = "OthersProfile"
    case common = "Common"
    case createPost = "CreatePost"
    case notifications = "Notifications"
    case messages = "Messages"
    case myProfile = "MyProfile"
    case helpAndSupport = "HelpAndSupport"
    case banking = "Banking"
    case settings = "Settings"
    case postAndUserActions = "PostAndUserActions"
}

fileprivate extension UIStoryboard {
    
    static func loadFromAuthenticationStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.authentication.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromHomeStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.home.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromVipSignupStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.vipSignup.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromOthersProfileStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.othersProfile.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromCommonStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.common.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromCreatePostStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.createPost.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromNotificationsStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.notifications.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromMessagesStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.messages.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromMyProfileStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.myProfile.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromHelpAndSupportStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.helpAndSupport.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromBankingStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.banking.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromSettingsStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    static func loadFromPostAndUserActionsStoryboard(_ identifier: String) -> UIViewController {
        let loginStoryboard = UIStoryboard(name: Storyboards.postAndUserActions.rawValue, bundle: nil)
        let vc = loginStoryboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
}

// MARK: - LOAD FROM LOGIN STORYBOARD
//extension UIStoryboard {
//    static func loadWelcomeVC() -> WelcomeVC {
//        return loadFromAuthenticationStoryboard("WelcomeVC") as! WelcomeVC
//    }
//
//    static func loadUserTypeVC() -> UserTypeVC {
//        return loadFromAuthenticationStoryboard("UserTypeVC") as! UserTypeVC
//    }
//
//    static func loadCustomerSignupVC() -> CustomerSignupVC {
//        return loadFromAuthenticationStoryboard("CustomerSignupVC") as! CustomerSignupVC
//    }
//
//    static func loadLoginVC() -> LoginVC {
//        return loadFromAuthenticationStoryboard("LoginVC") as! LoginVC
//    }
//
//    static func loadForgotPasswordVC() -> ForgotPasswordVC {
//        return loadFromAuthenticationStoryboard("ForgotPasswordVC") as! ForgotPasswordVC
//    }
//
//    static func loadCustomPopupVC() -> CustomPopupVC {
//        return loadFromAuthenticationStoryboard("CustomPopupVC") as! CustomPopupVC
//    }
//}

// MARK: - LOAD FROM HOME STORYBOARD
//extension UIStoryboard {
//    static func loadHomeVC() -> HomeVC {
//        return loadFromHomeStoryboard("HomeVC") as! HomeVC
//    }
//}

// MARK: - LOAD FROM VIP SIGNUP STORYBOARD
//extension UIStoryboard {
//    static func loadVipSignupContainerVC() -> VipSignupContainerVC {
//        return loadFromVipSignupStoryboard("VipSignupContainerVC") as! VipSignupContainerVC
//    }
//
//    static func loadVipPersonalDetailVC() -> VipPersonalDetailVC {
//        return loadFromVipSignupStoryboard("VipPersonalDetailVC") as! VipPersonalDetailVC
//    }
//
//    static func loadVipIdentityInfoVC() -> VipIdentityInfoVC {
//        return loadFromVipSignupStoryboard("VipIdentityInfoVC") as! VipIdentityInfoVC
//    }
//
//    static func loadVipProfileDetialVC() -> VipProfileDetialVC {
//        return loadFromVipSignupStoryboard("VipProfileDetialVC") as! VipProfileDetialVC
//    }
//
//    static func loadVipPaymentInfoVC() -> VipPaymentInfoVC {
//        return loadFromVipSignupStoryboard("VipPaymentInfoVC") as! VipPaymentInfoVC
//    }
//}

// MARK: - LOAD FROM OTHERS PROFILE STORYBOARD
//extension UIStoryboard {
//    static func loadOthersProfileVC() -> OthersProfileVC {
//        return loadFromOthersProfileStoryboard("OthersProfileVC") as! OthersProfileVC
//    }
//
//    static func loadPostsVC() -> PostsVC {
//        return loadFromOthersProfileStoryboard("PostsVC") as! PostsVC
//    }
//
//    static func loadPhotosVC() -> PhotosVC {
//        return loadFromOthersProfileStoryboard("PhotosVC") as! PhotosVC
//    }
//}

// MARK: - LOAD FROM COMMON STORYBOARD
//extension UIStoryboard {
//    static func loadViewPhotosVC() -> ViewPhotosVC {
//        return loadFromCommonStoryboard("ViewPhotosVC") as! ViewPhotosVC
//    }
//
//    static func loadTabBarVC() -> TabBarVC {
//        return loadFromCommonStoryboard("TabBarVC") as! TabBarVC
//    }
//
//    static func loadMenuVC() -> MenuVC {
//        return loadFromCommonStoryboard("MenuVC") as! MenuVC
//    }
//
//    static func loadSendTipVC() -> SendTipVC {
//        return loadFromCommonStoryboard("SendTipVC") as! SendTipVC
//    }
//
//    static func loadBookmarksVC() -> BookmarksVC {
//        return loadFromCommonStoryboard("BookmarksVC") as! BookmarksVC
//    }
//}

// MARK: - LOAD FROM CREATE POST STORYBOARD
//extension UIStoryboard {
//    static func loadCreatePostVC() -> CreatePostVC {
//        return loadFromCreatePostStoryboard("CreatePostVC") as! CreatePostVC
//    }
//}

// MARK: - LOAD FROM NOTIFICATIONS STORYBOARD
//extension UIStoryboard {
//    static func loadNotificationsVC() -> NotificationsVC {
//        return loadFromNotificationsStoryboard("NotificationsVC") as! NotificationsVC
//    }
//}

// MARK: - LOAD FROM MESSAGES STORYBOARD
//extension UIStoryboard {
//    static func loadChatDialogsVC() -> ChatDialogsVC {
//        return loadFromMessagesStoryboard("ChatDialogsVC") as! ChatDialogsVC
//    }
//
//    static func loadChatVC() -> ChatVC {
//        return loadFromMessagesStoryboard("ChatVC") as! ChatVC
//    }
//}

// MARK: - LOAD FROM MY PROFILE STORYBOARD
//extension UIStoryboard {
//    static func loadFansVC() -> FansVC {
//        return loadFromMyProfileStoryboard("FansVC") as! FansVC
//    }
//
//    static func loadFollowingVC() -> FollowingVC {
//        return loadFromMyProfileStoryboard("FollowingVC") as! FollowingVC
//    }
//
//    static func loadOptionsPopupVC() -> OptionsPopupVC {
//        return loadFromMyProfileStoryboard("OptionsPopupVC") as! OptionsPopupVC
//    }
//
//    static func loadMyProfileVC() -> MyProfileVC {
//        return loadFromMyProfileStoryboard("MyProfileVC") as! MyProfileVC
//    }
//
//    static func loadEditProfileVC() -> EditProfileVC {
//        return loadFromMyProfileStoryboard("EditProfileVC") as! EditProfileVC
//    }
//}

// MARK: - LOAD FROM MY PROFILE STORYBOARD
//extension UIStoryboard {
//    static func loadHelpAndSupportVC() -> HelpAndSupportVC {
//        return loadFromHelpAndSupportStoryboard("HelpAndSupportVC") as! HelpAndSupportVC
//    }
//}

// MARK: - LOAD FROM BANKING STORYBOARD
//extension UIStoryboard {
//    static func loadAddBankVC() -> AddBankVC {
//        return loadFromBankingStoryboard("AddBankVC") as! AddBankVC
//    }
//
//    static func loadAddCardsVC() -> CardsVC {
//        return loadFromBankingStoryboard("CardsVC") as! CardsVC
//    }
//}

// MARK: - LOAD FROM SETTINGS STORYBOARD
//extension UIStoryboard {
//    static func loadSettingsVC() -> SettingsVC {
//        return loadFromSettingsStoryboard("SettingsVC") as! SettingsVC
//    }
//}

// MARK: - LOAD FROM POST AND USER ACCTIONS STORYBOARD
//extension UIStoryboard {
//    static func loadCommentsVC() -> CommentsVC {
//        return loadFromPostAndUserActionsStoryboard("CommentsVC") as! CommentsVC
//    }
//    
//    static func loadLikesListingVC() -> LikesListingVC {
//        return loadFromPostAndUserActionsStoryboard("LikesListingVC") as! LikesListingVC
//    }
//    
//    static func loadSearchUserVC() -> SearchUserVC {
//        return loadFromPostAndUserActionsStoryboard("SearchUserVC") as! SearchUserVC
//    }
//    
//    static func loadReportVC() -> ReportVC {
//        return loadFromPostAndUserActionsStoryboard("ReportVC") as! ReportVC
//    }
//    
//    static func loadBlockedUsersVC() -> BlockedUsersVC {
//        return loadFromPostAndUserActionsStoryboard("BlockedUsersVC") as! BlockedUsersVC
//    }
//}
