import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'recycling_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickerDemo(),
    );
  }
}

class ImagePickerDemo extends StatefulWidget {
  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var v = "";
  img.Image? preprocessedImg;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/EcoSnapModelfinal.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImageCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        File originalFile = File(image.path);
        setState(() {
          _image = image;
          file = originalFile;
        });

        detectImage(file!);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _pickImageGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File originalFile = File(image.path);
        setState(() {
          _image = image;
          file = originalFile;
        });

        detectImage(file!);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Uint8List preprocessImage(File imageFile) {
    img.Image originalImage = img.decodeImage(imageFile.readAsBytesSync())!;
    img.Image resizedImage = img.copyResize(originalImage, width: 96, height: 96);

    Float32List floatList = Float32List(96 * 96 * 3);
    int index = 0;
    for (int y = 0; y < 96; y++) {
      for (int x = 0; x < 96; x++) {
        var pixel = resizedImage.getPixel(x, y);
        floatList[index++] = (img.getRed(pixel) / 255.0).toDouble();
        floatList[index++] = (img.getGreen(pixel) / 255.0).toDouble();
        floatList[index++] = (img.getBlue(pixel) / 255.0).toDouble();
      }
    }
    return floatList.buffer.asUint8List();
  }

  Future<void> detectImage(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;

    Uint8List inputImage = preprocessImage(image);

    var recognitions = await Tflite.runModelOnBinary(
      binary: inputImage,
      numResults: 3,
    );

    setState(() {
      _recognitions = recognitions;
      v = recognitions?.map((recognition) => recognition['label']).join(', ') ?? '';
    });

    print("//////////////////////////////////////////////////");
    print(_recognitions);
    print("//////////////////////////////////////////////////");

    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");

    if (_recognitions != null && _recognitions.isNotEmpty) {
      String itemType = _recognitions[0]['label'];
      navigateToRecyclingInfo(itemType); // Llamar a la función para abrir la pantalla de RecyclingInfo
    }
  }

  void navigateToRecyclingInfo(String itemType) {
    Map<String, Map<String, String>> recyclingData = {
      'battery': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Información sobre el reciclaje de baterías...',
      },
      'cardboard': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Descripción: Incluye cajas de cartón, cartulinas, papel kraft, cajas de cereales, y más. ' '\n\n' +
            'Preparación: Deben estar limpias, aplastadas y sin restos de comida, plumavit o cinta adhesiva.',
      },
      'glass': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Descripción: Botellas y frascos de vidrio, envases de perfumes y medicamentos, vasos y copas. ' '\n\n' +
            'Preparación: Retira las tapas o corcho y enjuaga los envases.' '\n\n' + 
            'No se reciclan parabrisas, espejos, ampolletas, tubos fluorescentes, loza, cristales, ni vidrio templado.',
      },
      'metal': {
        'videoUrl': 'https://www.youtube.com/watch?v=NuWQgh-RrSo',
        'info': 'Descripción: Restos de fierro, acero, rejas, tarros, artefactos, tablas de planchar, tendederos, bicicletas, entre otros. ' '\n\n' +
            'Preparación: Separar otros materiales de la chatarra metálica como madera o plástico. ' '\n\n' +
            'Limpios, sin restos de grasas, alimentos, líquidos u otros elementos en su interior',
      },
      'paper': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Descripción: Incluye hojas blancas, cuadernos, diarios y revistas.' '\n\n' +
            'Preparación: Las hojas deben estar sin pintura y los cuadernos sin forros, ni espirales, ni clips.''\n\n' +
            'Asegúrate de que estén limpias y secas',
      },
      'plastic': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Descripción: Incluye botellas de plástico de aguas, bebidas o jugos, envases de jabón, shampoo, detergente, productos de limpieza y leche, bolsas de supermercado, envoltorios de plástico y film para embalar. ' '\n\n' +
            'Preparación: Los envases deben enjuagarse y compactarse para reducir su volumen.',
      },
    };

    if (recyclingData.containsKey(itemType)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecyclingInfo(
            itemType: itemType,
            videoUrl: recyclingData[itemType]!['videoUrl']!,
            info: recyclingData[itemType]!['info']!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Container(
                width: 250,
                height: 250,
                child: Image.file(
                  File(_image!.path),
                  fit: BoxFit.contain,
                ),
              )
            else
              Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageCamera,
              child: Text('Use Camera'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageGallery,
              child: Text('Pick from Gallery'),
            ),
            SizedBox(height: 20),
            Text(v),
          ],
        ),
      ),
    );
  }
}
