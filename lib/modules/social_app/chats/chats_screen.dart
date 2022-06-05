import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/models/user/social_user_model.dart';
import 'package:social_app/modules/social_app/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Conditional.single(
        context: context,
        conditionBuilder: (context)=>SocialCubit.get(context).users.length > 0,
        widgetBuilder: (context) => BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>buildChatItem(SocialCubit.get(context).users[index], context),
              separatorBuilder: (context, index) =>myDivider(),
              itemCount: SocialCubit.get(context).users.length,
            );
          },
        ),
        fallbackBuilder: (context) => Center(child: CircularProgressIndicator())
    );
  }


  Widget buildChatItem(SocialUserModel model, context) =>InkWell(
    onTap: (){
      navigateTo(context, ChatDetailsScreen(userModel: model,));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
                '${model.image}'
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            '${model.name}',
            style: TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );


}

