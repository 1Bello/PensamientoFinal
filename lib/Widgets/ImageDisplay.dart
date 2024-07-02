import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'recycling_info.dart';

class ImageDisplayPage extends StatelessWidget {
  final XFile? image;
  final List<dynamic> recognitions;

  ImageDisplayPage({
    required this.image,
    required this.recognitions,
  });

  void navigateToRecyclingInfo(String itemType, BuildContext context) {
    Map<String, Map<String, String>> recyclingData = {
      'Batería': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Información sobre el reciclaje de baterías...',
      },
      'Cartón': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Descripción: Incluye cajas de cartón, cartulinas, papel kraft, cajas de cereales, y más. '
            '\n\n' +
            'Preparación: Deben estar limpias, aplastadas y sin restos de comida, plumavit o cinta adhesiva.',
      },
      'Vidrio': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Descripción: Botellas y frascos de vidrio, envases de perfumes y medicamentos, vasos y copas. '
            '\n\n' +
            'Preparación: Retira las tapas o corcho y enjuaga los envases.'
            '\n\n' +
            'No se reciclan parabrisas, espejos, ampolletas, tubos fluorescentes, loza, cristales, ni vidrio templado.',
      },
      'Lata': {
        'videoUrl': 'https://www.youtube.com/watch?v=NuWQgh-RrSo',
        'info': 'Descripción: Latas, tarros, aluminio, entre otros. ' '\n\n' +
            'Preparación: Separar otros materiales de la chatarra metálica como madera o plástico. '
            '\n\n' +
            'Limpios, sin restos de grasas, alimentos, líquidos u otros elementos en su interior',
      },
      'Papel': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Descripción: Incluye hojas blancas, cuadernos, diarios y revistas.'
            '\n\n' +
            'Preparación: Las hojas deben estar sin pintura y los cuadernos sin forros, ni espirales, ni clips.'
            '\n\n' +
            'Asegúrate de que estén limpias y secas',
      },
      'Plástico': {
        'videoUrl': 'https://youtu.be/BYxhhS5sB94',
        'info': 'Descripción: Incluye botellas de plástico de aguas, bebidas o jugos, envases de jabón, shampoo, detergente, productos de limpieza y leche, bolsas de supermercado, envoltorios de plástico y film para embalar. '
            '\n\n' +
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (image != null)
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.9,
                  child: Image.file(
                    File(image!.path),
                    fit: BoxFit.contain,
                  ),
                )
              else
                Text('No image selected'),
              SizedBox(height: 20),
              Text(
                recognitions.isNotEmpty
                    ? 'Esto es ${recognitions[0]['label']}'
                    : 'No object detected',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (recognitions.isNotEmpty)
                Column(
                  children: recognitions.map((recognition) {
                    String itemType = recognition['label'];
                    double confidence = recognition['confidence'] * 100;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          navigateToRecyclingInfo(itemType, context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/$itemType.png',
                              height: 60,
                              width: 60,
                            ),
                            SizedBox(width: 16),
                            Text(
                              '$itemType (${confidence.toStringAsFixed(2)}%)',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Elige otra imagen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}