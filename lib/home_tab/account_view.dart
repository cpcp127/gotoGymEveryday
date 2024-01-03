import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_every/provider/account_provider.dart';
import 'package:calendar_every/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Row(),
                const SizedBox(height: 30),
                // Container(
                //     width: 60,
                //     height: 60,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //
                //     ),
                //     child: CachedNetworkImage(imageUrl:  UserService.instance.userModel.photoUrl)),
                CachedNetworkImage(
                  imageUrl: UserService.instance.userModel.photoUrl,
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      radius: 70,
                      backgroundImage: imageProvider,
                    );
                  },
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
                Text(UserService.instance.userModel.nickname),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              titlePadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.zero,
                              //insetPadding: EdgeInsets.symmetric(horizontal: 0),
                              buttonPadding: EdgeInsets.zero,
                              actionsPadding: EdgeInsets.zero,
                              content: Container(
                                height: 200,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    const Text('로그아웃 하시겠습니까?'),
                                    const Expanded(child: SizedBox()),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                context.pop();
                                              },
                                              child: Container(
                                                height: 50,
                                                color: Colors.grey,
                                                child: const Center(
                                                    child: Text('아니요')),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Flexible(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await context
                                                    .read<AccountProvider>()
                                                    .logout(context);
                                              },
                                              child: Container(
                                                height: 50,
                                                color: Colors.blue,
                                                child: const Center(
                                                    child: Text('네')),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        });
                  },
                  child: Container(
                    width: 100,
                    height: 60,
                    color: Colors.red,
                    child: const Center(child: Text('로그아웃')),
                  ),
                ),
              ],
            ),
          ),
        ),
        Consumer<AccountProvider>(
          builder: (context, provider, child) {
            return Visibility(
              visible: provider.isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
