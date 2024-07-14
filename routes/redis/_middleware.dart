import 'package:dart_frog/dart_frog.dart';
import 'package:redis/redis.dart';

final conn = RedisConnection();

Handler middleware(Handler handler) {
  return (context) async {
    Response response;

    try {
      final command = await conn.connect('localhost', 6379);

      try {
        // add the redis-password to local storage b4 pushing to github
        // or to a .env file
        // btw the password is the classic
        await command.send_object(
          [
            'AUTH',
            'default',
            '3d24b894be4d55eecda6b582866640c1d466251700563cf7d98c4ce4aa3ca52a'
          ],
        );

        response =
            await handler.use(provider<Command>((_) => command)).call(context);
      } catch (e) {
        response =
            Response.json(body: {'success': false, 'message': e.toString()});
      }
    } catch (e) {
      response =
          Response.json(body: {'success': false, 'message': e.toString()});
    }

    return response;
  };
}
