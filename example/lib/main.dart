import 'package:example/user.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paginationList/paginationList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PaginationView Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PaginationView Example',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: PaginationList<User>(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          left: 5,
          right: 5,
        ),
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
        initialData: <User>[
          User(
            faker.person.prefix(),
            faker.person.firstName(),
            faker.person.lastName(),
            faker.company.position(),
          ),
          User(
            faker.person.prefix(),
            faker.person.firstName(),
            faker.person.lastName(),
            faker.company.position(),
          ),
        ],
        onEmpty: Center(
          child: Text('Empty List'),
        ),
      ),
    );
  }

  Future<List<User>> pageFetch(int offset) async {
    final Faker faker = Faker();
    final List<User> upcomingList = List.generate(
      15,
      (int index) => User(
        faker.person.prefix(),
        faker.person.firstName(),
        faker.person.lastName(),
        faker.company.position(),
      ),
    );
    await Future<List<User>>.delayed(
      Duration(milliseconds: 1500),
    );
    return upcomingList;
  }
}
