
import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/map/client_address_map_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController {

  BuildContext? context;
  Function? refresh;

  // Controlador para el campo de texto del punto de referencia
  TextEditingController referencePointController = new TextEditingController();

  // Mapa que contiene la dirección seleccionada desde el mapa
  late Map<String, dynamic> referencePoint;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }

  /// Abre el mapa en un modal inferior y espera que el usuario seleccione una ubicación.
  /// Al volver, actualiza el campo de texto con la dirección seleccionada.
  void openMap() async {
    referencePoint = await showMaterialModalBottomSheet(
        context: context!,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClientAddressMapPage()
    );

    if(referencePoint!= null) {
      // Actualiza el campo de texto con la dirección obtenida desde el mapa
      referencePointController.text = referencePoint['address']; //addressName dentro de selectReferencePoint
      refresh!();
    }
  }


}