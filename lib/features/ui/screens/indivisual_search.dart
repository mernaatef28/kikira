import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/screens/paitentdisplay.dart';
import 'package:kikira/features/ui/widgets/btn.dart';
import 'package:kikira/features/ui/widgets/textFormFeild_Widget.dart';
import 'package:kikira/kiki_app.dart';

class IndivisualSearch extends StatelessWidget {
  const IndivisualSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(backgroundColor: colorManager.kikiKohly,
          title: Text('Indivisual Search ', style: TextStyle(color: Colors.white)),
          leading: IconButton(icon:Icon(Icons.arrow_back_outlined , color: Colors.white) , onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => kiki_Ra_app()));
          },)
      ),
      body: Container(
        color: colorManager.kikiOrange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextformfeildWidget(fieldName: 'Patient name ', controller: controller ,),
            btnCal(text: "GO!", event: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Paitentdisplay(patientName: controller.text ), // Adjust as needed
                ),
              );
            } , c: colorManager.kikiYellow , textColor: Colors.white)
          ],
        ),
      ),
    );
  }
}
