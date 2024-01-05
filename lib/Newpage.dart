import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

