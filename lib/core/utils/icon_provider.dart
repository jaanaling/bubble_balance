enum IconProvider {
  background(imageName: 'background.png'),
  backgroundQ(imageName: 'background_q.png'),
  anal(imageName: 'anal.png'),
  analA(imageName: 'anal_a.png'),
  delete(imageName: 'delete.png'),
  homeA(imageName: 'home_a.png'),
  home(imageName: 'home.png'),
  quizA(imageName: 'quiz_a.png'),
  quiz(imageName: 'quiz.png'),
  settingsA(imageName: 'settings_a.png'),
  settings(imageName: 'settings.png'),
  tipsA(imageName: 'tips_a.png'),
  tips(imageName: 'tips.png'),
  splash(imageName: 'splash.png'),
  tbi(imageName: 'tbi.png'),
  task(imageName: 'task.png'),

  unknown(imageName: '');

  const IconProvider({
    required this.imageName,
  });

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
