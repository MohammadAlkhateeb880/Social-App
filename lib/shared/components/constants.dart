import 'package:social_app/modules/social_app/login/social_login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

void signOut(context)
{
  CacheHelper.removeData(key: 'token').then((value){
    if(value){
      navigateAndFinish(context, SocialLoginScreen());
    }
  });
}

// This Method UseFul For Print All Data From Json File!
void printFullText(String text)
{
  final pattern = RegExp('.{1,800}'); // 800 is The Size Of Each chunk
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}

String token = '';

String uId = '';
