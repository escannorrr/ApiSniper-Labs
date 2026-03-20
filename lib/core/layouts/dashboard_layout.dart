import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_sidebar.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({
    super.key,
    required this.child,
  });

  String _getTitle(String route) {
    if (route.startsWith('/dashboard')) return 'Dashboard';
    if (route.startsWith('/projects')) return 'Projects';
    if (route.contains('/endpoints')) return 'Endpoint Explorer';
    if (route.startsWith('/tests')) return 'AI Test Generator';
    if (route.contains('/security')) return 'Security Analysis';
    if (route.startsWith('/settings')) return 'Project Settings';
    if (route.startsWith('/pricing')) return 'Upgrade Plan';
    if (route.startsWith('/checkout')) return 'Checkout';
    if (route.startsWith('/billing')) return 'Billing & Subscriptions';
    return 'APISniper Labs';
  }

  @override
  Widget build(BuildContext context) {
    // Basic responsiveness: hide sidebar on small screens
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final currentRoute = GoRouterState.of(context).uri.toString();
    final title = _getTitle(currentRoute);

    return Scaffold(
      drawer: isDesktop ? null : Drawer(child: AppSidebar(currentRoute: currentRoute)),
      body: Row(
        children: [
          if (isDesktop) ...[
            AppSidebar(currentRoute: currentRoute),
            const VerticalDivider(width: 1, thickness: 1),
          ],
          Expanded(
            child: Column(
              children: [
                AppBar(
                  leading: isDesktop
                      ? null
                      : Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                  title: Text(title),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {},
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Text('D', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
