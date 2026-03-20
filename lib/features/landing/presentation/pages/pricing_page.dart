import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  int? _selectedPlanIndex;

  void _handleChoosePlan(BuildContext context, String planName) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.go('/checkout');
    } else {
      // Use go for web-style navigation
      context.go('/login', extra: '/pricing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00FF9C)),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'APISniper Labs',
          style: GoogleFonts.orbitron(
            color: const Color(0xFF00FF9C),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Strategic API Defense Plans',
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Choose your tactical tier for API testing and security.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white60,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 64),
              Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: [
                  _PricingCard(
                    name: 'Free',
                    price: '0',
                    isSelected: _selectedPlanIndex == 0,
                    features: const [
                      '5 API Projects',
                      'Basic Endpoint Discovery',
                      '100 AI Test Generations/mo',
                      'Community Support',
                    ],
                    onTap: () => setState(() => _selectedPlanIndex = 0),
                    onPressed: () => _handleChoosePlan(context, 'Free'),
                  ),
                  _PricingCard(
                    name: 'Pro',
                    price: '49',
                    isRecommended: true,
                    isSelected: _selectedPlanIndex == 1,
                    features: const [
                      'Unlimited API Projects',
                      'Deep Scan Architecture',
                      '10,000 AI Test Generations/mo',
                      'Security Vulnerability Analysis',
                      'Priority Ops Support',
                    ],
                    onTap: () => setState(() => _selectedPlanIndex = 1),
                    onPressed: () => _handleChoosePlan(context, 'Pro'),
                  ),
                  _PricingCard(
                    name: 'Enterprise',
                    price: 'Custom',
                    isSelected: _selectedPlanIndex == 2,
                    features: const [
                      'Custom Deployment',
                      'Full Red-Team API Analysis',
                      'Unlimited Generations',
                      '24/7 Dedicated Commander Support',
                      'Legal & Compliance Reporting',
                    ],
                    buttonLabel: 'Contact Sales',
                    onTap: () => setState(() => _selectedPlanIndex = 2),
                    onPressed: () => _handleChoosePlan(context, 'Enterprise'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PricingCard extends StatefulWidget {
  final String name;
  final String price;
  final List<String> features;
  final VoidCallback onPressed;
  final VoidCallback onTap;
  final bool isRecommended;
  final bool isSelected;
  final String buttonLabel;

  const _PricingCard({
    required this.name,
    required this.price,
    required this.features,
    required this.onPressed,
    required this.onTap,
    this.isRecommended = false,
    this.isSelected = false,
    this.buttonLabel = 'Choose Plan',
  });

  @override
  State<_PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<_PricingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 350,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFF13181F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected || _isHovered
                  ? const Color(0xFF00FF9C)
                  : Colors.white.withOpacity(0.05),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (widget.isSelected)
                BoxShadow(
                  color: const Color(0xFF00FF9C).withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF9C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'MOST POPULAR',
                    style: GoogleFonts.jetBrainsMono(
                      color: const Color(0xFF00FF9C),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Text(
                widget.name,
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.price == 'Custom' ? 'Custom' : '₹${widget.price}',
                    style: GoogleFonts.orbitron(
                      color: const Color(0xFF00FF9C),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.price != 'Custom')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
                      child: Text(
                        '/mo',
                        style: GoogleFonts.inter(color: Colors.white24, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              ...widget.features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Color(0xFF00FF9C), size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            f,
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    onPressed: widget.onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isSelected || (widget.isRecommended && !_isHovered)
                          ? const Color(0xFF00FF9C)
                          : Colors.white12,
                      foregroundColor: widget.isSelected || (widget.isRecommended && !_isHovered)
                          ? Colors.black
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(widget.buttonLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
