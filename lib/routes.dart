import 'package:flutter/material.dart';
import 'package:nakoda_group/screens/about/about_screen.dart';
import 'package:nakoda_group/screens/achievement/achievement_detail_screen.dart';
import 'package:nakoda_group/screens/achievement/achievement_screen.dart';
import 'package:nakoda_group/screens/birthday/birthday_screen.dart';
import 'package:nakoda_group/screens/committee/committe_screen.dart';
import 'package:nakoda_group/screens/family/add_family_screen.dart';
import 'package:nakoda_group/screens/family/edit_family_screen.dart';
import 'package:nakoda_group/screens/family/family_details_screen.dart';
import 'package:nakoda_group/screens/family/my_family_screen.dart';
import 'package:nakoda_group/screens/home/home_screen.dart';
import 'package:nakoda_group/screens/jobs/job_category.dart';
import 'package:nakoda_group/screens/jobs/job_details_screen.dart';
import 'package:nakoda_group/screens/jobs/jobs_screen.dart';
import 'package:nakoda_group/screens/login/login_screen.dart';
import 'package:nakoda_group/screens/login/otp.dart';
import 'package:nakoda_group/screens/members/advance_search_member.dart';
import 'package:nakoda_group/screens/members/memberdetails_screen.dart';
import 'package:nakoda_group/screens/members/memberlist_screen.dart';
import 'package:nakoda_group/screens/myprofile/profile_screen.dart';
import 'package:nakoda_group/screens/news/news_screen.dart';
import 'package:nakoda_group/screens/news/newsdetails_screen.dart';
import 'package:nakoda_group/screens/notification/notificationlistscreen.dart';
import 'package:nakoda_group/screens/photo_video_audio/audio_category.dart';
import 'package:nakoda_group/screens/photo_video_audio/audio_details_screen.dart';
import 'package:nakoda_group/screens/photo_video_audio/audio_screen.dart';
import 'package:nakoda_group/screens/photo_video_audio/photo_category.dart';
import 'package:nakoda_group/screens/photo_video_audio/photo_details_screen.dart';
import 'package:nakoda_group/screens/photo_video_audio/photo_screen.dart';
import 'package:nakoda_group/screens/photo_video_audio/video_category.dart';
import 'package:nakoda_group/screens/photo_video_audio/video_screen.dart';
import 'package:nakoda_group/screens/samajratna/samajdetails.dart';
import 'package:nakoda_group/screens/samajratna/samajratnascreen.dart';
import 'package:nakoda_group/screens/sponser/sponser_screen.dart';
import 'package:nakoda_group/screens/trustee/trustee_screen.dart';

import 'main.dart';

final routes = {
  '/': (BuildContext context) => new SplashScreen(),
  '/sponserScreen': (BuildContext context) => new SponserScreen(),
  '/login': (BuildContext context) => new LoginScreen(),
  '/otp': (BuildContext context) => new OtpVerificationScreen(),
  '/home': (BuildContext context) => new HomeScreen(),
  // '/myfamily': (BuildContext context) => new MyFamilyScreen(),
  '/myfamilydetails': (BuildContext context) => new FamilyDetailScreen(),
  '/addfamily': (BuildContext context) => new AddFamilyScreen(),
  '/editfamily': (BuildContext context) => new EditFamilyScreen(),
  '/birthday': (BuildContext context) => new BirthdayScreen(),
  '/achievement': (BuildContext context) => new AchievementScreen(),
  '/achievementdetails': (BuildContext context) =>
      new AchievementDetailScreen(),
  '/myprofile': (BuildContext context) => new MyProfileScreen(),
  '/members': (BuildContext context) => new MemberListScreen(),
  '/memberdetails': (BuildContext context) => new MemberDetailScreen(),
  '/advancesearchmembers': (BuildContext context) => new AdvanceSearchMember(),
  '/notifications': (BuildContext context) => new NotificationListScreen(),
  '/news': (BuildContext context) => new NewsListScreen(),
  '/jobs': (BuildContext context) => new JobsListScreen(),
  '/jobdetails': (BuildContext context) => new JobDetailScreen(),
  '/jobcategory': (BuildContext context) => new JobCategory(),
  '/trustee': (BuildContext context) => new TrusteeListScreen(),
  '/committee': (BuildContext context) => new CommitteeListScreen(),
  '/newsdetails': (BuildContext context) => new NewsDetailScreen(),
  '/samajratna': (BuildContext context) => new SamajRatnaScreen(),
  '/samajratnadetails': (BuildContext context) => new SamajDetailScreen(),
  '/photocategory': (BuildContext context) => new PhotoCategory(),
  '/photo': (BuildContext context) => new PhotoScreen(),
  '/photodetails': (BuildContext context) => new PhotoDetailsScreen(),
  '/video': (BuildContext context) => new VideoScreen(),
  '/videocategory': (BuildContext context) => new VideoCategory(),
  '/audio': (BuildContext context) => new AudioScreen(),
  '/audiocategory': (BuildContext context) => new AudioCategory(),
  '/audiodetails': (BuildContext context) => new AudioDetailScreen(),
  '/about': (BuildContext context) => new AboutScreen(),
};
