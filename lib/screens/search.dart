import 'package:flutter/material.dart';
import 'package:fyp/utils/food_menu.dart';
import 'package:fyp/utils/text_to_speech_service.dart';
import 'package:fyp/utils/voice_responses.dart';
import '../widgets/product_cards.dart';
import 'package:fyp/screens/item_details.dart';
import 'package:provider/provider.dart';
import 'package:fyp/screens/cart_fav_provider.dart';
import 'package:fyp/screens/my_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  final String? searchQuery;
  final String? intent;
  final List<String>? detectedItems;
  final String? sourceLanguage;
  
  const SearchPage({
    super.key, 
    this.searchQuery, 
    this.intent,
    this.detectedItems,
    this.sourceLanguage,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Food> _allProducts = [];
  List<Food> _filteredProducts = [];
  bool _isProcessingVoiceIntent = false;
  final _ttsService = TextToSpeechService();
  String _languageCode = 'en'; // Default language

  @override
  void initState() {
    super.initState();
    
    // Set language code
    _languageCode = widget.sourceLanguage ?? 'en';
    
    fetchProducts();
    
    // Start the automated workflow if coming from voice intent
    if (widget.intent != null && widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      _isProcessingVoiceIntent = true;
      
      // Use a slight delay to ensure the UI is fully built
      Future.delayed(Duration.zero, () {
        if (mounted) {
          _processVoiceIntent();
        }
      });
    }
    
    // Speak appropriate message based on intent
    if (widget.intent != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _speak(_getIntentResponseKey(widget.intent!));
      });
    }
  }
  
  // Speak using the TTS service
  void _speak(String responseKey) {
    final message = VoiceResponses.getResponse(_languageCode, responseKey);
    _ttsService.speakWithLanguage(message, _languageCode);
  }
  
  // Get response key based on intent
  String _getIntentResponseKey(String intent) {
    switch (intent) {
      case 'add_to_cart':
        return 'add_to_cart_success';
      case 'search':
        return 'search_starting';
      case 'remove_from_cart':
        return 'remove_from_cart';
      case 'add_review':
        return 'add_review';
      case 'favorite':
        return 'favorite_starting';
      default:
        return 'processing';
    }
  }

  void fetchProducts() {
    setState(() {
      var Res = Restaurant();
      _allProducts = Res.getall();
      _filteredProducts = List.from(_allProducts);
      
      // Filter products based on search query if available
      if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
        _filteredProducts = _allProducts
            .where((product) => product.name.toLowerCase().contains(widget.searchQuery!.toLowerCase()))
            .toList();
        
        // We'll let the search delegate handle TTS feedback instead of doing it here
        // This prevents duplicate "item not found" messages
      }
    });
  }

  // Process the voice intent with a fully automated workflow
  void _processVoiceIntent() async {
    // Don't speak search starting message here - it's already spoken in initState
    
    // First open the search dialog
    final String? result = await showSearch<String>(
      context: context,
      query: widget.searchQuery ?? '',
      delegate: AutoSubmitSearchDelegate(
        products: _allProducts,
        intent: widget.intent,
        detectedItems: widget.detectedItems,
        languageCode: _languageCode,
        autoSubmitDelay: const Duration(seconds: 2), // Longer delay to ensure results are processed
      ),
    );
    
    // After search dialog is closed, update the flag
    if (mounted) {
      setState(() {
        _isProcessingVoiceIntent = false;
      });
    }
  }

  // Regular search dialog without auto-submit
  void _openSearchDialog() {
    showSearch(
      context: context,
      query: widget.searchQuery ?? '',
      delegate: EnhancedProductSearchDelegate(
        products: _allProducts,
        intent: widget.intent,
        detectedItems: widget.detectedItems,
        languageCode: _languageCode,
      ),
    );
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: const Color(0xFF3B57B2),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearchDialog,
          ),
        ],
      ),
      body: _isProcessingVoiceIntent
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Processing voice search request..."),
                ],
              ),
            )
          : Column(
              children: [
                // Intent information banner if intent is provided
                if (widget.intent != null && widget.intent!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getIntentColor(widget.intent!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getIntentIcon(widget.intent!),
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voice Intent: ${_formatIntentLabel(widget.intent!)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.detectedItems != null && widget.detectedItems!.isNotEmpty)
                                Text(
                                  'Items: ${widget.detectedItems!.join(", ")}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              const SizedBox(height: 4),
                              const Text(
                                'Click the search icon to search for these items',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Results list
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? const Center(child: Text("No products found. Use the search icon to find products."))
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(food: _filteredProducts[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }
  
  // Helper methods for intent UI
  IconData _getIntentIcon(String intent) {
    switch (intent) {
      case 'add_to_cart':
        return Icons.add_shopping_cart;
      case 'search':
        return Icons.search;
      case 'go_to_cart':
        return Icons.shopping_cart;
      case 'remove_from_cart':
        return Icons.delete;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.help_outline;
    }
  }
  
  Color _getIntentColor(String intent) {
    switch (intent) {
      case 'add_to_cart':
        return Colors.green[700]!;
      case 'search':
        return Colors.blue[700]!;
      case 'go_to_cart':
        return Colors.orange[700]!;
      case 'remove_from_cart':
        return Colors.red[700]!;
      case 'favorite':
        return Colors.pink[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
  
  String _formatIntentLabel(String intent) {
    switch (intent) {
      case 'add_to_cart':
        return 'Add to Cart';
      case 'search':
        return 'Search';
      case 'go_to_cart':
        return 'Go to Cart';
      case 'add_review':
        return 'Add Review';
      case 'favorite':
        return 'Add to Favorites';
      default:
        return 'Unknown';
    }
  }
}

// Enhanced version of ProductSearchDelegate that can display intent information
class EnhancedProductSearchDelegate extends SearchDelegate<String> {
  final List<Food> products;
  final String? intent;
  final List<String>? detectedItems;
  final String languageCode;

  EnhancedProductSearchDelegate({
    required this.products, 
    this.intent, 
    this.detectedItems,
    this.languageCode = 'en',
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Food> searchResults = products
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchResults.isEmpty
        ? const Center(child: Text("No products found."))
        : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return ProductCard(food: searchResults[index]);
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Food> suggestions = products
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Column(
      children: [
        // Show intent banner only in suggestions and only if we have intent data
        if (intent != null && intent!.isNotEmpty && (detectedItems != null && detectedItems!.isNotEmpty))
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getIntentColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getIntentIcon(),
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    intent == 'add_to_cart' 
                      ? 'Looking for items to add to cart'
                      : 'Searching for items',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: suggestions.isEmpty
              ? const Center(child: Text("No products found."))
              : ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suggestions[index].name),
                      onTap: () {
                        query = suggestions[index].name;
                        showResults(context);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  // Helper methods
  IconData _getIntentIcon() {
    switch (intent ?? '') {
      case 'add_to_cart':
        return Icons.add_shopping_cart;
      case 'search':
        return Icons.search;
      case 'go_to_cart':
        return Icons.shopping_cart;
      case 'remove_from_cart':
        return Icons.delete;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.help_outline;
    }
  }
  
  Color _getIntentColor() {
    switch (intent ?? '') {
      case 'add_to_cart':
        return Colors.green[700]!;
      case 'search':
        return Colors.blue[700]!;
      case 'go_to_cart':
        return Colors.orange[700]!;
      case 'remove_from_cart':
        return Colors.red[700]!;
      case 'favorite':
        return Colors.pink[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}

// Special delegate that will auto-submit after a delay
class AutoSubmitSearchDelegate extends SearchDelegate<String> {
  final List<Food> products;
  final String? intent;
  final List<String>? detectedItems;
  final String languageCode;
  final Duration autoSubmitDelay;
  bool _hasAutoSubmitted = false;
  final TextToSpeechService _ttsService = TextToSpeechService();

  AutoSubmitSearchDelegate({
    required this.products, 
    this.intent, 
    this.detectedItems,
    this.languageCode = 'en',
    this.autoSubmitDelay = const Duration(milliseconds: 500),
  });

  // Helper method to speak using the TTS service
  void _speak(String responseKey) {
    final message = VoiceResponses.getResponse(languageCode, responseKey);
    _ttsService.speakWithLanguage(message, languageCode);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Please enter a search term'));
    }

    final filteredProducts = products
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Only show "no matching products" UI without speaking if we know we're
    // going to auto-submit with query modification later
    if (filteredProducts.isEmpty) {
      // Check if we have detectedItems that might work better as search terms
      if (intent != null && detectedItems != null && detectedItems!.isNotEmpty) {
        // Try a different item from the detected items list as a fallback
        // We'll handle this in buildSuggestions, no need to speak error here
        return const Center(child: Text('Trying alternative search terms...'));
      }
      
      // Only speak "item not found" if we're truly at a dead end
      Future.delayed(const Duration(seconds: 2), () {
        if (!context.mounted) return;
        _speak('item_not_found');
      });
      return const Center(child: Text('No matching products found'));
    }

    // We found products! Let the user know for search intent
    if (intent == 'search' && !_hasAutoSubmitted) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!context.mounted) return;
        _speak('search_results');
      });
    }

    // If we have an add_to_cart intent and haven't auto-submitted yet,
    // automatically add the first item to cart and navigate
    if (intent == 'add_to_cart' && !_hasAutoSubmitted && filteredProducts.isNotEmpty) {
      _hasAutoSubmitted = true;
      
      // Use a longer delay to show the results briefly before adding to cart
      Future.delayed(const Duration(seconds: 2), () {
        if (!context.mounted) return;
        if (filteredProducts.isNotEmpty) {
          final selectedFood = filteredProducts[0];
          
          // Get the cart provider
          final cartFavoriteProvider = Provider.of<CartFavoriteProvider>(context, listen: false);
          
          // Add the item to cart
          cartFavoriteProvider.addToCart(selectedFood);
          
          // Speak confirmation message
          _speak('add_to_cart_confirm');
          
          // Close the search and navigate directly to cart
          close(context, selectedFood.name);
          
          // Navigate directly to cart since item is already added
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyCart(
                sourceLanguage: languageCode,
              ),
            ),
          );
        }
      });
    }
    
    // If we have an add_review intent and haven't auto-submitted yet,
    // automatically navigate to the first item's details page
    if (intent == 'add_review' && !_hasAutoSubmitted && filteredProducts.isNotEmpty) {
      _hasAutoSubmitted = true;
      
      // Use a delay to show the results briefly before navigating
      Future.delayed(const Duration(seconds: 2), () {
        if (!context.mounted) return;
        if (filteredProducts.isNotEmpty) {
          final selectedFood = filteredProducts[0];
          
          // Close the search and navigate to item details
          close(context, selectedFood.name);
          
          // Navigate to item details with review intent
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailsPage(
                title: selectedFood.name, 
                price: selectedFood.price.toString(),
                image: selectedFood.imagePath,
                description: selectedFood.getDescription(languageCode),
                isReviewIntent: true,
                sourceLanguage: languageCode,
              ),
            ),
          );
        }
      });
    }
    
    // If we have a favorite intent and haven't auto-submitted yet,
    // automatically favorite the first item
    if (intent == 'favorite' && !_hasAutoSubmitted && filteredProducts.isNotEmpty) {
      _hasAutoSubmitted = true;
      
      // Use a delay to show the results briefly before favoriting
      Future.delayed(const Duration(seconds: 2), () {
        if (!context.mounted) return;
        if (filteredProducts.isNotEmpty) {
          final selectedFood = filteredProducts[0];
          
          // Get the cart/favorite provider
          final cartFavoriteProvider = Provider.of<CartFavoriteProvider>(context, listen: false);
          
          // Add the item to favorites
          selectedFood.isFavorite = true;
          cartFavoriteProvider.addToFavorites(selectedFood);
          
          // Update favorite status in Firestore
          _updateFavoriteStatus(selectedFood, true);
          
          // Speak confirmation message
          _speak('favorite_confirm');
          
          // Close the search
          close(context, selectedFood.name);
        }
      });
    }

    // Show a list of matched products
    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final food = filteredProducts[index];
        return ListTile(
          leading: Image.asset(food.imagePath, width: 50, height: 50),
          title: Text(food.name),
          subtitle: Text('\$${food.price}'),
          onTap: () {
            _hasAutoSubmitted = true;
            close(context, food.name);
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailsPage(
                  title: food.name, 
                  price: food.price.toString(),
                  image: food.imagePath,
                  description: food.getDescription(languageCode),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Try to show some fallback suggestions if we have detected items
    List<Food> suggestions = [];
    
    if (query.isNotEmpty) {
      // Use the current query
      suggestions = products
          .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    
    // Try fallback search terms if current search returns no results and we haven't auto-submitted
    if (suggestions.isEmpty && detectedItems != null && detectedItems!.isNotEmpty && !_hasAutoSubmitted) {
      // Try each detected item as a search term
      for (final item in detectedItems!) {
        final itemSuggestions = products
            .where((food) => food.name.toLowerCase().contains(item.toLowerCase()))
            .toList();
            
        if (itemSuggestions.isNotEmpty) {
          suggestions = itemSuggestions;
          // Auto-update query to the successful search term
          query = item;
          break;
        }
      }
      
      // If we found suggestions using a different query, auto-submit
      if (suggestions.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showResults(context);
          }
        });
      }
    }
    
    // Auto-submit the search after a delay if we have results
    if (query.isNotEmpty && !_hasAutoSubmitted) {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          showResults(context);
        }
      });
    }

    return Column(
      children: [
        // Show intent banner
        if (intent != null && intent!.isNotEmpty && (detectedItems != null && detectedItems!.isNotEmpty))
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getIntentColor(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getIntentIcon(),
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    intent == 'add_to_cart' 
                      ? 'Auto-searching items to add to cart...'
                      : 'Auto-searching items...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: suggestions.isEmpty
              ? const Center(child: Text("Searching for products..."))
              : ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suggestions[index].name),
                      onTap: () {
                        query = suggestions[index].name;
                        showResults(context);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  // Helper methods
  IconData _getIntentIcon() {
    switch (intent ?? '') {
      case 'add_to_cart':
        return Icons.add_shopping_cart;
      case 'search':
        return Icons.search;
      case 'go_to_cart':
        return Icons.shopping_cart;
      case 'remove_from_cart':
        return Icons.delete;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.help_outline;
    }
  }
  
  Color _getIntentColor() {
    switch (intent ?? '') {
      case 'add_to_cart':
        return Colors.green[700]!;
      case 'search':
        return Colors.blue[700]!;
      case 'go_to_cart':
        return Colors.orange[700]!;
      case 'remove_from_cart':
        return Colors.red[700]!;
      case 'favorite':
        return Colors.pink[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  // Update favorite status in Firestore
  Future<void> _updateFavoriteStatus(Food food, bool isFavorite) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isEqualTo: food.name)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'Fav': isFavorite});
      }
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }

  @override
  void close(BuildContext context, String result) {
    // Dispose TTS resources
    _ttsService.dispose();
    super.close(context, result);
  }
}
