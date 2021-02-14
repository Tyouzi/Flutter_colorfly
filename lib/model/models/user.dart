import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class User {
	final String id;
	final String username;
	final String profilePicture;

	const User({
		this.id,
		this.username,
		this.profilePicture,
	});

	@override
	String toString() {
		return 'User(id: $id, username: $username, profilePicture: $profilePicture)';
	}

	factory User.fromJson(Map<String, dynamic> json) {
		return User(
			id: json['id'] as String,
			username: json['username'] as String,
			profilePicture: json['profile_picture'] as String,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'username': username,
			'profile_picture': profilePicture,
		};
	}

	User copyWith({
		String id,
		String username,
		String profilePicture,
	}) {
		return User(
			id: id ?? this.id,
			username: username ?? this.username,
			profilePicture: profilePicture ?? this.profilePicture,
		);
	}

	@override
	bool operator ==(Object o) =>
			o is User &&
			identical(o.id, id) &&
			identical(o.username, username) &&
			identical(o.profilePicture, profilePicture);

	@override
	int get hashCode => hashValues(id, username, profilePicture);
}
