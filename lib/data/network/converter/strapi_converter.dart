class StrapiConverter {
  /// Flatten một item Strapi (unwrap id + attributes)
  static Map<String, dynamic> flattenItem(dynamic item) {
    if (item == null) return {};
    if (item is Map<String, dynamic>) {
      final id = item['id'];
      final attributes = item['attributes'] ?? {};
      final result = <String, dynamic>{'id': id, ...attributes};

      // Xử lý các relation (user, schedules, ...)
      attributes.forEach((key, value) {
        if (value is Map && value.containsKey('data')) {
          if (value['data'] is Map) {
            result[key] = flattenItem(value['data']);
          } else if (value['data'] is List) {
            result[key] = value['data'].map((e) => flattenItem(e)).toList();
          } else if (value['data'] == null) {
            result[key] = null;
          }
        }
      });

      return result;
    }
    return {};
  }

  /// Flatten response Strapi v4 (list hoặc single)
  static dynamic flattenResponse(dynamic data) {
    if (data is List) {
      return data.map((item) => flattenItem(item)).toList();
    }
    if (data is Map && data.containsKey('data')) {
      final d = data['data'];
      if (d is List) {
        return d.map((item) => flattenItem(item)).toList();
      } else {
        return flattenItem(d);
      }
    }
    return data;
  }
}