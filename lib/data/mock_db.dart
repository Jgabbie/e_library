// lib/data/mock_db.dart
class MockDatabase {
  static List<Map<String, String>> users = [
    {
      "username": "admin",
      "email": "admin@test.com",
      "password": "123",
    }
  ];

  static Map<String, String>? activeUser;

  // Updated Book Catalog with the 9 books from the image + 2 classics
  static List<Map<String, dynamic>> books = [
    {
      "id": "1",
      "title": "The Silent Patient",
      "author": "Alex Michaelides",
      "category": "Thriller",
      "rating": 4.5,
      "description":
          "Alicia Berenson’s life is seemingly perfect. One evening she shoots her husband five times in the face and never speaks another word. Theo Faber is a criminal psychotherapist who has waited a long time for the chance to unravel her motive.",
      "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSuC7RdyqgxQ_C2VozMwpP3u9y19kedr8UN5oQhejvLA&s=10",
    },
    {
      "id": "2",
      "title": "The Midnight Library",
      "author": "Matt Haig",
      "category": "Fiction",
      "rating": 4.1,
      "description":
          "Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived.",
      "imageUrl": "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1602190253i/52578297.jpg",
    },
    {
      "id": "3",
      "title": "Fourth Wing",
      "author": "Rebecca Yarros",
      "category": "Fantasy",
      "rating": 4.6,
      "description":
          "Twenty-year-old Violet Sorrengail was supposed to enter the Scribe Quadrant. Instead, she is ordered to join the hundreds of candidates striving to become the elite of Navarre: dragon riders.",
      "imageUrl": "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1701980900i/61431922.jpg",
    },
    {
      "id": "4",
      "title": "Daisy Jones & The Six",
      "author": "Taylor Jenkins Reid",
      "category": "Fiction",
      "rating": 4.2,
      "description":
          "A gripping novel following the legendary rise and precipitous fall of an iconic 1970s rock band and their beautiful lead singer, revealing the secret behind their split.",
      "imageUrl": "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1580255154i/40597810.jpg",
    },
    {
      "id": "5",
      "title": "The Invisible Life of Addie LaRue",
      "author": "V.E. Schwab",
      "category": "Fantasy",
      "rating": 4.2,
      "description":
          "France, 1714: In a moment of desperation, a young woman makes a Faustian bargain to live forever, but is cursed to be forgotten by everyone she meets.",
      "imageUrl": "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1584633432i/50623864.jpg",
    },
    {
      "id": "6",
      "title": "The Love Hypothesis",
      "author": "Ali Hazelwood",
      "category": "Romance",
      "rating": 4.3,
      "description":
          "A third-year Ph.D. candidate doesn't believe in lasting romantic relationships, but entering a fake-dating pact with a notoriously strict professor turns into something unexpectedly genuine.",
      "imageUrl": "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1611937942i/56732449.jpg",
    },
    {
      "id": "7",
      "title": "It Starts with Us",
      "author": "Colleen Hoover",
      "category": "Romance",
      "rating": 4.0,
      "description":
          "Switching between the perspectives of Lily and Atlas, this heartfelt story continues where the best-selling novel It Ends with Us left off.",
      "imageUrl": "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1644605295i/60393672.jpg",
    },
    {
      "id": "8",
      "title": "The Guest List",
      "author": "Lucy Foley",
      "category": "Thriller",
      "rating": 3.9,
      "description":
          "A celebrity wedding turns deadly on an isolated island off the windswept coast of Ireland as resentments and petty jealousies collide with tragic consequences.",
      "imageUrl": "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1591461181i/52656911.jpg",
    },
    {
      "id": "9",
      "title": "A Good Girl's Guide to Murder",
      "author": "Holly Jackson",
      "category": "Mystery",
      "rating": 4.4,
      "description":
          "Pretty and popular high school senior Andie Bell was murdered by her boyfriend, Sal Singh, who then killed himself. But Pip Fitz-Amobi isn't convinced.",
      "imageUrl": "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1545494980i/40916679.jpg",
    },
    {
      "id": "10",
      "title": "Pride and Prejudice",
      "author": "Jane Austen",
      "category": "Classics",
      "rating": 4.8,
      "description":
          "The romantic clash between the opinionated Elizabeth Bennet and her proud beau, Mr. Darcy, remains a timeless comedy of manners about love, family, and class distinctions.",
      "imageUrl": "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1681804503i/129915654.jpg",
    },
    {
      "id": "11",
      "title": "Crime and Punishment",
      "author": "Fyodor Dostoevsky",
      "category": "Classics",
      "rating": 4.7,
      "description":
          "Rodion Raskolnikov, an impoverished ex-student in Saint Petersburg, formulates and executes a plan to kill an unscrupulous pawnbroker, wrestling with moral guilt and existential dilemmas.",
      "imageUrl": "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1382846449i/7144.jpg",
    },
  ];

  static List<String> bookmarkedBookIds = [];
  static List<Map<String, dynamic>> cart = [];

  static final List<Map<String, dynamic>> orders = [];

  static void createOrder(List<String> bookIds) {
    if (bookIds.isEmpty) return;

    final now = DateTime.now();
    final orderNumber = orders.length + 1;
    orders.add({
      "id": "ORD-${now.year}-${orderNumber.toString().padLeft(3, "0")}",
      "date": "${_monthName(now.month)} ${now.day}, ${now.year}",
      "status": "Borrowed",
      "items": List<String>.from(bookIds),
    });
  }

  static String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  static bool isBookmarked(String bookId) {
    return bookmarkedBookIds.contains(bookId);
  }

  static void toggleBookmark(String bookId) {
    if (isBookmarked(bookId)) {
      bookmarkedBookIds.remove(bookId);
    } else {
      bookmarkedBookIds.add(bookId);
    }
  }

  static List<Map<String, dynamic>> getBookmarkedBooks() {
    return books
        .where((book) => bookmarkedBookIds.contains(book["id"]))
        .toList();
  }

  static void addToCart(Map<String, dynamic> book) {
    final existing = cart.where((item) => item["book"]["id"] == book["id"]);
    if (existing.isEmpty) {
      cart.add({"book": book, "quantity": 1});
    } else {
      existing.first["quantity"]++;
    }
  }

  static void updateCartQuantity(String bookId, int quantity) {
    final index = cart.indexWhere((item) => item["book"]["id"] == bookId);
    if (index == -1) return;
    if (quantity <= 0) {
      cart.removeAt(index);
    } else {
      cart[index]["quantity"] = quantity;
    }
  }

  static List<Map<String, dynamic>> getOrderBooks(
      Map<String, dynamic> order) {
    final ids = List<String>.from(order["items"] as List);
    return ids
        .map((id) => books.where((book) => book["id"] == id).firstOrNull)
        .whereType<Map<String, dynamic>>()
        .toList();
  }
}