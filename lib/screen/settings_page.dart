import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final String supportPhoneNumber = '+56993948960'; // Número de soporte telefónico

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('Perfil'),
            children: [
              ListTile(
                title: Text('Editar Perfil'),
                onTap: () {
                  Navigator.pushNamed(context, '/edit_profile');
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Teléfono'),
            children: [
              ListTile(
                title: Text('Número de Soporte: $supportPhoneNumber'),
                onTap: () {
                  _launchPhoneApp(supportPhoneNumber);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Alerta'),
            children: [
              ListTile(
                title: Text('Problemas'),
                onTap: () {
                  _showReportDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Función para lanzar la aplicación de marcación del teléfono
  _launchPhoneApp(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Función para mostrar el diálogo de informe de problemas
  void _showReportDialog(BuildContext context) {
    final _problemTypeController = TextEditingController();
    final _problemDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reportar un problema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _problemTypeController,
                decoration: InputDecoration(labelText: 'Tipo de problema'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _problemDescriptionController,
                decoration: InputDecoration(labelText: 'Descripción del problema'),
                maxLines: null,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showThankYouDialog(context);
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el diálogo de agradecimiento
  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gracias'),
          content: Text('Gracias por cooperar con nosotros EcoSnap'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
