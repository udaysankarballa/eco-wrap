import 'package:flutter/material.dart';

import '../data/commodity_database.dart';
import '../models/commodity_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'food_profile_screen.dart';

class CommodityScreen extends StatefulWidget {
  const CommodityScreen({super.key});

  @override
  State<CommodityScreen> createState() => _CommodityScreenState();
}

class _CommodityScreenState extends State<CommodityScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Fruits',
    'Vegetables',
    'Grains',
    'Dairy',
    'Meat',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CommodityModel> get _filteredCommodities {
    final search = _searchController.text.trim().toLowerCase();

    return CommodityDatabase.commodities.where((commodity) {
      final categoryMatches =
          _selectedCategory == 'All' || commodity.category == _selectedCategory;

      final searchMatches =
          search.isEmpty || commodity.name.toLowerCase().contains(search);

      return categoryMatches && searchMatches;
    }).toList();
  }

  String _emojiForCommodity(String name) {
    const emojis = {
      'Mango': '🥭',
      'Apple': '🍎',
      'Banana': '🍌',
      'Grapes': '🍇',
      'Orange': '🍊',
      'Papaya': '🍈',
      'Pineapple': '🍍',
      'Watermelon': '🍉',
      'Guava': '🍐',

      'Tomato': '🍅',
      'Potato': '🥔',
      'Onion': '🧅',
      'Carrot': '🥕',
      'Cabbage': '🥬',
      'Broccoli': '🥦',
      'Spinach': '🌿',
      'Capsicum': '🫑',
      'Cucumber': '🥒',

      'Rice': '🍚',
      'Wheat': '🌾',
      'Maize': '🌽',
      'Oats': '🌾',
      'Barley': '🌾',
      'Millet': '🌾',
      'Corn': '🌽',
      'Quinoa': '🌾',
      'Sorghum': '🌾',

      'Milk': '🥛',
      'Cheese': '🧀',
      'Butter': '🧈',
      'Yogurt': '🥛',
      'Cream': '🥛',
      'Paneer': '🧀',

      'Chicken': '🍗',
      'Fish': '🐟',
      'Mutton': '🥩',
      'Beef': '🥩',
      'Pork': '🥩',
      'Eggs': '🥚',
    };

    return emojis[name] ?? '🌱';
  }

  void _openFoodProfile(CommodityModel commodity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodProfileScreen(commodity: commodity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                _buildHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchBar(),

                        const SizedBox(height: 14),

                        _buildCategoryChips(),

                        const SizedBox(height: 20),

                        _buildCommodityGrid(),

                        const SizedBox(height: 24),

                        _buildBottomHint(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(width: 4),

          Text('Select Commodity', style: AppTextStyles.screenTitle),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search commodity...',
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryGreen,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 17),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryGreen : AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selected ? AppColors.primaryGreen : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: selected ? AppColors.white : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommodityGrid() {
    final commodities = _filteredCommodities;

    if (commodities.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commodities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, index) {
        final commodity = commodities[index];

        return _buildCommodityCard(commodity);
      },
    );
  }

  Widget _buildCommodityCard(CommodityModel commodity) {
    return GestureDetector(
      onTap: () {
        _openFoodProfile(commodity);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _emojiForCommodity(commodity.name),
                  style: const TextStyle(fontSize: 31),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                commodity.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              commodity.category,
              style: AppTextStyles.caption.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 50,
            color: AppColors.textMuted,
          ),

          const SizedBox(height: 12),

          Text('No commodities found', style: AppTextStyles.cardTitle),

          const SizedBox(height: 5),

          Text(
            'Try another commodity or category.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHint() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.touch_app_rounded,
            color: AppColors.primaryGreen,
            size: 21,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Select a commodity to create its food profile.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}
