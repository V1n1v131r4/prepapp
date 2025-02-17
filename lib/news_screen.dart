import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  fetchPosts() async {
    final response = await http.get(Uri.parse('http://104.248.202.247:5000/latest_posts'));
    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
      });
    } else {
      // Trate o erro aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notícias'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final String channelName = post['channel'] ?? 'Canal desconhecido';
          final String channelLink = 'https://t.me/${post['channel']}';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(post['text'] ?? 'Sem conteúdo',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(post['date'], style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _openChannel(channelLink),
                    child: Text(
                      channelName,
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openChannel(String url) {
    // Aqui você pode usar um pacote como `url_launcher` para abrir o link
    print('Abrindo link: $url');
  }
}
