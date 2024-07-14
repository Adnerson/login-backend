import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';


Handler middleware(Handler handler) {
  return (context) async {
    final connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'postgres',
        username: 'postgres',
        password: 'qazwsx',
      ),
      //enable if accessing postgres over the internet
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

//YO FOR NEWER VERSIONS ITS CALLED CONNECTION
//ITS NOT 'POSTGRESQLCONNECTION'
//I SPENT 3 HOURS FIGURING THIS OUT HOEFOGRDFIOHKJNHJIO:KLVMNBFDJGLMBKDJGNLBLHDRGVFBJNGHRDBKJNR

    final response = await handler
        .use(provider<Connection>((_) => connection))
        .call(context);

    await connection.close();

    return response;
  };
}
