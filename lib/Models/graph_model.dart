class GraphModel {
  final String userGroup;
  final Counts counts;

  GraphModel({
    required this.userGroup,
    required this.counts,
  });

  factory GraphModel.fromJson(Map<String, dynamic> json) {
    return GraphModel(
      userGroup: json['user_group'],
      counts: Counts.fromJson(json['counts']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_group': userGroup,
      'counts': counts.toJson(),
    };
  }
}

class Counts {
  final int criticalCount;
  final int amberCount;
  final int trackingCount;
  final int totalCount;
  final int closedIssuesCount;
  final int resolvedIssuesCount;
  final int totalIssuesCount;
  final String hottestCountry;
  final int hottestIssueCount;
  final String maxSeverity;
  final int severityIssueCount;
  final String commonProduct;
  final int productIssueCount;
  final String maxStatus;
  final int statusIssueCount;

  Counts({
    required this.criticalCount,
    required this.amberCount,
    required this.trackingCount,
    required this.totalCount,
    required this.closedIssuesCount,
    required this.resolvedIssuesCount,
    required this.totalIssuesCount,
    required this.hottestCountry,
    required this.hottestIssueCount,
    required this.maxSeverity,
    required this.severityIssueCount,
    required this.commonProduct,
    required this.productIssueCount,
    required this.maxStatus,
    required this.statusIssueCount,
  });

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      criticalCount: json['critical_count'],
      amberCount: json['amber_count'],
      trackingCount: json['tracking_count'],
      totalCount: json['total_count'],
      closedIssuesCount: json['closed_issues_count'],
      resolvedIssuesCount: json['resolved_issues_count'],
      totalIssuesCount: json['total_issues_count'],
      hottestCountry: json['hottest_country'],
      hottestIssueCount: json['hottest_issue_count'],
      maxSeverity: json['max_severity'],
      severityIssueCount: json['severity_issue_count'],
      commonProduct: json['common_product'],
      productIssueCount: json['product_issue_count'],
      maxStatus: json['max_status'],
      statusIssueCount: json['status_issue_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'critical_count': criticalCount,
      'amber_count': amberCount,
      'tracking_count': trackingCount,
      'total_count': totalCount,
      'closed_issues_count': closedIssuesCount,
      'resolved_issues_count': resolvedIssuesCount,
      'total_issues_count': totalIssuesCount,
      'hottest_country': hottestCountry,
      'hottest_issue_count': hottestIssueCount,
      'max_severity': maxSeverity,
      'severity_issue_count': severityIssueCount,
      'common_product': commonProduct,
      'product_issue_count': productIssueCount,
      'max_status': maxStatus,
      'status_issue_count': statusIssueCount,
    };
  }
}
