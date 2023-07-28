
Future<void> main() async 
{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  AppInstance instance = AppInstance();
  await instance.init();

  runApp(App(instance: instance));
}
