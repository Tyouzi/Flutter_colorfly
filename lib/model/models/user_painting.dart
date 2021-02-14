import 'dart:ui';

import 'package:flutter/foundation.dart';

import "user.dart";

@immutable
class UserPainting {
	final int id;
	final User user;
	final String templateId;
	final String url;
	final String thumbnailUrl;
	final int likes;
	final String createdTime;
	final int totalCommentCount;
	final List<dynamic> comments;

	const UserPainting({
		this.id,
		this.user,
		this.templateId,
		this.url,
		this.thumbnailUrl,
		this.likes,
		this.createdTime,
		this.totalCommentCount,
		this.comments,
	});

	@override
	String toString() {
		return 'UserPainting(id: $id, user: $user, templateId: $templateId, url: $url, thumbnailUrl: $thumbnailUrl, likes: $likes, createdTime: $createdTime, totalCommentCount: $totalCommentCount, comments: $comments)';
	}

	factory UserPainting.fromJson(Map<String, dynamic> json) {
		return UserPainting(
			id: json['id'] as int,
			user: json['user'] == null
					? null
					: User.fromJson(json['user'] as Map<String, dynamic>),
			templateId: json['template_id'] as String,
			url: json['url'] as String,
			thumbnailUrl: json['thumbnail_url'] as String,
			likes: json['likes'] as int,
			createdTime: json['created_time'] as String,
			totalCommentCount: json['total_comment_count'] as int,
			comments: json['comments'] as List<dynamic>,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'user': user?.toJson(),
			'template_id': templateId,
			'url': url,
			'thumbnail_url': thumbnailUrl,
			'likes': likes,
			'created_time': createdTime,
			'total_comment_count': totalCommentCount,
			'comments': comments,
		};
	}

	UserPainting copyWith({
		int id,
		User user,
		String templateId,
		String url,
		String thumbnailUrl,
		int likes,
		String createdTime,
		int totalCommentCount,
		List<dynamic> comments,
	}) {
		return UserPainting(
			id: id ?? this.id,
			user: user ?? this.user,
			templateId: templateId ?? this.templateId,
			url: url ?? this.url,
			thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
			likes: likes ?? this.likes,
			createdTime: createdTime ?? this.createdTime,
			totalCommentCount: totalCommentCount ?? this.totalCommentCount,
			comments: comments ?? this.comments,
		);
	}

	@override
	bool operator ==(Object o) =>
			o is UserPainting &&
			identical(o.id, id) &&
			identical(o.user, user) &&
			identical(o.templateId, templateId) &&
			identical(o.url, url) &&
			identical(o.thumbnailUrl, thumbnailUrl) &&
			identical(o.likes, likes) &&
			identical(o.createdTime, createdTime) &&
			identical(o.totalCommentCount, totalCommentCount) &&
			identical(o.comments, comments);

	@override
	int get hashCode {
		return hashValues(
			id,
			user,
			templateId,
			url,
			thumbnailUrl,
			likes,
			createdTime,
			totalCommentCount,
			comments,
		);
	}
}
