import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  // Store API key and base URL
  final String _apiKey = 'AIzaSyCqt4PQ1yvwZdJuNa_f3SlMs2t_QYzUJ7Y';
  final String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  // Method to search books in Google Books API
  Future<List<dynamic>> searchBooks(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(Uri.parse('$_baseUrl?q=$encodedQuery&key=$_apiKey'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['items'] != null) {
          final List<dynamic> books = data['items'];
          final List<dynamic> filteredBooks = books.where((book) {
            final accessInfo = book['accessInfo'];
            final epub = accessInfo?['epub'];
            return epub != null && epub['isAvailable'] == true;
          }).toList();

          if (filteredBooks.isNotEmpty) {
            return filteredBooks;
          } else {
            print('No books with epub available found in response');
            return [];
          }
        } else {
          print('No items found in response');
          return [];
        }
      } else {
        print('Failed to load books. Status code: ${response.statusCode}');
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to get book ID from API
  Future<Map<String, dynamic>> getBookById(String bookId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$bookId?key=$_apiKey'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load book details. Status code: ${response.statusCode}');
        throw Exception('Failed to load book details');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}