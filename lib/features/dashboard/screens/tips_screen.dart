import 'package:flutter/material.dart';
import '../../../widgets/app_logo.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/tip_model.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static const List<TipModel> allTips = [
    TipModel(
      id: '1',
      title: 'Mastering Organic Scraps & Composting',
      category: 'Organic',
      imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800',
      date: 'Oct 24, 2026',
      readingTime: '5 min',
      content: 'Organic waste, or green waste, is anything that can decompose naturally. This includes fruit peels, vegetable remains, coffee grounds, and garden waste like leaves and grass clippings.\n\nWhy sort organic scraps?\nWhen organic waste is sent to landfills, it decomposes anaerobically (without oxygen), which produces methane—a greenhouse gas much more potent than carbon dioxide. By sorting it, you allow for composting, which turns waste into nutrient-rich soil.\n\nDeep Dive into Composting:\nComposting is nature\'s way of recycling. By providing the right environment for bacteria, fungi, and other decomposing organisms, you can turn your kitchen scraps into "black gold" for your garden.\n\nTips for better sorting:\n1. Use a dedicated bin for food scraps to avoid contamination.\n2. Avoid mixing plastic bags or packaging with organics, even if they claim to be biodegradable.\n3. Garden waste should be separated if possible to facilitate professional mulching and large-scale composting operations.',
    ),
    TipModel(
      id: '2',
      title: 'Paper & Cardboard: The Cleanliness Factor',
      category: 'Paper',
      imageUrl: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
      date: 'Oct 22, 2026',
      readingTime: '3 min',
      content: 'Paper and cardboard are highly recyclable, but they must be clean. Oil and food stains can ruin an entire batch of recycled paper by preventing the fibers from bonding correctly during the pulping process.\n\nWhat to include:\n- Newspapers and magazines (glossy is usually fine)\n- Cereal boxes and shipping cartons (remove tape if possible)\n- Office paper and envelopes\n\nWhat to avoid:\n- Greasy pizza boxes (the grease is the enemy!)\n- Wax-coated paper cups or frozen food boxes\n- Thermal receipt paper, which often contains BPA',
    ),
    TipModel(
      id: '3',
      title: 'Identifying & Sorting Metals',
      category: 'Metals',
      imageUrl: 'https://images.unsplash.com/photo-1558484628-95a02ea2911b?w=800',
      date: 'Oct 20, 2026',
      readingTime: '4 min',
      content: 'Metals like aluminum and steel are valuable materials that can be recycled infinitely without losing quality. In fact, recycling aluminum saves 95% of the energy needed to produce it from scratch.\n\nPreparation for Recycling:\n1. Rinse cans to remove food residue and prevent odors/pests.\n2. Remove plastic labels if possible, though most modern facilities can handle them.\n3. Separate aluminum cans from steel scrap to help collection riders and sorting facilities.\n\nCommon Metal Items:\n- Soda and beer cans (Aluminum)\n- Soup and vegetable cans (Steel/Tin)\n- Aluminum foil (if clean)\n- Metal lids from glass jars',
    ),
    TipModel(
      id: '4',
      title: 'Plastic Waste: The Resin Code Guide',
      category: 'Plastic',
      imageUrl: 'https://images.unsplash.com/photo-1595273670150-db0a3bf37b35?w=800',
      date: 'Oct 18, 2026',
      readingTime: '6 min',
      content: 'Plastics are categorized by resin codes (the numbers 1 through 7 inside the chasing arrows triangle). Not all plastics are created equal, and not all are accepted by local collection partners.\n\nCommonly accepted:\n- PET (1): Water and soda bottles. Highly recyclable.\n- HDPE (2): Milk jugs, shampoo bottles, and detergent containers.\n\nLess commonly accepted:\n- PVC (3): Pipes and certain wraps.\n- LDPE (4): Plastic bags and some squeezable bottles.\n- PP (5): Yogurt containers and bottle caps.\n- PS (6): Styrofoam and disposable cutlery.\n- Other (7): Mixed materials or specialized plastics.\n\nImportant step:\nAlways check the resin code on the bottom. Rinse bottles and remove caps (unless specified otherwise) before disposal.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(variant: LogoVariant.icon),
        ),
        title: Text(
          'EcoConnect',
          style: AppTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildHeaderCard(context),
            const SizedBox(height: 24),
            _buildWasteGrid(context),
            const SizedBox(height: 32),
            _buildProSortingTip(context),
            const SizedBox(height: 100), // Bottom nav padding
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.1,
              child: AppLogo(size: 120, variant: LogoVariant.icon, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Master Your Waste',
                style: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Every item sorted correctly is a step towards a healthier community and a cleaner planet.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWasteGrid(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int crossAxisCount = width > 600 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: allTips.length,
      itemBuilder: (context, index) {
        final tip = allTips[index];
        return _buildWasteGridItem(context, tip);
      },
    );
  }

  Widget _buildWasteGridItem(BuildContext context, TipModel tip) {
    IconData icon;
    switch (tip.category) {
      case 'Organic': icon = Icons.eco_outlined; break;
      case 'Paper': icon = Icons.article_outlined; break;
      case 'Metals': icon = Icons.precision_manufacturing_outlined; break;
      case 'Plastic': icon = Icons.eco_outlined; break;
      default: icon = Icons.lightbulb_outline;
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.tipDetails, arguments: tip),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerTheme.color ?? AppColors.gray200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              '${tip.category} Scraps',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                tip.content,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProSortingTip(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pro Sorting Tip',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.tipDetails, arguments: allTips[0]),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerTheme.color ?? AppColors.gray200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Icon(Icons.image_outlined, size: 50, color: Theme.of(context).disabledColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The "Rinse" Rule',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Food contamination can ruin entire batches of recycling. Always rinse your containers before putting them in the bin.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
