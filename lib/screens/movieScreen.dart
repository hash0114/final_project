import 'package:final_project/utils/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieCodeScreen extends StatefulWidget {
  const MovieCodeScreen({super.key});

  @override
  State<MovieCodeScreen> createState() => _MovieCodeScreenState();
}

class _MovieCodeScreenState extends State<MovieCodeScreen> {
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/';

  List movies = [];
  List selected = [];
  bool isLoading = true;
  bool matchFound = false;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Choice',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[200],
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : (!matchFound
                ? Dismissible(
                    key: Key(movies[0]['id'].toString()),
                    onDismissed: (direction) {
                      setState(() {
                        if (selected.isNotEmpty) {
                          selected.removeLast(); //clear selected movie
                          selected.add(movies[0]);
                          movies.removeAt(0);
                        } else {
                          selected.add(movies[0]);
                          movies.removeAt(0);
                        }
                      });

                      if (direction.name == "endToStart") {
                        movieVote(movies[0]['id'], false);
                      } else if (direction.name == "startToEnd") {
                        movieVote(movies[0]['id'], true);
                      }
                    },
                    secondaryBackground: Container(
                      color: Colors.blue[200],
                      child: const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.thumb_down,
                            color: Colors.black,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    background: Container(
                      color: Colors.blue[200],
                      child: const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.thumb_up,
                            color: Colors.black,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                '$imageBaseUrl/w500/${movies[0]['poster_path']}',
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movies[0]['title'],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        movies[0]['release_date'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle),
                                        child: Text(
                                          '${movies[0]['vote_average'].toStringAsFixed(1)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Chosen Movie: ${selected[0]['title']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: Image.network(
                                  '$imageBaseUrl/w500/${selected[0]['poster_path']}',
                                  height: 500,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      selected[0]['overview'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Released: ${selected[0]['release_date']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.amber, size: 18),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${selected[0]['vote_average'].toStringAsFixed(1)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }

  Future<void> movieVote(movieId, vote) async {
    final storageRef = await SharedPreferences.getInstance();
    final String? session = storageRef.getString("sessionId");
    if (session != null) {
      final response = await HttpHelper.voteMovie(session, movieId, vote);
      if (!response.isEmpty) {
        setState(() {
          matchFound = true;
        });
      } else {
        setState(() {
          matchFound = false;
        });
      }
    }
  }

  Future<void> fetchMovies() async {
    final response = await HttpHelper.fetchMovies();

    if (!response['results'].isEmpty) {
      final results = response['results'];
      setState(() {
        movies = [...results]..shuffle();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }
}
