import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'Newpage.dart';

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
      home: HomePage(),
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
          ElevatedButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => stlnew(),));
          }, child: Text("next")),
        ],
      ),
    );
  }
}
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:face_camera/face_camera.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await FaceCamera.initialize();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   File? _capturedImage;
//   Face? _detectedFace;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('FaceCamera example app'),
//           ),
//           body: Builder(builder: (context) {
//             if (_capturedImage != null) {
//               return Center(
//                 child: Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     Image.file(
//                       _capturedImage!,
//                       width: double.maxFinite,
//                       fit: BoxFit.fitWidth,
//                     ),
//                     Column(
//                       children: [
//                         ElevatedButton(
//                             onPressed: () => setState(() => _capturedImage = null),
//                             child: const Text(
//                               'Capture Again',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.w700),
//                             )),
//                         ElevatedButton(
//                             onPressed: () {  _cropImage(_capturedImage!.path);},
//                             child: const Text(
//                               'done',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 14, fontWeight: FontWeight.w700),
//                             )),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return Stack(
//               children: [
//                 SmartFaceCamera(
//                   autoCapture: true,
//                   defaultCameraLens: CameraLens.front,
//                   onCapture: (File? image) {
//                     setState(() => _capturedImage = image);
//                   },
//                   onFaceDetected: (Face? face) {
//                     // setState(() => _detectedFace = face);
//                   },
//                   messageBuilder: (context, face) {
//                     if (face == null) {
//                       return _message('Place your face in the camera');
//                     }
//                     if (!face.wellPositioned) {
//                       return _message('Center your face in the square');
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//                 if (_detectedFace != null)
//                   _drawFaceOverlay(_detectedFace!),
//               ],
//             );
//           },
//           ),
//       ),
//     );
//   }
//   Widget _message(String msg) => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
//     child: Text(msg,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//             fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
//   );
//
// Widget _drawFaceOverlay(Face face) {
//   return Positioned(
//     left: 5,
//     top: 5,
//     width: 70,
//     height: 70,
//     child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.green, // You can customize the color
//           width: 2.0, // You can customize the border width
//         ),
//       ),
//     ),
//   );
// }
//   void _cropImage(String imagePath) async {
//     ImageCropper imageCropper = ImageCropper();
//     File? croppedFile = await imageCropper.cropImage(
//       sourcePath: imagePath,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//       ],
//       uiSettings: [AndroidUiSettings(
//         toolbarTitle: 'Crop Face',
//         toolbarColor: Colors.blue,
//         toolbarWidgetColor: Colors.white,
//         statusBarColor: Colors.blue,
//         backgroundColor: Colors.black,
//       ),],
//     )as File?;
//
//     if (croppedFile != null) {
//       setState(() {
//         _capturedImage = croppedFile;
//       });
//     }
//   }
//
// }