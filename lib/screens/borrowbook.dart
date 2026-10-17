import 'package:flutter/material.dart';
import '../data/mock_db.dart';

class BorrowBookPage extends StatefulWidget {
  final Map<String, dynamic> book;

  const BorrowBookPage({super.key, required this.book});

  @override
  State<BorrowBookPage> createState() => BorrowBookPageState();
}

class BorrowBookPageState extends State<BorrowBookPage> {
  DateTime? returnDate;
  final TextEditingController noteController = TextEditingController();

  late bool isBookmarked;
  bool isSubmitting = false;
  bool acceptedPolicy = false;

  static const Color primaryOrange = Color(0xFFE87516);
  static const Color paleOrange = Color(0xFFFFF3E8);

  @override
  void initState() {
    super.initState();
    isBookmarked = MockDatabase.isBookmarked(widget.book["id"]);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void handleBookmarkToggle() {
    setState(() {
      MockDatabase.toggleBookmark(widget.book["id"]);
      isBookmarked = !isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isBookmarked ? "Added to My Library" : "Removed from My Library",
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void chooseReservationDate() {
    final now = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: returnDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
      helpText: 'Choose reservation date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF292929),
            ),
          ),
          child: child!,
        );
      },
    ).then((picked) {
      if (picked != null && mounted) {
        setState(() {
          returnDate = picked;
        });
      }
    });
  }

  void submitBorrowRequest() {
    if (returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please choose an expected return date."),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!acceptedPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the borrowing guidlines.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(
          Icons.menu_book_rounded,
          color: primaryOrange,
          size: 42,
        ),
        title: const Text('Borrow Request Ready'),
        content: Text(
          'Your borrow request for "${widget.book['title']}"'
          'is ready for confirmation. \n\n'
          'Expected return date: '
          '${MaterialLocalizations.of(context).formatMediumDate(returnDate!)}\n\n'
          'Your request will appear in My Orders after confirmation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close', style: TextStyle(color: primaryOrange)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              MockDatabase.createOrder([widget.book["id"].toString()]);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text("Done"),
          ),
        ],
      ),
    ).whenComplete(() {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final title = (book['title'] ?? 'Untitled Book').toString();
    final author = (book['authir'] ?? 'Unknown author').toString();
    final imageUrl = (book['imageUrl'] ?? '').toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text(
          "Book Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Remove bookmark' : 'Save book',
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: handleBookmarkToggle,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF0E6DE)),
            ),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: paleOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageUrl.isEmpty
                      ? const Icon(
                          Icons.menu_book_rounded,
                          color: primaryOrange,
                          size: 42,
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, __) => const Icon(
                            Icons.menu_book_rounded,
                            color: primaryOrange,
                            size: 42,
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BORROWING ITEM',
                        style: TextStyle(
                          color: primaryOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF292929),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'By $author',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Expected Return Date',
            style: const TextStyle(
              color: Color(0xFF292929),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: chooseReservationDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8DED6)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: primaryOrange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      returnDate == null
                          ? 'Choose your expected return date'
                          : MaterialLocalizations.of(
                              context,
                            ).formatMediumDate(returnDate!),
                      style: TextStyle(
                        color: returnDate == null
                            ? Colors.black54
                            : const Color(0xFF292929),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Additional Notes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF292929),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: noteController,
            maxLines: 3,
            maxLength: 300,
            decoration: InputDecoration(
              hintText: 'Add any notes about your borrowing request...',
              filled: true,
              fillColor: Colors.white,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8DED6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8DED6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryOrange, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: paleOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: primaryOrange),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Please return the book on or before your selected date',
                    style: TextStyle(
                      color: Color(0xFF704322),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: acceptedPolicy,
            onChanged: (value) {
              setState(() {
                acceptedPolicy = value ?? false;
              });
            },
            activeColor: primaryOrange,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'I agree to follow the library borrowing guidelines.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSubmitting ? null : submitBorrowRequest,
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(
                isSubmitting ? 'Submitting...' : 'Submit Borrow Request',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
