import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PortionPage extends StatelessWidget {
  final int portions;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onNext;

  const PortionPage({
    super.key,
    required this.portions,
    required this.onMinus,
    required this.onPlus,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Buat Rekomendasi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // Judul
              const Text(
                'Kamu memasak untuk\nberapa orang?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 35),

              _buildPlates(),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(
                    icon: Icons.remove,
                    onPressed: onMinus,
                  ),

                  const SizedBox(width: 28),

                  SizedBox(
                    width: 55,
                    child: Text(
                      '$portions',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 28),

                  _buildCircleButton(
                    icon: Icons.add,
                    onPressed: onPlus,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                portions == 1 ? '1 porsi' : '$portions porsi',
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Tombol berikutnya
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Berikutnya',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlates() {
    return SizedBox(
      height: 150,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            portions,
            (index) => _buildPlate(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlate() {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: AppColors.coral.withValues(alpha: 0.35),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgPage,
            border: Border.all(
              color: AppColors.coral.withValues(alpha: 0.25),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.restaurant,
            size: 30,
            color: AppColors.coral,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.coral,
            boxShadow: [
              BoxShadow(
                color: AppColors.coral.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }
}