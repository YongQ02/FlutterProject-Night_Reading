import 'package:flutter/material.dart';
import '../services/google_books_service.dart'; 
import 'package:nightreading/library/book_detail_page.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  // Initial Google Books API
  final GoogleBooksService _googleBooksService = GoogleBooksService();
  // List to store books that has been searched.
  List<dynamic> _searchedBooks = [];

  @override
  void initState() {
    super.initState();
    _searchBooks();
  }

  // Mehthod for search books from API
  Future<void> _searchBooks() async {
    try {
      final data = await _googleBooksService.searchBooks(widget.query);
      setState(() {
        _searchedBooks = data;
      });
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  // Page Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text("${widget.query}"),
        backgroundColor: Colors.black,
      ),
      // Body
      body: _searchedBooks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _searchedBooks.length,
              itemBuilder: (context, index) {
                final book = _searchedBooks[index];
                final coverUrl = book['volumeInfo']['imageLinks'] != null
                    ? book['volumeInfo']['imageLinks']['thumbnail']
                    : '';
                final bookId = book['id'];

                return ListTile(
                  leading: coverUrl.isNotEmpty
                      ? Image.network(coverUrl, width: 50, fit: BoxFit.cover)
                      : null,
                  title: Text(book['volumeInfo']['title'] ?? 'No title'),
                  subtitle: Text(book['volumeInfo']['authors']?.join(', ') ?? 'No authors'),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(bookId: bookId),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}