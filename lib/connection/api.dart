class API {
  static const connection = "https://school-com.preview-domain.com/xevcurity";
  // static const connection = "http://192.168.100.10:80/xevcurity";  
  static const userLoginAPI = "$connection/data/user_login_data.php";
  static const userGuardAPI = "$connection/data/guard_login_data.php";
  static const adminLoginAPI = "$connection/data/admin_login_data.php";
  static const registerAPI = "$connection/data/register_data.php";
  static const insertFaqAPI = "$connection/data/insert_faq.php";
  static const register1API = "$connection/data/register_data1.php";
  static const updateUsersAPI = "$connection/data/update_user.php";
  static const deleteAllReportsAPI =
      "$connection/data/delete_all_report_data.php";
  static const deleteAllCommentAPI =
      "$connection/data/delete_all_comment_data.php";
  static const deleteEmergencyAPI =
      "$connection/data/delete_emergency_data.php";
  static const deleteHazardAPI = "$connection/data/delete_hazard_data.php";
  static const deleteLostFoundClaimSearchAPI =
      "$connection/data/delete_lost_found_claim_search.php";
  static const deleteCrimeAPI = "$connection/data/delete_crime_data.php";
  static const deleteUserAccountAPI = "$connection/data/delete_user_account.php";
  static const currentUserAPI = "$connection/data/retrieve_user_data.php";
  static const insertReportAPI = "$connection/data/insert_report.php";
  static const insertChatAPI = "$connection/data/insert_chat_data.php";
  static const insertClaimAPI = "$connection/data/insert_claim.php";
  static const insertGuardEmergencyAPI =
      "$connection/data/insert_guard_emergency.php";
  static const insertChatAdminAPI =
      "$connection/data/insert_chat_admin_data.php";
  static const updateChatAdminAPI =
      "$connection/data/update_chat_admin_data.php";
  static const insertCommentAPI = "$connection/data/insert_comment_data.php";
  static const insertNotificationToUserAPI =
      "$connection/data/send_notif_to_user.php";
  static const insertAlertAPI = "$connection/data/insert_alert.php";
  static const insertLostFoundComment =
      "$connection/data/insert_lost_found_comment.php";
  static const displayCommentAPI = "$connection/data/display_comment_data.php";
  static const displayFaqAPI = "$connection/data/display_faq_data.php";
  static const displayFaqIDAPI = "$connection/data/display_faq_data_id.php";
  static const displayReportDataAPI =
      "$connection/data/display_report_data.php";
  static const displayLostFoundClaimNotification =
      "$connection/data/display_lost_found_claimed_data_notif.php";
  static const displayLostFoundComment =
      "$connection/data/display_lost_found_comment_data.php";
  static const displayLostFoundCommentLimit =
      "$connection/data/display_lost_found_comment_data_limit.php";
  static const displayLostFoundSingleData =
      "$connection/data/display_lost_found_single_data.php";
  static const displayLostFoundAPI = "$connection/data/get_lost_found_data.php";
  static const displayMonthlyReportEmergencyAPI = "$connection/data/display_monthly_report_emergency.php";
  static const displayMonthlyReportHazardAPI = "$connection/data/display_monthly_report_hazard.php";
  static const displayMonthlyReportCrimeAPI = "$connection/data/display_monthly_report_crime.php";
  static const displayMonthlyEmergencyDataCountAPI = "$connection/data/display_monthly_report_emergency_data_count.php";
  static const displayMonthlyHazardDataCountAPI = "$connection/data/display_monthly_report_hazard_data_count.php";
  static const displayMonthlyCrimeDataCountAPI = "$connection/data/display_monthly_report_crime_data_count.php";
  static const displayGuardUserAPI = "$connection/data/display_guard_user.php";
  static const displayGuardEmergencyAPI1 = "$connection/data/display_guard_emergency1.php";
  static const displayUserSummary = "$connection/data/display_bulletin_summary.php";
  static const displayUserSummary1 = "$connection/data/display_bulletin_summary1.php";
  static const displayReportCommentDataAPI =
      "$connection/data/display_report_comment_data.php";
  static const displayChatAPI = "$connection/data/display_chat_data.php";
  static const displayLostFoundClaimed =
      "$connection/data/display_lost_found_claimed_data.php";
  static const displayLostFoundClaimed1 =
      "$connection/data/display_lost_found_claimed_data1.php";
  static const displayAllReportsAPI =
      "$connection/data/display_all_reports_data.php";
  static const displayAdminChatAPI =
      "$connection/data/display_chat_admin_data.php";
  static const displayUserLostFoundAPI =
      "$connection/data/user_lost_found_data.php";
  static const displayUserLostFoundAPI1 =
      "$connection/data/user_lost_found_data1.php";
  static const displayAlertAPI = "$connection/data/display_alert_data.php";
  static const displayAccountPendingAPI = "$connection/data/display_account_pending.php";
  static const displayGuardEmergencyAPI =
      "$connection/data/display_guard_emergency.php";
  static const displayUserBulletinNewsAPI =
      "$connection/data/user_bulletin_news_data.php";
  static const displayUserBulletinEventsAPI =
      "$connection/data/user_bulletin_event_data.php";
  static const displayUserBulletinUserReportsAPI =
      "$connection/data/user_bulletin_user_report_data.php";
  static const displayUserAllReportsAPI =
      "$connection/data/user_bulletin_user_all_report_data.php";
  static const insertDiscussionAPI =
      "$connection/data/insert_discussion_data.php";
  static const displayDiscussionAPI =
      "$connection/data/display_discussion_data.php";
  static const insertBulletinAPI = "$connection/data/insert_bulletin_data.php";
  static const insertReportCommentAPI =
      "$connection/data/insert_report_comment.php";
  static const filterBulletinAPI = "$connection/data/bulletin_filter_data.php";
  static const deleteBulletinAPI = "$connection/data/delete_bulletin_data.php";
  static const deleteLostFoundAPI = "$connection/data/delete_lost_found.php";
  static const deleteFaqAPI = "$connection/data/delete_faq.php";
  static const updateFaqAPI = "$connection/data/update_faq.php";
  static const deleteDiscussionAPI =
      "$connection/data/delete_discussion_data.php";
  static const updateNotificationAPI =
      "$connection/data/update_notification_data.php";
  static const updateAlertNotificationAPI =
      "$connection/data/update_alert_data.php";
  static const updateReceivedAdminAPI =
      "$connection/data/update_received_chat_data.php";
  static const displayEmeregencyAPI =
      "$connection/data/display_emergency_data.php";
  static const displayEmeregencyAPI1 =
      "$connection/data/display_emergency_data1.php";
  static const updateEmergencyAPI =
      "$connection/data/update_emergency_data.php";
  static const updateHazardAPI = "$connection/data/update_hazard_data.php";
  static const updateClaimSeenAPI = "$connection/data/update_claimed_seen.php";
  static const updateClaimSeenAPI1 = "$connection/data/update_claimed_seen1.php";
  static const updateEmergencySeenAPI = "$connection/data/update_emergency_seen.php";
  static const updateAlertSeenAPI = "$connection/data/update_alert_seen.php";
  static const updateGuardEmergencySeenAPI = "$connection/data/update_guard_emergency_seen.php";
  static const updateGuardEmergencyAPI1 =
      "$connection/data/update_guard_emergency1.php";
  static const updateGuardEmergencyAPI0 =
      "$connection/data/update_guard_emergency0.php";
  static const updateCrimeAPI = "$connection/data/update_crime_data.php";
  static const updateLostFoundClaim =
      "$connection/data/update_lost_found_claim.php";
  static const updateLostFoundClaim1 =
      "$connection/data/update_lost_found_claim1.php";
  static const updateLostFoundClaim0 =
      "$connection/data/update_lost_found_claim0.php";
  static const displayHazardAPI = "$connection/data/display_hazard_data.php";
  static const displayUserNotificationAPI =
      "$connection/data/display_user_notif_data.php";
  static const displayCrimeAPI = "$connection/data/display_crime_data.php";
  static const displayAdminSummaryAPI = "$connection/data/display_admin_summary.php";
  static const displayAdminAPI = "$connection/data/get_admin_data.php";
  static const displayUserAPI = "$connection/data/get_user_data.php";
  static const displayReceivedAdminAPI =
      "$connection/data/admin_received_chat_data.php";
  static const getDataAPI = "$connection/data/get_data.php";
  static const displayAllLostFoundAPI =
      "$connection/data/display_lost_found_data.php";
  static const displayLostFoundDataSearch =
      "$connection/data/display_lost_found_data_search.php";
  static const insertLostFoundAPI =
      "$connection/data/insert_lostfound_data.php";
  static const insertLostFoundAPI1 =
      "$connection/data/insert_lostfound_data1.php";
  static const updateUserProfileAPI =
      "$connection/data/update_user_profile.php";

  static getUserData(int? id) {
    return "$currentUserAPI?uid=${id.toString()}";
  }

  static updateUserData(int? id) {
    return "$updateUserProfileAPI?uid=${id.toString()}";
  }

  static deleteEmergencyData(int? id) {
    return "$deleteEmergencyAPI?rid=${id.toString()}";
  }

  static deleteHazardData(int? id) {
    return "$deleteHazardAPI?rid=${id.toString()}";
  }

  static deleteCrimeData(int? id) {
    return "$deleteCrimeAPI?rid=${id.toString()}";
  }

  static fillterBulletinData(String? filter) {
    return "$filterBulletinAPI?filter=${filter.toString()}";
  }

  static deleteBulletinData(int? id) {
    return "$deleteBulletinAPI?id=${id.toString()}";
  }

  static updateGuardEmergencyData1(int? gid) {
    return "$updateGuardEmergencyAPI1?gid=${gid.toString()}";
  }

  static updateGuardEmergencyData0(int? gid) {
    return "$updateGuardEmergencyAPI0?gid=${gid.toString()}";
  }

  static deleteLostFoundClaimSearchAPIData(int? id) {
    return "$deleteLostFoundClaimSearchAPI?id=${id.toString()}";
  }

  static displayLostFoundFilterData(String? filter) {
    return "$displayAllLostFoundAPI?search=${filter.toString()}";
  }

  static displayDiscussionData(var page) {
    return "$displayDiscussionAPI?page=${page.toString()}&limit=3";
  }

  static displayUserLostFoundAPIData(var id) {
    return "$displayUserLostFoundAPI?id=${id.toString()}";
  }

  static displayCommentData(var id) {
    return "$displayCommentAPI?id=${id.toString()}";
  }

  static displayChatData(var id, var id1) {
    return "$displayChatAPI?userID=${id.toString()}&adminID=${id1.toString()}";
  }

  static displayChatAdminData(var id, var id1) {
    return "$displayAdminChatAPI?adminID=${id.toString()}&userID=${id1.toString()}";
  }

  static displayReportCommentDataAPIData(var id) {
    return "$displayReportCommentDataAPI?id=${id.toString()}";
  }

  static displayUserNotificationData(var id, var id1) {
    return "$displayUserNotificationAPI?gid=${id.toString()}&uid=${id1.toString()}";
  }

  static displayReportDataAPIData(int id) {
    return "$displayReportDataAPI?id=${id.toString()}";
  }

  static displayLostFoundClaimNotificationData(var id) {
    return "$displayLostFoundClaimNotification?id=${id.toString()}";
  }

  static updateNotificationData(var id) {
    return "$updateNotificationAPI?id=${id.toString()}";
  }

  static updateGuardEmergencySeenData(var id) {
    return "$updateGuardEmergencySeenAPI?gid=${id.toString()}";
  }

  static updateAlertNotificationData(var id) {
    return "$updateAlertNotificationAPI?id=${id.toString()}";
  }

  static updateReceivedAdminData(var id) {
    return "$updateReceivedAdminAPI?id=${id.toString()}";
  }

  static displayReceivedAdminData(var id, var id1) {
    return "$displayReceivedAdminAPI?userID=${id.toString()}&admidID=${id1.toString()}";
  }

  static updateChatAdminData(var id) {
    return "$updateChatAdminAPI?cid=${id.toString()}";
  }

  static updateEmergencyData(var id) {
    return "$updateEmergencyAPI?id=${id.toString()}";
  }

  static updateHazardData(var id) {
    return "$updateHazardAPI?id=${id.toString()}";
  }

  static updateUsersAPIData(var id) {
    return "$updateUsersAPI?id=${id.toString()}";
  }

  static deleteLostFoundAPIData(var id) {
    return "$deleteLostFoundAPI?id=${id.toString()}";
  }

  static deleteUserAccountData(var id) {
    return "$deleteUserAccountAPI?id=${id.toString()}";
  }

  static deleteDiscussionAPIData(var id) {
    return "$deleteDiscussionAPI?id=${id.toString()}";
  }

  static deleteAllCommentAPIData(var id) {
    return "$deleteAllCommentAPI?id=${id.toString()}";
  }

  static deleteAllReportsAPIData(var id) {
    return "$deleteAllReportsAPI?id=${id.toString()}";
  }

  static updateCrimeData(var id) {
    return "$updateCrimeAPI?id=${id.toString()}";
  }

  static insertNotificationToUserData(var uid, var aid) {
    return "$insertNotificationToUserAPI?uid=${uid.toString()}&aid=${aid.toString()}";
  }

  static displayLostFoundCommentData(int id) {
    return "$displayLostFoundComment?id=${id.toString()}";
  }

  static displayLostFoundDataSearchData(var item) {
    return "$displayLostFoundDataSearch?lost_item=${item.toString()}";
  }

  static displayLostFoundData(int id) {
    return "$displayLostFoundAPI?id=${id.toString()}";
  }

  static updateLostFoundClaimData(int id) {
    return "$updateLostFoundClaim?id=${id.toString()}";
  }

  static updateLostFoundClaimData1(int id) {
    return "$updateLostFoundClaim1?id=${id.toString()}";
  }

  static updateLostFoundClaimData0(int id) {
    return "$updateLostFoundClaim0?id=${id.toString()}";
  }


  static deleteFaqData(int id) {
    return "$deleteFaqAPI?id=${id.toString()}";
  }

  // static updateFaqData(int id) {
  //   return "$updateFaqAPI?id=${id.toString()}";
  // }

  static displayFaqIDData(int id) {
    return "$displayFaqIDAPI?id=${id.toString()}";
  }

  static displayAdminSummaryData(DateTime? firstDate, DateTime? lastDate) {
    return "$displayAdminSummaryAPI?first_date=$firstDate&last_date=$lastDate";
  }

  
  static displayLostFoundSingleDataRecord(var lfid) {
    return "$displayLostFoundSingleData?id=${lfid.toString()}";
  }
}

class ImagesAPI {
  static const basedURL =
      "https://school-com.preview-domain.com/xevcurity/upload";
  // static const basedURL = "http://192.168.100.10:80/xevcurity/upload";
  static const images = "$basedURL/images";
  static const profile = "$basedURL/profile";
  static const videos = "$basedURL/videos";

  static getImagesUrl(var image_) {
    return "$images/$image_";
  }

  static getProfileUrl(var profile_) {
    return "$profile/$profile_";
  }

  static getVideosUrl(var videos_) {
    return "$videos/$videos_";
  }
}
