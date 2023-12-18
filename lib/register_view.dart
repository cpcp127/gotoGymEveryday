import 'package:calendar_every/provider/register_provider.dart';
import 'package:calendar_every/toast/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            bottomSheet: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: GestureDetector(
                  onTap: () async {
                    await context.read<RegisterProvider>().registerEmail();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Text('회원가입'),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text('이메일'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: context.read<RegisterProvider>().emailFormKey,
                      child: TextFormField(
                        focusNode: context.read<RegisterProvider>().emailNode,
                        controller:
                            context.read<RegisterProvider>().emailController,
                        autovalidateMode: AutovalidateMode.disabled,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                        validator: (str) {
                          if (str!.isEmpty) {
                            return '사용하실 이메일을 입력해 주세요';
                          } else if (!str.isEmail) {
                            return '올바른 이메일 형식을 입력해 주세요';
                          } else if (context
                                  .read<RegisterProvider>()
                                  .isEmailExists ==
                              true) {
                            return '이미 등록된 이메일 입니다';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text('비밀번호'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: context.read<RegisterProvider>().pwdFormKey,
                      child: TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: 150),
                        focusNode: context.read<RegisterProvider>().pwdNode,
                        controller:
                            context.read<RegisterProvider>().pwdController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                        validator: (str) {
                          if (str!.isEmpty) {
                            return '사용하실 비밀번호를 입력해 주세요';
                          } else if (str.length < 8 || str.length > 20) {
                            return '비밀번호는 8자 이상 20자 이하이어야 합니다';
                          } else if (!RegExp(
                                  r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=]).*$')
                              .hasMatch(str)) {
                            return '비밀번호는 영문,숫자,특수문자를 포함해야 합니다';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        maxLines: 1,
                        autovalidateMode: AutovalidateMode.disabled,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text('비밀번호 확인'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: context.read<RegisterProvider>().pwdCheckFormKey,
                      child: TextFormField(
                        scrollPadding: EdgeInsets.only(bottom: 150),
                        focusNode:
                            context.read<RegisterProvider>().pwdCheckNode,
                        controller:
                            context.read<RegisterProvider>().pwdCheckController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                        validator: (str) {
                          if (str!.isEmpty) {
                            return '비밀번호가 일치하지 않습니다';
                          } else if (str !=
                              context
                                  .read<RegisterProvider>()
                                  .pwdController
                                  .text) {
                            return '비밀번호가 일치하지 않습니다';
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 100),
                  //   child: Form(
                  //     child: TextFormField(
                  //       focusNode:
                  //       context
                  //           .read<RegisterProvider>()
                  //           .pwdCheckNode,
                  //       controller:
                  //       context
                  //           .read<RegisterProvider>()
                  //           .pwdCheckController,
                  //       decoration: const InputDecoration(
                  //         border: OutlineInputBorder(
                  //           borderRadius:
                  //           BorderRadius.all(Radius.circular(12.0)),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide:
                  //           BorderSide(color: Colors.black, width: 1.0),
                  //           borderRadius:
                  //           BorderRadius.all(Radius.circular(12.0)),
                  //         ),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide:
                  //           BorderSide(color: Colors.black, width: 2.0),
                  //           borderRadius:
                  //           BorderRadius.all(Radius.circular(12.0)),
                  //         ),
                  //       ),
                  //       validator: (str) {
                  //         if (str!.isEmpty) {
                  //           return '비밀번호가 일치하지 않습니다';
                  //         } else if (str !=
                  //             context
                  //                 .read<RegisterProvider>()
                  //                 .pwdController
                  //                 .text) {
                  //           return '비밀번호가 일치하지 않습니다';
                  //         } else {
                  //           return null;
                  //         }
                  //       },
                  //       autovalidateMode: AutovalidateMode.onUserInteraction,
                  //       obscureText: true,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<RegisterProvider>().addNodeListener();
  }
}
