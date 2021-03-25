import 'dart:async';

import 'package:nakoda_group/models/user.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

  // http://localhost/JainProject/admin/DashboardController/index

  static final BASE_URL = "http://www.michannel.in/demo/nakoda/admin/API/";
  static final Sponser_IMAGE_URL = "http://www.michannel.in/demo/nakoda/uploads/sponser/";
  static final Achievement_IMAGE_URL = "http://www.michannel.in/demo/nakoda/uploads/achivments/";
  static final Committee_IMAGE_URL = "http://www.michannel.in/demo/nakoda/uploads/membership/";
  static final NEWS_URL = "http://www.michannel.in/demo/nakoda/uploads/news/";
  static final AUDIO_URL = "http://www.michannel.in/demo/nakoda/uploads/audio/";
  static final IMAGE_URL = "http://www.michannel.in/demo/nakoda/uploads/gallery/";


  static final LOGIN_URL = BASE_URL + "login";
  static final OTP_URL = BASE_URL + "checkloginotp";

  static final GET_DASHBOARD_SPONSER = BASE_URL + "getDashboardsponsers";
  static final GET_SPONSER = BASE_URL + "getsponsers";
  static final GET_DASHBOARD = BASE_URL + "getdashboard.php";


  static final URL_FAMILY_LIST = BASE_URL + "getFamilyMembers";
  static final URL_GAUTRA_LIST = BASE_URL + "getGautra";
  static final URL_EDUCATION_LIST = BASE_URL + "getEducation";
  static final URL_NATIVE_PLACE_LIST = BASE_URL + "getNativePlaces";
  static final URL_PROFESSION_LIST = BASE_URL + "getProfessions";
  static final URL_STATE_LIST = BASE_URL + "getState";
  static final URL_CITY_LIST = BASE_URL + "getCity";
  static final URL_ADD_FAMILY = BASE_URL + "AddFamily";
  static final URL_EDIT_FAMILY = BASE_URL + "EditFamily";
  static final URL_DELETE_FAMILY = BASE_URL + "deleteSubMember";

  static final URL_USER_DETAILS = BASE_URL + "getLoggedInmember";

  static final URL_MEMBER_LIST = BASE_URL + "getMembers";
  static final GET_MEMBER_FILTER = BASE_URL + "memberfilter";


  static final URL_ACHIEVEMENT_LIST = BASE_URL + "getAchivments";
  static final URL_COMMITTE_LIST = BASE_URL + "getCommitee";
  static final URL_TRUSTEE_LIST = BASE_URL + "getTrustree";
  static final GET_NOTIFICATION_URL = BASE_URL + "getNewsEvents";

  static final GET_NEWS_URL = BASE_URL + "getNewsEvents";

  static final GET_JOBS_URL = BASE_URL + "getJobs";
  static final GET_I_NEED_JOB_URL = BASE_URL + "addjobSeeker";
  static final GET_I_HAVE_JOB_URL = BASE_URL + "addjob";

  static final GET_BIRTHDAY_URL = BASE_URL + "getTodayBirthday";
  static final GET_SAMAJRATNA_URL = BASE_URL + "getSamajRatna";

  static final URL_GET_CATEGORY_TYPE = BASE_URL + "getCatTypeData";
  static final URL_GET_AUDIO = BASE_URL + "getCatAudio";
  static final URL_GET_PHOTO = BASE_URL + "getCatImage";
  static final URL_GET_VIDEO = BASE_URL + "getCatVideo";

  static final URL_GET_ABOUT = BASE_URL + "getAbout";

  static final URL_CHANGE_PASSWORD = "";
  static final RESEND_OTP_URL = "";
  static final VERIFY_CONTACT = "";
  static final VERIFY_USER = "";
  static final RESET_PASSWORD = "";

  Future<User> login(String mobile) {
    return _netUtil.post(OTP_URL, body: {
      "mobile": mobile,
    }).then((dynamic res) async {
      print(res);
      if (res["loggedin"] == 0) throw new Exception(res["message"]);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("MembershipId", res["data"]["data"]["MembershipId"]);
      prefs.setString("FirstName", res["data"]["data"]["FirstName"]);
      prefs.setString("MiddleName", res["data"]["data"]["MiddleName"]);
      prefs.setString("LastGautra", res["data"]["data"]["LastGautra"]);
      prefs.setString("Mobile1", res["data"]["data"]["Mobile1"]);
      prefs.setString("AniversaryDate", res["data"]["data"]["AniversaryDate"]);
      return new User.map(res["data"]["data"]);
    });
  }
}
