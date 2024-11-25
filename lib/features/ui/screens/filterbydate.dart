import 'package:flutter/material.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/screens/patientafterfilter.dart';
import 'package:kikira/features/ui/widgets/btn.dart';
import 'package:kikira/features/ui/widgets/textFormFeild_Widget.dart';

class FilterByDate extends StatefulWidget {
  const FilterByDate({super.key});

  @override
  State<FilterByDate> createState() => _FilterByDateState();
}

class _FilterByDateState extends State<FilterByDate> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerFromDate = TextEditingController();
  final TextEditingController controllerToDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorManager.kikiFirozi,
        title: const Text('Individual Search', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: colorManager.kikiGray,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextformfeildWidget(
              fieldName: 'Patient Name',
              controller: controllerName,
            ),
            TextformfeildWidget(
              fieldName: 'From Date',
              controller: controllerFromDate,
            ),
            TextformfeildWidget(
              fieldName: 'To Date',
              controller: controllerToDate,
            ),
            btnCal(
              text: "GO!",
              event: () {
                final encodedName = Uri.encodeComponent(controllerName.text);
                final fromDate = controllerFromDate.text.trim();
                final toDate = controllerToDate.text.trim();

                if (encodedName.isEmpty || fromDate.isEmpty || toDate.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields correctly.')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDateAfterFilter(
                      nameforHeader: controllerName.text,
                      fromDate: fromDate,
                      toDate: toDate,
                      name: encodedName,
                    ),
                  ),
                );
              },
              c: colorManager.kikiYellow,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
