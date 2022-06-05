// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/state.dart';
import 'package:social_app/models/user/message_model.dart';
import 'package:social_app/models/user/social_user_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;
  ChatDetailsScreen({this.userModel});

  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(userModel.image),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(userModel.name),
                  ],
                ),
              ),
              body: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>SocialCubit.get(context).messages.length > 0,
                  widgetBuilder: (context) =>Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index){
                                var message = SocialCubit.get(context).messages[index];
                                if(SocialCubit.get(context).userModel.uId == message.senderId)
                                  return buildMyMessage(message);
                                return buildMessage(message);
                                },
                                separatorBuilder: (context, index)=>SizedBox(height: 15.0,),
                                itemCount: SocialCubit.get(context).messages.length
                            ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300],
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '    Type Your Message Here ...'),
                                ),
                              ),
                              Container(
                                height: 50.0,
                                color: defaultColor,
                                child: MaterialButton(
                                  onPressed: () {
                                    SocialCubit.get(context).sendMessage(
                                        receiverId: userModel.uId,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text);
                                    // messageController.text = '';
                                  },
                                  minWidth: 1.0,
                                  child: Icon(
                                    IconBroken.Send,
                                    size: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  fallbackBuilder: (context) => Center(child: CircularProgressIndicator())
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
                bottomEnd: Radius.circular(10.0),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Text(model.text)),
      );

  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            decoration: BoxDecoration(
              color: defaultColor.withOpacity(
                .2,
              ),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
                bottomStart: Radius.circular(10.0),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Text(model.text)),
      );
}
