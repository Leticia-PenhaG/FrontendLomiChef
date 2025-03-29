
import 'package:flutter/material.dart';

//Para elementos estáticos
import 'package:flutter/material.dart';

// Para elementos estáticos
class NoDataWidget extends StatelessWidget {
  final String text; // Debe ser final

  const NoDataWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/zero_items.png'),
          SizedBox(height: 10),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

