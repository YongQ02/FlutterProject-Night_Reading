import 'package:flutter/material.dart';
import '../services/google_books_service.dart';
import 'package:nightreading/services/webview_page.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  // Initial Google Books API
  final GoogleBooksService _googleBooksService = GoogleBooksService();
  Map<String, dynamic>? _bookDetails;

  @override
  void initState() {
    super.initState();
    print('Book ID passed to BookDetailPage: ${widget.bookId}');
    _fetchBookDetails();
  }

  // Method for fetch book in detail
  Future<void> _fetchBookDetails() async {
    try {
      final data = await _googleBooksService.getBookById(widget.bookId);
      setState(() {
        _bookDetails = data;
        print("Book Details: $_bookDetails");

        final onlineReadUrl = _getOnlineReadUrl();
        print("Online Read URL: $onlineReadUrl");

        final volumeInfo = _bookDetails?['volumeInfo'];
        print("Volume Info: $volumeInfo");
      });
    } catch (e) {
      print('Error fetching book details: $e');
    }
  }

  // Method to show no link Dialog if no available link to fetch books.
  void _showNoLinkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Link Available'),
          content: const Text('There is no online reading link available for this book.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to get books Url and read online.
  // Use WebReaderLink first, if could not access then use previewLink to read book.
  String? _getOnlineReadUrl() {
    final accessInfo = _bookDetails?['accessInfo'];
    print('Access Info: $accessInfo');
    if (accessInfo != null) {
      final webReaderLink = accessInfo['webReaderLink'] as String?;
      if (webReaderLink != null && webReaderLink.isNotEmpty) {
        return webReaderLink;
      }

      final pdf = accessInfo['pdf'];
      if (pdf != null && pdf['isAvailable'] == true) {
        final acsTokenLink = pdf['acsTokenLink'] as String?;
        if (acsTokenLink != null && acsTokenLink.isNotEmpty) {
          return acsTokenLink;
        }
      }

      final volumeInfo = _bookDetails?['volumeInfo'];
      final previewLink = volumeInfo?['previewLink'] as String?;
      if (previewLink != null && previewLink.isNotEmpty) {
        return previewLink;
      }
    }
    return null;
  }

  // Page Layout
  @override
  Widget build(BuildContext context) {
    final title = _bookDetails?['volumeInfo']['title'] ?? 'Book Details';
    final coverUrl = _bookDetails?['volumeInfo']['imageLinks']?['thumbnail'];

    return Scaffold(

      // AppBar
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
      ),

      // Body
      body: _bookDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Cover
                    if (coverUrl != null)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            coverUrl,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    
                    // Book Title
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Author
                    Text(
                      _bookDetails?['volumeInfo']['authors']?.join(', ') ?? 'No authors',
                      style: const TextStyle(fontSize: 18, color: Colors.grey,),
                    ),
                    const Divider(height: 30, thickness: 1, color: Colors.grey),
                    
                    // Description
                    Text(
                      _bookDetails?['volumeInfo']['description'] ?? 'No description available',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 16, height: 1.5,),
                    ),
                    const SizedBox(height: 20),
                    
                    // Read Online Button
                    Center(
                      child: ElevatedButton(
                        onPressed: (){
                          final url = _getOnlineReadUrl();
                          if (url != null && url.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  initialUrl: url,
                                ),
                              ),
                            );
                          } else {
                            _showNoLinkDialog();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black12,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text('Read Online', style: TextStyle(fontSize: 16, color: Colors.blueGrey),),
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}