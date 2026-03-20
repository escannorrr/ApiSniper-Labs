import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey _featuresKey = GlobalKey();

  void _scrollToFeatures() {
    Scrollable.ensureVisible(
      _featuresKey.currentContext!,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _handleStartSniping(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Navbar(
              onFeaturesPressed: _scrollToFeatures,
              onPricingPressed: () => context.go('/pricing'),
              onDocsPressed: () => context.go('/docs'),
              onLoginPressed: () => context.go('/login'),
              onStartSnipingPressed: () => _handleStartSniping(context),
            ),
            HeroSection(
              onLoginPressed: () => context.go('/login'),
              onStartSnipingPressed: () => _handleStartSniping(context),
            ),
            FeaturesSection(key: _featuresKey),
            const HowItWorksSection(),
            CTASection(
              onStartSnipingPressed: () => _handleStartSniping(context),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _Navbar extends StatelessWidget {
  final VoidCallback onFeaturesPressed;
  final VoidCallback onPricingPressed;
  final VoidCallback onDocsPressed;
  final VoidCallback onLoginPressed;
  final VoidCallback onStartSnipingPressed;

  const _Navbar({
    required this.onFeaturesPressed,
    required this.onPricingPressed,
    required this.onDocsPressed,
    required this.onLoginPressed,
    required this.onStartSnipingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          Text(
            'APISniper Labs',
            style: GoogleFonts.orbitron(
              color: const Color(0xFF00FF9C),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          if (MediaQuery.of(context).size.width > 900) ...[
            _NavLink(label: 'Features', onPressed: onFeaturesPressed),
            _NavLink(label: 'Pricing', onPressed: onPricingPressed),
            _NavLink(label: 'Docs', onPressed: onDocsPressed),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onStartSnipingPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF9C),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('Start Sniping', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF00FF9C)),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NavLink({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback onStartSnipingPressed;

  const HeroSection({
    super.key,
    required this.onLoginPressed,
    required this.onStartSnipingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF9C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xFF00FF9C).withOpacity(0.3)),
            ),
            child: Text(
              'v1.0 IS NOW LIVE',
              style: GoogleFonts.jetBrainsMono(
                color: const Color(0xFF00FF9C),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Snipe Every API Endpoint',
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width > 600 ? 64 : 40,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Upload OpenAPI / Swagger specs and let AI discover endpoints, generate automated API tests, and analyze API security vulnerabilities.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white60,
                fontSize: 18,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onStartSnipingPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF9C),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 20,
                  shadowColor: const Color(0xFF00FF9C).withOpacity(0.5),
                ),
                child: const Text(
                  'Start Sniping APIs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      child: Column(
        children: [
          Text(
            'Tactical API Intelligence',
            style: GoogleFonts.orbitron(
              color: const Color(0xFF00FF9C),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: const [
              _FeatureCard(
                title: 'Endpoint Discovery',
                description: 'Automatically extract and visualize endpoints from API specifications.',
                icon: Icons.radar,
              ),
              _FeatureCard(
                title: 'AI Test Generation',
                description: 'Generate automated API tests in multiple programming languages.',
                icon: Icons.code,
              ),
              _FeatureCard(
                title: 'Security Analysis',
                description: 'Identify vulnerabilities and security risks in APIs.',
                icon: Icons.security,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 350,
        height: 250,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF13181F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered 
                ? const Color(0xFF00FF9C) 
                : const Color(0xFF00FF9C).withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: const Color(0xFF00FF9C).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, color: const Color(0xFF00FF9C), size: 32),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.description,
              style: GoogleFonts.inter(
                color: Colors.white60,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
      ),
      child: Column(
        children: [
          Text(
            'Mission Protocol',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 80),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _StepItem(step: '01', title: 'Upload API Spec'),
                _StepDivider(),
                _StepItem(step: '02', title: 'Discover Endpoints'),
                _StepDivider(),
                _StepItem(step: '03', title: 'Generate Tests Instantly'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String step;
  final String title;

  const _StepItem({required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          step,
          style: GoogleFonts.jetBrainsMono(
            color: const Color(0xFF00FF9C),
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  const _StepDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: const Color(0xFF00FF9C).withOpacity(0.3),
    );
  }
}

class CTASection extends StatelessWidget {
  final VoidCallback onStartSnipingPressed;

  const CTASection({super.key, required this.onStartSnipingPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
      child: Column(
        children: [
          Text(
            'Ready to Hunt APIs?',
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width > 600 ? 48 : 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: onStartSnipingPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF9C),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Start Sniping APIs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Center(
        child: Text(
          '© 2026 APISniper Labs',
          style: GoogleFonts.inter(
            color: Colors.white24,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
