class TestLanguage {
  final String id;
  final String name;
  final String displayName;
  final String fileExtension;
  final String highlightId;

  const TestLanguage({
    required this.id,
    required this.name,
    required this.displayName,
    required this.fileExtension,
    required this.highlightId,
  });

  static const List<TestLanguage> supportedLanguages = [
    TestLanguage(
      id: 'python',
      name: 'Python',
      displayName: 'Python (pytest)',
      fileExtension: 'py',
      highlightId: 'python',
    ),
    TestLanguage(
      id: 'nodejs',
      name: 'NodeJS',
      displayName: 'NodeJS (Jest / Supertest)',
      fileExtension: 'js',
      highlightId: 'javascript',
    ),
    TestLanguage(
      id: 'java',
      name: 'Java',
      displayName: 'Java (RestAssured)',
      fileExtension: 'java',
      highlightId: 'java',
    ),
    TestLanguage(
      id: 'golang',
      name: 'GoLang',
      displayName: 'GoLang (Go testing)',
      fileExtension: 'go',
      highlightId: 'go',
    ),
    TestLanguage(
      id: 'php',
      name: 'PHP',
      displayName: 'PHP (PHPUnit)',
      fileExtension: 'php',
      highlightId: 'php',
    ),
  ];

  static TestLanguage get defaultLanguage => supportedLanguages.first;

  static TestLanguage fromId(String id) {
    return supportedLanguages.firstWhere(
      (lang) => lang.id == id,
      orElse: () => defaultLanguage,
    );
  }
}
