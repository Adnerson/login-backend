# TODO

## Data Cache / Remembering User
### So far I've gotten to getting the redis server working and the general data structure

- Just realized that the remembering user persists even after turning it off which is super sick

- [ ] Uncomment the changes to code so userIds are individualized
    - I commented them just to make sure the server connection was good
        - (its good btw)
- [x] Individualized userid
    - The backend stuff works as intended, now I just need to work on the frontend logic
        - Making them mesh well too

## Frontend
- How do I store individual userIds on the user device (flutter)?
    - Use the flutter_secure_storage package
        - Hash the username and use it as the userId for redis

            - example (rewrite the new value on login):
            
                    import 'package:flutter_secure_storage/flutter_secure_storage.dart';

                    // Create storage
                    final storage = new FlutterSecureStorage();

                    // Write value
                    await storage.write(key: 'user_id', value: 'your_user_id');

                    // Read value
                    String? userId = await storage.read(key: 'user_id');
            
            - On each new login, rewrite the value for the user_id
            - Ex: If the user logins in w/ new username, override the user_id w/ the new hashed one
                - In this case using sha256 is more reasonable as this is supposed to be quick