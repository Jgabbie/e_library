
import 'package:flutter/material.dart';
import '../data/mock_db.dart';
import 'bookdetails.dart';

class BookCatalogPage extends StatefulWidget {
  const BookCatalogPage({super.key});

  @override
  State<BookCatalogPage> createState() => BookCatalogPageState();
}

class BookCatalogPageState extends State<BookCatalogPage> {
  TextEditingController searchController = TextEditingController();
  String selectedCategory = "All";
  String searchQuery = "";

  List<String> categories = [
    "All",
    "Thriller",
    "Fiction",
    "Fantasy",
    "Romance",
    "Mystery",
    "Classics",
  ];

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> filteredBooks = MockDatabase.books.where((book) {
      bool matchesCategory = selectedCategory == "All" || book["category"] == selectedCategory;
      bool matchesSearch = book["title"].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          book["author"].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Book Catalog", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.pushNamed(context, '/mylibrary').then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Container(
            color: Colors.orange,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (text) {
                setState(() {
                  searchQuery = text;
                });
              },
              decoration: const InputDecoration(
                hintText: "Search title or author...",
                prefixIcon: Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),


          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                bool isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(child: Text("No books found."))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> book = filteredBooks[index];
                      bool isSaved = MockDatabase.isBookmarked(book["id"]);

                      return Card(
                        elevation: 3,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsPage(book: book),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      color: Colors.orange[50],
                                      child: Image.network(
                                        book["imageUrl"],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.book, size: 50, color: Colors.orange),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 18,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                                            color: Colors.orange,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              MockDatabase.toggleBookmark(book["id"]);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book["title"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      book["author"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text(book["rating"].toString()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}