import 'dart:convert';

import 'client.dart';
import '../models/checkpoint_config.dart';
import '../models/thread.dart';

/// Extension providing thread management functionality for [LangGraphClient].
///
/// This extension enables creation, searching, state management, and copying of
/// LangGraph threads, which are containers for persistent state and message
/// history used by assistants during runs.
extension ThreadApi on LangGraphClient {
  /// Creates a new thread for storing state and message history.
  ///
  /// A thread is a container that maintains the state for graph execution
  /// and provides persistence across multiple runs.
  ///
  /// [threadId] is an optional custom ID for the thread. If not provided, one will be generated.
  /// [metadata] is optional user-provided metadata for the thread.
  /// [ifExists] determines behavior when a thread with the same ID already exists. Options are 'raise', 'error', or 'return_existing'.
  ///
  /// Returns the created [Thread] object.
  /// Throws [LangGraphApiException] if the request fails.
  Future<Thread> createThread({
    String? threadId,
    Map<String, dynamic>? metadata,
    String ifExists = 'raise',
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/threads'),
        headers: headers,
        body: jsonEncode({
          if (threadId != null) 'thread_id': threadId,
          if (metadata != null) 'metadata': metadata,
          'if_exists': ifExists,
        }),
      );

      if (response.statusCode == 200) {
        return Thread.fromJson(jsonDecode(response.body));
      }
      throw LangGraphApiException(
        'Failed to create thread',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to create thread: $e');
    }
  }

  /// Searches for threads matching the specified criteria.
  ///
  /// This method allows filtering threads by metadata, values, and status.
  ///
  /// [metadata] optional metadata filter to match against thread metadata.
  /// [values] optional filter to match against thread state values.
  /// [status] optional filter for thread status.
  /// [limit] maximum number of results to return (default: 10).
  /// [offset] number of results to skip for pagination (default: 0).
  ///
  /// Returns a list of [Thread] objects matching the search criteria.
  /// Throws [LangGraphApiException] if the request fails.
  Future<List<Thread>> searchThreads({
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? values,
    String? status,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/threads/search'),
        headers: headers,
        body: jsonEncode({
          if (metadata != null) 'metadata': metadata,
          if (values != null) 'values': values,
          if (status != null) 'status': status,
          'limit': limit,
          'offset': offset,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Thread.fromJson(json)).toList();
      }
      throw LangGraphApiException(
        'Failed to search threads',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to search threads: $e');
    }
  }

  /// Retrieves the current state of a thread.
  ///
  /// The thread state includes all values that have been stored in the thread,
  /// which represent the current state of the graph execution.
  ///
  /// [threadId] is the unique identifier of the thread to retrieve state for.
  ///
  /// Returns the current [ThreadState] object for the specified thread.
  /// Throws [LangGraphApiException] if the thread is not found or the request fails.
  Future<ThreadState> getThreadState(String threadId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/threads/$threadId/state'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return ThreadState.fromJson(jsonDecode(response.body));
      }
      throw LangGraphApiException(
        'Failed to get thread state',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to get thread state: $e');
    }
  }

  /// Updates the state of a thread with new values.
  ///
  /// This method allows modifying the values stored in a thread, effectively
  /// changing the state of the graph execution.
  ///
  /// [threadId] is the unique identifier of the thread to update.
  /// [values] new values to store in the thread state.
  /// [checkpoint] optional checkpoint configuration for versioning thread state.
  /// [asNode] optional node name to attribute the state change to.
  ///
  /// Returns a map containing the updated thread state values.
  /// Throws [LangGraphApiException] if the thread is not found or the request fails.
  Future<Map<String, dynamic>> updateThreadState(
    String threadId, {
    dynamic values,
    CheckpointConfig? checkpoint,
    String? asNode,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/threads/$threadId/state'),
        headers: headers,
        body: jsonEncode({
          if (values != null) 'values': values,
          if (checkpoint != null) 'checkpoint': checkpoint.toJson(),
          if (asNode != null) 'as_node': asNode,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw LangGraphApiException(
        'Failed to update thread state',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to update thread state: $e');
    }
  }

  /// Retrieves the history of state changes for a thread.
  ///
  /// This method allows accessing previous states of a thread, showing
  /// how the thread state has evolved over time.
  ///
  /// [threadId] is the unique identifier of the thread to retrieve history for.
  /// [limit] maximum number of state changes to return (default: 10).
  /// [before] optional timestamp to retrieve history before a specific point in time.
  ///
  /// Returns a list of [ThreadState] objects representing the thread's state history.
  /// Throws [LangGraphApiException] if the thread is not found or the request fails.
  Future<List<ThreadState>> getThreadHistory(
    String threadId, {
    int limit = 10,
    String? before,
  }) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
        if (before != null) 'before': before,
      };

      final response = await client.get(
        Uri.parse('$baseUrl/threads/$threadId/history')
            .replace(queryParameters: queryParams),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ThreadState.fromJson(json)).toList();
      }
      throw LangGraphApiException(
        'Failed to get thread history',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to get thread history: $e');
    }
  }

  /// Creates a new thread that is a copy of an existing thread.
  ///
  /// This method duplicates a thread, including its current state,
  /// which is useful for creating branches or testing different
  /// scenarios from the same starting point.
  ///
  /// [threadId] is the unique identifier of the thread to copy.
  ///
  /// Returns the newly created [Thread] object that is a copy of the original.
  /// Throws [LangGraphApiException] if the thread is not found or the request fails.
  Future<Thread> copyThread(String threadId) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/threads/$threadId/copy'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Thread.fromJson(jsonDecode(response.body));
      }
      throw LangGraphApiException(
        'Failed to copy thread',
        response.statusCode,
      );
    } catch (e) {
      if (e is LangGraphApiException) rethrow;
      throw LangGraphApiException('Failed to copy thread: $e');
    }
  }
}
