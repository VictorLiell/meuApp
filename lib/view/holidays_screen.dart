import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar pacote para formatação de data
import '../controller/holiday_controller.dart';
import '../repositories/holiday_repository.dart';
import '../model/holiday.dart';
import 'app_drawer.dart'; // Import the AppDrawer

class HolidaysScreen extends StatefulWidget {
  const HolidaysScreen({super.key});

  @override
  _HolidaysScreenState createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  late Future<List<Holiday>> futureHolidays;
  final HolidayController controller = HolidayController(HolidayRepository());

  @override
  void initState() {
    super.initState();
    futureHolidays = controller.getHolidays();
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feriados Nacionais'),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: const AppDrawer(), // Use the AppDrawer here
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Holiday>>(
          future: futureHolidays,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar feriados'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum feriado disponível'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final holiday = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        holiday.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(formatDate(holiday.date)),
                      trailing: const Icon(Icons.calendar_today,
                          color: Colors.deepPurple),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
