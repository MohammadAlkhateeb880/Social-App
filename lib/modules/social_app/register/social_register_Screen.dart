
// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:social_app/layout/social_app/social_layout.dart';
import 'package:social_app/modules/social_app/register/cubit/cubit.dart';
import 'package:social_app/modules/social_app/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

// ignore: must_be_immutable
class SocialRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit,SocialRegisterStates>(
        listener: (context, state) {
          if(state is SocialCreateUserSuccessState){
            navigateAndFinish(context, SocialLayout());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body:  Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.black),
                        ),
                        SizedBox(height: 15.0,),
                        Text(
                          'Register now to Communicate With Your Friends ',
                          style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.text,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Please Enter Your Name';
                              }
                            },
                            label: 'Name',
                            prefix: Icons.person
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Please Enter Your Email Address';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Password Is Too Short!!';
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: SocialRegisterCubit.get(context).suffix,
                            isPassword: SocialRegisterCubit.get(context).isPassWord,
                            suffixAction: (){
                              SocialRegisterCubit.get(context).changeVisibility();
                            },
                            onSubmit: (value){
                            }
                        ),
                        SizedBox(height: 15.0,),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Please Enter Your Phone';
                              }
                            },
                            label: 'Phone',
                            prefix: Icons.phone
                        ),
                        SizedBox(height: 30.0,),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) => state is! SocialRegisterLoadingState,
                          widgetBuilder: (context) => defaultButton(
                            function: (){
                              if(formKey.currentState.validate()){
                                SocialRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                );
                              }
                            },
                            text: 'send',
                            isUpperCase: true,
                          ),
                          fallbackBuilder: (context) =>Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
