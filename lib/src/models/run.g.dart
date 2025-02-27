// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Run _$RunFromJson(Map<String, dynamic> json) => Run(
      runId: json['run_id'] as String,
      threadId: json['thread_id'] as String,
      assistantId: json['assistant_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      kwargs: json['kwargs'] as Map<String, dynamic>,
      multitaskStrategy: json['multitask_strategy'] as String,
    );

Map<String, dynamic> _$RunToJson(Run instance) => <String, dynamic>{
      'run_id': instance.runId,
      'thread_id': instance.threadId,
      'assistant_id': instance.assistantId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'status': instance.status,
      'metadata': instance.metadata,
      'kwargs': instance.kwargs,
      'multitask_strategy': instance.multitaskStrategy,
    };

RunCreateStateful _$RunCreateStatefulFromJson(Map<String, dynamic> json) =>
    RunCreateStateful(
      assistantId: json['assistant_id'] as String,
      input: json['input'] as Map<String, dynamic>?,
      command: json['command'] == null
          ? null
          : Command.fromJson(json['command'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
      config: json['config'] == null
          ? null
          : Config.fromJson(json['config'] as Map<String, dynamic>),
      webhook: json['webhook'] as String?,
      interruptBefore: json['interrupt_before'],
      interruptAfter: json['interrupt_after'],
      streamMode: json['stream_mode'] ?? 'messages',
      streamSubgraphs: json['stream_subgraphs'] as bool? ?? false,
      onDisconnect: json['on_disconnect'] as String? ?? 'cancel',
      feedbackKeys: (json['feedback_keys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      multitaskStrategy: json['multitask_strategy'] as String? ?? 'reject',
      ifNotExists: json['if_not_exists'] as String? ?? 'reject',
      afterSeconds: (json['after_seconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RunCreateStatefulToJson(RunCreateStateful instance) =>
    <String, dynamic>{
      'assistant_id': instance.assistantId,
      if (instance.input case final value?) 'input': value,
      if (instance.command?.toJson() case final value?) 'command': value,
      if (instance.metadata case final value?) 'metadata': value,
      if (instance.config?.toJson() case final value?) 'config': value,
      if (instance.webhook case final value?) 'webhook': value,
      if (instance.interruptBefore case final value?) 'interrupt_before': value,
      if (instance.interruptAfter case final value?) 'interrupt_after': value,
      if (instance.streamMode case final value?) 'stream_mode': value,
      'stream_subgraphs': instance.streamSubgraphs,
      'on_disconnect': instance.onDisconnect,
      if (instance.feedbackKeys case final value?) 'feedback_keys': value,
      'multitask_strategy': instance.multitaskStrategy,
      'if_not_exists': instance.ifNotExists,
      if (instance.afterSeconds case final value?) 'after_seconds': value,
    };

RunCreateStateless _$RunCreateStatelessFromJson(Map<String, dynamic> json) =>
    RunCreateStateless(
      assistantId: json['assistant_id'] as String,
      input: json['input'] as Map<String, dynamic>?,
      command: json['command'] == null
          ? null
          : Command.fromJson(json['command'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
      config: json['config'] == null
          ? null
          : Config.fromJson(json['config'] as Map<String, dynamic>),
      webhook: json['webhook'] as String?,
      interruptBefore: json['interrupt_before'],
      interruptAfter: json['interrupt_after'],
      streamMode: json['stream_mode'] ?? 'values',
      feedbackKeys: (json['feedback_keys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      streamSubgraphs: json['stream_subgraphs'] as bool? ?? false,
      onCompletion: json['on_completion'] as String? ?? 'delete',
      onDisconnect: json['on_disconnect'] as String? ?? 'cancel',
      afterSeconds: (json['after_seconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RunCreateStatelessToJson(RunCreateStateless instance) =>
    <String, dynamic>{
      'assistant_id': instance.assistantId,
      if (instance.input case final value?) 'input': value,
      if (instance.command?.toJson() case final value?) 'command': value,
      if (instance.metadata case final value?) 'metadata': value,
      if (instance.config?.toJson() case final value?) 'config': value,
      if (instance.webhook case final value?) 'webhook': value,
      if (instance.interruptBefore case final value?) 'interrupt_before': value,
      if (instance.interruptAfter case final value?) 'interrupt_after': value,
      if (instance.streamMode case final value?) 'stream_mode': value,
      if (instance.feedbackKeys case final value?) 'feedback_keys': value,
      'stream_subgraphs': instance.streamSubgraphs,
      'on_completion': instance.onCompletion,
      'on_disconnect': instance.onDisconnect,
      if (instance.afterSeconds case final value?) 'after_seconds': value,
    };
