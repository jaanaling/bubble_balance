enum RouteValue {
  splash(path: '/'),
  menu(path: '/menu'),
  tasks(path: 'tasks'),
  analytics(path: '/analytics'),
  tips(path: '/tips'),
  settings(path: '/settings'),
  tests(path: '/tests'),
  test(path: 'test'),
  testResult(path: 'testResult'),
  privicy(path: 'privicy'),
  research(path: 'research'),
  unknown(path: '');

  final String path;

  const RouteValue({
    required this.path,
  });
}
