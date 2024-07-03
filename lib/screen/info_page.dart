import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  void _showInfoDialog(BuildContext context, String title, String message, String videoUrl) {
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: 10),
              if (videoUrl.isNotEmpty)
                YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                ),
            ],
          ),
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
                            _showInfoDialog(
                              context, 
                              'Cartón', 
                              'Descripción: Incluye cajas de cartón, cartulinas, papel kraft, cajas de cereales, y más. \n\nPreparación: Deben estar limpias, aplastadas y sin restos de comida, plumavit o cinta adhesiva.', 
                              'https://youtu.be/BYxhhS5sB94',
                            );
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/Vidrio.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(
                              context, 
                              'Vidrio', 
                              'Descripción: Botellas y frascos de vidrio, envases de perfumes y medicamentos, vasos y copas. \n\nPreparación: Retira las tapas o corcho y enjuaga los envases.\n\nNo se reciclan parabrisas, espejos, ampolletas, tubos fluorescentes, loza, cristales, ni vidrio templado.', 
                              'https://youtu.be/-_Mj1iZQUf8',
                            );
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/Plástico.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(
                              context, 
                              'Plástico', 
                              'Descripción: Incluye botellas de plástico de aguas, bebidas o jugos, envases de jabón, shampoo, detergente, productos de limpieza y leche, bolsas de supermercado, envoltorios de plástico y film para embalar. \n\nPreparación: Los envases deben enjuagarse y compactarse para reducir su volumen.', 
                              'https://www.youtube.com/watch?v=DCe59pjPigM',
                            );
                          },
                        ),
                        IconButton(
                         icon: Image.asset('assets/images/Batería.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(
                              context, 
                              'Batería', 
                              'Información sobre las baterías.', 
                              'https://youtu.be/BYxhhS5sB94',
                            );
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/Lata.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(
                              context, 
                              'Lata', 
                              'Descripción: Latas, tarros, aluminio, entre otros. \n\nPreparación: Separar otros materiales de la chatarra metálica como madera o plástico. \n\nLimpios, sin restos de grasas, alimentos, líquidos u otros elementos en su interior', 
                              'https://www.youtube.com/watch?v=phcHgmHILE8',
                            );
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/Papel.png', width: 50.0, height: 50.0),
                          onPressed: () {
                            _showInfoDialog(
                              context, 
                              'Papel', 
                              'Descripción: Incluye hojas blancas, cuadernos, diarios y revistas.\n\nPreparación: Las hojas deben estar sin pintura y los cuadernos sin forros, ni espirales, ni clips.\n\nAsegúrate de que estén limpias y secas', 
                              'https://youtu.be/BYxhhS5sB94',
                            );
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
