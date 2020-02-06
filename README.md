# pagination

[![pub package](https://img.shields.io/badge/pub-0.1.0-blueviolet.svg)](https://pub.dev/packages/pagination)<br>
A Pagination Library for Flutter (with Web Support).

### How to Use
just add below in pubspec.yaml 
```
pagination: ^0.1.0
```
```
import 'package:pagination/pagination.dart';
```
Demo Code:
```
    PaginationList<User>(
        separatorWidget: Container(
          height: 0.5,
          color: Colors.black,
        ),
        itemBuilder: (BuildContext context, User user) {
          return ListTile(
            title:
                Text(user.prefix + " " + user.firstName + " " + user.lastName),
            subtitle: Text(user.designation),
            leading: IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () => null,
            ),
            onTap: () => print(user.designation),
            trailing: Icon(
              Icons.call,
              color: Colors.green,
            ),
          );
        },
        pageFetch: pageFetch,
        onError: (dynamic error) => Center(
          child: Text('Something Went Wrong'),
        ),
        ...
        onEmpty: Center(
          child: Text('Empty List'),
        ),
      ),
```
<br>
<img align="middle" src="https://user-images.githubusercontent.com/52414184/73930647-e0e0aa80-48fc-11ea-9017-a090627ba65e.gif" width=270 height=550>
<br>

### For more info:
Email: ssvekariya11@gmail.com