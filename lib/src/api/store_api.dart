import 'dart:convert';

import 'client.dart';
import '../models/store.dart';

/// Extension providing store functionality for [LangGraphClient].
///
/// The Store API provides a key-value data store organized by namespaces,
/// which can be used to persist arbitrary data for LangGraph applications.
extension StoreApi on LangGraphClient {
  /// Creates a new item in the store.
  ///
  /// [request] contains the namespace, ID, data and optional metadata for the item.
  ///
  /// Returns the created [StoreItem].
  /// Throws [LangGraphApiException] if the request fails.
  Future<StoreItem> createStoreItem(StoreItemCreate request) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/store/items'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return StoreItem.fromJson(jsonDecode(response.body));
      }
      throw LangGraphApiException(
        'Failed to create store item',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to create store item: $e');
    }
  }

  /// Gets an item from the store by namespace and ID.
  ///
  /// [namespace] is the namespace the item belongs to.
  /// [id] is the unique identifier of the item within its namespace.
  ///
  /// Returns the requested [StoreItem].
  /// Throws [LangGraphApiException] if the item is not found or the request fails.
  Future<StoreItem> getStoreItem(String namespace, String id) async {
    try {
      final queryParams = {
        'namespace': namespace,
        'id': id,
      };

      final response = await client.get(
        Uri.parse('$baseUrl/store/items').replace(queryParameters: queryParams),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return StoreItem.fromJson(jsonDecode(response.body));
      }
      throw LangGraphApiException(
        'Failed to get store item',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to get store item: $e');
    }
  }

  /// Searches for items in the store.
  ///
  /// [request] contains the namespace and optional metadata filters.
  ///
  /// Returns a list of [StoreItem] objects matching the search criteria.
  /// Throws [LangGraphApiException] if the request fails.
  Future<List<StoreItem>> searchStoreItems(StoreItemSearch request) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/store/items/search'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => StoreItem.fromJson(json)).toList();
      }
      throw LangGraphApiException(
        'Failed to search store items',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to search store items: $e');
    }
  }

  /// Deletes an item from the store.
  ///
  /// [namespace] is the namespace the item belongs to.
  /// [id] is the unique identifier of the item within its namespace.
  ///
  /// Returns void on successful deletion.
  /// Throws [LangGraphApiException] if the item is not found or the request fails.
  Future<void> deleteStoreItem(String namespace, String id) async {
    try {
      final queryParams = {
        'namespace': namespace,
        'id': id,
      };

      final response = await client.delete(
        Uri.parse('$baseUrl/store/items').replace(queryParameters: queryParams),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw LangGraphApiException(
          'Failed to delete store item',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to delete store item: $e');
    }
  }

  /// Lists all namespaces in the store.
  ///
  /// Returns a list of namespace names.
  /// Throws [LangGraphApiException] if the request fails.
  Future<List<String>> listStoreNamespaces() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/store/namespaces'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.cast<String>();
        } else if (data is Map && data.containsKey('namespaces')) {
          return (data['namespaces'] as List).cast<String>();
        }
        return [];
      }
      throw LangGraphApiException(
        'Failed to list store namespaces',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to list store namespaces: $e');
    }
  }
}
