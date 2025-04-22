
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lomi_chef_to_go/src/models/Address.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/map/client_address_map_page.dart';
import 'package:lomi_chef_to_go/src/provider/address_provider.dart';
import 'package:lomi_chef_to_go/src/utils/snackbar_helper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../models/user.dart';
import '../../../../utils/shared_preferences_helper.dart';

class ClientAddressCreateController {

  BuildContext? context;
  Function? refresh;

  // Controlador para el campo de texto del punto de referencia
  TextEditingController referencePointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController neighborhoodController = new TextEditingController();

  // Mapa que contiene la dirección seleccionada desde el mapa
  late Map<String, dynamic> referencePoint;

  AddressProvider _addressProvider = new AddressProvider();
  late User sessionUser;
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    sessionUser = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));
    _addressProvider.init(context, sessionUser);
  }

  void createAddress() async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;
    double lat = referencePoint['lat'] ?? 0;
    double lng = referencePoint['lng'] ?? 0;

    if (addressName.isEmpty || neighborhood.isEmpty || lat == 0 || lng == 0) {
      SnackbarHelper.show(context: context!, message: 'Completá todos los campos');
      return;
    }


    Address address = Address(
      idUser: sessionUser.id!,
      address: addressName,
      neighborhood: neighborhood,
      lat: lat,
      lng: lng,
    );
    
    ResponseApi? responseApi = await _addressProvider.createAddress(address);
    if (responseApi!.success) {
      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context!);
    }
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