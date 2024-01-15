import 'package:flutter/cupertino.dart';

class ArticleProvider extends ChangeNotifier{
  final PageController _pageController = PageController();

  PageController get pageController => _pageController;
}