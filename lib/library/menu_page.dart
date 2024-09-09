import 'package:flutter/material.dart';
import '../services/google_books_service.dart';
import 'package:nightreading/library/search_result_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // initial google books api
  final GoogleBooksService _googleBooksService = GoogleBooksService();
  // controller to manage user searching input
  final TextEditingController _searchController = TextEditingController();

  // store category books to list to show book covers
  List<dynamic> _trendingBooks = [];
  List<dynamic> _educationBooks = [];
  List<dynamic> _fictionBooks = [];
  List<dynamic> _scienceFictionBooks = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  // method to fetch book cover in list, search books and log out.
  Future<void> _fetchBooks() async {
    try {
      final trendingData = await Future.wait([
        _googleBooksService.searchBooks('trending'),
        _googleBooksService.searchBooks('economy'),
      ]);
      final trendingBooks = trendingData.expand((data) => data).toList();

       final educationData = await Future.wait([
        _googleBooksService.searchBooks('education'),
        _googleBooksService.searchBooks('language'),
      ]);
      final educationBooks = educationData.expand((data) => data).toList();

      final fictionData = await _googleBooksService.searchBooks('fiction');
      final scienceFictionData = await _googleBooksService.searchBooks('science fiction');

      setState(() {
        _trendingBooks = trendingBooks;
        _educationBooks = educationBooks;
        _fictionBooks = fictionData;
        _scienceFictionBooks = scienceFictionData;
      });
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: query),
        ),
      );
    }
  }

  void _logOut() {
    Navigator.of(context).pushReplacementNamed('/'); // Navigate to HomePage
  }

  // Screen layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logOut,
            ),
            const Text('Lobby'),
            const SizedBox(width: 48),
          ],
        ),
      ),
      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search books',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () => _onSearch(_searchController.text.trim()),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onSubmitted: (value) => _onSearch(value.trim()),
              ),
              const SizedBox(height: 30),

              // Trending Section
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.white),
                  const SizedBox(width: 10),
                  const Text(
                    'Trending',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _trendingBooks.isEmpty
                      ? [const Center(child: CircularProgressIndicator())]
                      : _trendingBooks.map((book) {
                          final coverUrl = book['volumeInfo']['imageLinks'] != null
                              ? book['volumeInfo']['imageLinks']['thumbnail']
                              : '';
                          final bookId = book['id'] ?? '';
                          return _buildBookCover(coverUrl, bookId);
                        }).toList(),
                ),
              ),
              const SizedBox(height: 40),

              // Education Section
              Row(
                children: [
                  const Icon(Icons.school, color: Colors.white),
                  const SizedBox(width: 10),
                  const Text(
                    'Education',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _educationBooks.isEmpty
                      ? [const Center(child: CircularProgressIndicator())]
                      : _educationBooks.map((book) {
                          final coverUrl = book['volumeInfo']['imageLinks'] != null
                              ? book['volumeInfo']['imageLinks']['thumbnail']
                              : '';
                          final bookId = book['id'] ?? '';
                          return _buildBookCover(coverUrl, bookId);
                        }).toList(),
                ),
              ),
              const SizedBox(height: 40),

              // Fiction Section
              Row(
                children: [
                  const Icon(Icons.book, color: Colors.white),
                  const SizedBox(width: 10),
                  const Text(
                    'Fiction',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _fictionBooks.isEmpty
                      ? [const Center(child: CircularProgressIndicator())]
                      : _fictionBooks.map((book) {
                          final coverUrl = book['volumeInfo']['imageLinks'] != null
                              ? book['volumeInfo']['imageLinks']['thumbnail']
                              : '';
                          final bookId = book['id'] ?? '';
                          return _buildBookCover(coverUrl, bookId);
                        }).toList(),
                ),
              ),
              const SizedBox(height: 40),

              // Science Fiction Section
              Row(
                children: [
                  const Icon(Icons.science, color: Colors.white),
                  const SizedBox(width: 10),
                  const Text(
                    'Science Fiction',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _scienceFictionBooks.isEmpty
                      ? [const Center(child: CircularProgressIndicator())]
                      : _scienceFictionBooks.map((book) {
                          final coverUrl = book['volumeInfo']['imageLinks'] != null
                              ? book['volumeInfo']['imageLinks']['thumbnail']
                              : '';
                          final bookId = book['id'] ?? '';
                          return _buildBookCover(coverUrl, bookId);
                        }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

 // Build book cover on menu page by widget
  Widget _buildBookCover(String coverUrl, String bookId) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/bookdetail', arguments: bookId); 
        },
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(coverUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          )
        ),
      ),
    );
  }
}