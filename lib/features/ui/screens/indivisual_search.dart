import 'package:flutter/material.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
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
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorManager.kikiFirozi,
        title: Text(
          'Indivisual Search',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () {
            Navigator.pop(
                context,
            );
          },
        ),
      ),
      body: Container(
        color: colorManager.kikiGray,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextformfeildWidget(
              fieldName: 'Patient name',
              controller: controller,
            ),
            btnCal(
              text: "GO!",
              event: () async{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Paitentdisplay(patientName: controller.text,)
                  ),
                );
              },
              c: colorManager.kikiFirozi,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
