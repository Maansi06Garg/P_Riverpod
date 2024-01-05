import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
const names=[
  'alice',
  'bob',
  'charlie',
  'david',
  'eve',
  'fred',
  'ginny',
  'harriet',
  'ilena',
  'joseph',
  'kidcaid',
  'larry'
];
final tickerProvider = StreamProvider((ref) =>
    Stream.periodic(
      const Duration(seconds: 1),
          (i)=> i+1,
    ),);
final namesProvider = StreamProvider(
      (ref) =>
      ref.watch(tickerProvider.stream).map(
            (count) => names.getRange(0, count),),
      );
class stlnew extends ConsumerWidget {
  const stlnew({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context,WidgetRef ref){
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Provider'),
      ),
      body: names.when(
          data: (names){
            return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(names.elementAt(index)),
                  );  // use list tile
                }
            );
          },
          error: (error , StackTrace) => const Text('reached the end of the list!'),
          loading:() => Center(child: CircularProgressIndicator(),)
      ),
    );
  }
}
@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid,
  }):uuid=uuid??const Uuid().v4();

  Person Updated([String?name,int?age])=>Person(
      name: name??this.name,
      age: age??this.age,
      uuid:uuid,
  );
  String get displayName =>'$name ($age year old)';

  @override
  bool operator ==(covariant Person other)=>uuid==other.uuid;

  @override
  int get hashCode=>uuid.hashCode;

  @override
  String toString()=> 'Person(name:$name,age:$age,uuid:$uuid)';
}
class DataModel extends ChangeNotifier{
  final List<Person> _people=[];
  int get count => _people.length;
  UnmodifiableListView<Person> get people=> UnmodifiableListView(_people);
  void add(Person person){
    _people.add(person);
    notifyListeners();
  }
  void remove(Person person){
    _people.remove(person);
    notifyListeners();
  }
  void update(Person updatedPerson){
    final index =_people.indexOf(updatedPerson);
    final oldPerson = _people[index];
  }
}
class exp5 extends ConsumerWidget {
  const exp5({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(

    );
  }
}