import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TideInfoScreen extends StatefulWidget {
  const TideInfoScreen({super.key});

  @override
  _TideInfoScreenState createState() => _TideInfoScreenState();
}

class _TideInfoScreenState extends State<TideInfoScreen> {
  List<dynamic> stations = [];
  List<dynamic> filteredStations = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchTideStations();
  }

  Future<void> fetchTideStations() async {
    final url = Uri.parse("https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations.json");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey("stations")) {
          setState(() {
            stations = data["stations"];
            filteredStations = stations;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Nenhuma estação encontrada.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Erro ao carregar os dados (Código: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Erro ao buscar dados: $e";
        isLoading = false;
      });
    }
  }

  void filterStations(String query) {
    setState(() {
      filteredStations = stations
          .where((station) =>
              station["name"].toString().toLowerCase().contains(query.toLowerCase()) ||
              station["id"].toString().contains(query))
          .toList();
    });
  }

  void openTideDetails(String stationId, String stationName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TideDetailsScreen(stationId: stationId, stationName: stationName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Estações de Marés - NOAA'),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Buscar estação por nome ou ID...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: filterStations,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredStations.length,
                        itemBuilder: (context, index) {
                          final station = filteredStations[index];
                          return ListTile(
                            title: Text(
                              station["name"] ?? "Sem nome",
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "ID: ${station["id"]}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            leading: const Icon(Icons.waves, color: Colors.blue),
                            trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                            onTap: () => openTideDetails(station["id"], station["name"]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

class TideDetailsScreen extends StatefulWidget {
  final String stationId;
  final String stationName;

  const TideDetailsScreen({super.key, required this.stationId, required this.stationName});

  @override
  _TideDetailsScreenState createState() => _TideDetailsScreenState();
}

class _TideDetailsScreenState extends State<TideDetailsScreen> {
  List<dynamic> tideData = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchTideData();
  }

  Future<void> fetchTideData() async {
    final String today = DateFormat('yyyyMMdd').format(DateTime.now());
    final url = Uri.parse(
        "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?begin_date=$today&range=24&station=${widget.stationId}&product=predictions&datum=MLLW&interval=hilo&units=metric&time_zone=gmt&format=json");

    try {
      final response = await http.get(url);
      print("URL requisitada: $url");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey("predictions")) {
          setState(() {
            tideData = data["predictions"];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Nenhum dado de maré encontrado.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Erro ao carregar os dados (Código: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Erro ao buscar dados: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Marés: ${widget.stationName}"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: tideData.length,
                  itemBuilder: (context, index) {
                    final tide = tideData[index];
                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        title: Text(
                          "Hora: ${tide["t"]}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "Altura: ${tide["v"]}m",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        leading: const Icon(Icons.waves, color: Colors.blue),
                      ),
                    );
                  },
                ),
    );
  }
}
