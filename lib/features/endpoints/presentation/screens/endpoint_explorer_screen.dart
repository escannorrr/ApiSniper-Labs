import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/command_loader.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/code_viewer.dart';

import '../bloc/endpoints_bloc.dart';

class EndpointExplorerScreen extends StatefulWidget {
  final String? projectId;
  const EndpointExplorerScreen({super.key, this.projectId});

  @override
  State<EndpointExplorerScreen> createState() => _EndpointExplorerScreenState();
}

class _EndpointExplorerScreenState extends State<EndpointExplorerScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      context.read<EndpointsBloc>().add(LoadEndpointsRequested(projectId: widget.projectId!));
    }
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET': return Colors.blue;
      case 'POST': return Colors.green;
      case 'PUT': return Colors.orange;
      case 'DELETE': return Colors.red;
      case 'PATCH': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EndpointsBloc, EndpointsState>(
      builder: (context, state) {
        if (state is EndpointsLoading) {
          return const CommandLoader(message: 'Analyzing API specifications...');
        } else if (state is EndpointsError) {
          return AppError(
            message: state.message,
            onRetry: widget.projectId == null ? null : () => context.read<EndpointsBloc>().add(LoadEndpointsRequested(projectId: widget.projectId!)),
          );
        } else if (state is EndpointsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(32),
            itemCount: state.endpoints.length,
            itemBuilder: (context, index) {
              final endpoint = state.endpoints[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 24),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  title: Row(
                    children: [
                      Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: _getMethodColor(endpoint.method).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getMethodColor(endpoint.method).withOpacity(0.5)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          endpoint.method,
                          style: TextStyle(
                            color: _getMethodColor(endpoint.method),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          endpoint.path,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 96),
                    child: Text(endpoint.description),
                  ),
                  children: [
                    const Divider(),
                    Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (endpoint.parameters.isNotEmpty) ...[
                             Text(
                              'Parameters',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ...endpoint.parameters.map((param) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(param.type, style: const TextStyle(fontSize: 12)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(param.name, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'monospace')),
                                  if (param.isRequired) ...[
                                    const SizedBox(width: 8),
                                    const Text('*required', style: TextStyle(color: Colors.red, fontSize: 12)),
                                  ]
                                ],
                              ),
                            )),
                            const SizedBox(height: 24),
                          ],
                          
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (endpoint.requestSchema.isNotEmpty)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Request Schema', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 200,
                                        child: CodeViewer(
                                          code: const JsonEncoder.withIndent('  ').convert(endpoint.requestSchema),
                                          language: 'json',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (endpoint.requestSchema.isNotEmpty)
                                const SizedBox(width: 24),
                              if (endpoint.responseSchema.isNotEmpty)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Response Schema', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 200,
                                        child: CodeViewer(
                                          code: const JsonEncoder.withIndent('  ').convert(endpoint.responseSchema),
                                          language: 'json',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
