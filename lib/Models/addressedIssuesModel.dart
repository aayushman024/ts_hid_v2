// Define a Dart class to represent the API response
class IssueResponse {
  final String userGroup;
  final List<Issue> issues;

  IssueResponse({
    required this.userGroup,
    required this.issues,
  });

  // Method to create an IssueResponse object from JSON data
  static IssueResponse fromJson(Map<String, dynamic> json) {
    return IssueResponse(
      userGroup: json['user_group'] ?? '',
      issues: (json['issues'] as List<dynamic>)
          .map((issueJson) => Issue.fromJson(issueJson))
          .toList(),
    );
  }

  // Method to convert IssueResponse object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'user_group': userGroup,
      'issues': issues.map((issue) => issue.toJson()).toList(),
    };
  }
}

// Define a Dart class to represent individual issues
class Issue {
  final int id;
  final String country;
  final String region;
  final String customer;
  final String technology;
  final String product;
  final String description;
  final String summary;
  final String status;
  final String severity;
  final String title;
  final String name;
  final String productFamily;
  final DateTime createdAt;
  final String ticket;
  final String problemTicket;
  final DateTime lastUpdated;
  final String softwareVersion;
  final bool wasReopened;

  Issue({
    required this.id,
    required this.country,
    required this.region,
    required this.customer,
    required this.technology,
    required this.product,
    required this.description,
    required this.summary,
    required this.status,
    required this.severity,
    required this.title,
    required this.name,
    required this.productFamily,
    required this.createdAt,
    required this.ticket,
    required this.problemTicket,
    required this.lastUpdated,
    required this.softwareVersion,
    required this.wasReopened,
  });

  // Method to create an Issue object from JSON data
  static Issue fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'] ?? 0,
      country: json['country'] ?? '',
      region: json['region'] ?? '',
      customer: json['customer'] ?? '',
      technology: json['technology'] ?? '',
      product: json['product'] ?? '',
      description: json['description'] ?? '',
      summary: json['summary'] ?? '',
      status: json['status'] ?? '',
      severity: json['severity'] ?? '',
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      productFamily: json['product_family'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      ticket: json['ticket'] ?? '',
      problemTicket: json['problem_ticket'] ?? '',
      lastUpdated: DateTime.parse(json['last_updated']),
      softwareVersion: json['software_version'] ?? '',
      wasReopened: json['was_reopened'] ?? false,
    );
  }

  // Method to convert Issue object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'region': region,
      'customer': customer,
      'technology': technology,
      'product': product,
      'description': description,
      'summary': summary,
      'status': status,
      'severity': severity,
      'title': title,
      'name': name,
      'product_family': productFamily,
      'created_at': createdAt.toIso8601String(),
      'ticket': ticket,
      'problem_ticket': problemTicket,
      'last_updated': lastUpdated.toIso8601String(),
      'software_version': softwareVersion,
      'was_reopened': wasReopened,
    };
  }
}
