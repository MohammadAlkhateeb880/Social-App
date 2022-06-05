import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user/social_user_model.dart';
import 'package:social_app/modules/social_app/register/cubit/states.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
        name: name,
        email: email,
        phone: phone,
        uId: value.user.uid,
      );
    }).catchError((error) {
      print(error.toString());
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void createUser({
    @required String name,
    @required String email,
    @required String phone,
    @required String uId,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'Write Your Bio ...',
      image:
          'https://img.freepik.com/free-photo/waist-up-shot-handsome-smiling-european-adult-man-keeps-hand-rim-spectacles-wears-casual-jumper-being-good-mood-isolated-vivid-yellow-background-people-emotions-concept_273609-58969.jpg?w=996',
      cover:
          'https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?t=st=1646278115~exp=1646278715~hmac=26e6d2900dbe32a205dba35b1647bf54a5d9cb1eef4424cc17dc92a83ae3fcac&w=996',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassWord = true;

  void changeVisibility() {
    isPassWord = !isPassWord;
    suffix =
        isPassWord ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialRegisterChangePasswordVisibilityState());
  }
}
