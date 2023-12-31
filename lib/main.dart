import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class Counter extends StateNotifier<int>{
  Counter():super(0);
  void increment() => state=state==0?1:state+1;
  // print(state);
  int?get value =>state;
}

final counterProvider=StateNotifierProvider<Counter,int>((ref)=>Counter(),);

extension OptionalInfixAddition<T extends num> on T?{
  T? operator +(T?other){
    final shadow = this;
    if(shadow!=null){
      return shadow +(other??0) as T;
    }else{
      return null;
    }
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

//Example1

final currentDate =Provider<DateTime>(
      (ref) => DateTime.now(),
);

enum City{
  Delhi,
  paris,
  tokyo,
}
typedef WeatherEmoji= String;

Future<WeatherEmoji> getWeather(City city){
  return Future.delayed(
    const Duration(seconds: 1), () =>  {
    City.Delhi: '🌞',
    City.paris: '⛈️',
    City.tokyo: '⛅',

  }[city] ?? 'No city found 😶',
  );

}

//UI writes to  and read from this
final currentCityProvider = StateProvider<City?>(
      (ref) => null,
);

const unknownWeatherEmoji = '😃';

// UI Read this
final weatherProvider = FutureProvider<WeatherEmoji>(
      (ref) {
    final city = ref.watch(currentCityProvider);
    if(city != null){
      return getWeather(city);
    }
    else{
      return unknownWeatherEmoji;
    }


  },);

class HomePage extends ConsumerWidget{
  const HomePage({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context,WidgetRef ref){
    final date = ref.watch(currentDate);
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
          title: Consumer(
            builder: (context,ref,child){
              final count=ref.watch(counterProvider);
              final text=count==null?'Press':count.toString();
              return Text(text);
            },
          )
      ),
      body: Column(
        children: [Center(child: Text(date.toString()),),
          TextButton(
            onPressed:(){
              ref.read(counterProvider.notifier).increment();
            },child:Text('Press'),
          ),
          currentWeather.when(
            data: (data)=> Text(data, style: TextStyle(fontSize: 40),),
            error: (_ , __) => Text('Error'),
            loading: () => Padding(padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ), ),
          Expanded(child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index){
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);  // so any change in this will build entire widget
                return ListTile(
                  title: Text(
                    city.toString(),
                  ),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    ref.read(currentCityProvider.notifier).state = city;
                  },
                );
              }
          ),),
        ],
      ),
    );
  }
}