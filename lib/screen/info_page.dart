import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido de la página
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Reducimos el ancho del contenedor
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Fondo blanco semitransparente
                  borderRadius: BorderRadius.circular(100.0),
                  border: Border.all(color: Colors.green, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Información',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2, // Mostrar en dos columnas
                      crossAxisSpacing: 10.0, // Espacio entre columnas
                      mainAxisSpacing: 10.0,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/Cartón.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(context, 'Cartón', 'Descripción: Incluye cajas de cartón, cartulinas, papel kraft, cajas de cereales, y más. ' '\n\n' +
                'Preparación: Deben estar limpias, aplastadas y sin restos de comida, plumavit o cinta adhesiva.',);
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/Vidrio.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(context, 'Vidrio', 'Descripción: Botellas y frascos de vidrio, envases de perfumes y medicamentos, vasos y copas. ' '\n\n' +
                'Preparación: Retira las tapas o corcho y enjuaga los envases.' '\n\n' + 
                'No se reciclan parabrisas, espejos, ampolletas, tubos fluorescentes, loza, cristales, ni vidrio templado.');
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/Plástico.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(context, 'Plástico', 'Descripción: Incluye botellas de plástico de aguas, bebidas o jugos, envases de jabón, shampoo, detergente, productos de limpieza y leche, bolsas de supermercado, envoltorios de plástico y film para embalar. ' '\n\n' +
                'Preparación: Los envases deben enjuagarse y compactarse para reducir su volumen.');
                          },
                        ),
                        IconButton(
                         icon: Image.asset('assets/images/Batería.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(context, 'Bateria', 'Información sobre las latas.');
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/Lata.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(context, 'Lata', 'Descripción: Latas, tarros, aluminio, entre otros. ' '\n\n' +
                'Preparación: Separar otros materiales de la chatarra metálica como madera o plástico. ' '\n\n' +
                'Limpios, sin restos de grasas, alimentos, líquidos u otros elementos en su interior');
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/Papel.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(context, 'Papel', 'Descripción: Incluye hojas blancas, cuadernos, diarios y revistas.' '\n\n' +
                'Preparación: Las hojas deben estar sin pintura y los cuadernos sin forros, ni espirales, ni clips.''\n\n' +
                'Asegúrate de que estén limpias y secas');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
