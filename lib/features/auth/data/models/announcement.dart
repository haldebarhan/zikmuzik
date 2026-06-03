enum AnnouncementStatus {
  ARCHIVED,
  DRAFT,
  PENDING_APPROVAL,
  PUBLISHED,
  REJECTED,
}

class Announcement {
  final int id;
  final String title;
  final String description;
  final int? price;
  final String? priceUnit;
  final bool negotiable;
  final String? location;
  final String? country;
  final String? city;
  final List<String> images;
  final List<String> videos;
  final List<String> audios;
  final AnnouncementStatus status;
  final bool isPublished;
  final bool isHighlighted;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final DateTime? expiresAt;
  final Category category;
  final Owner owner;
  final List<FieldValue> fieldValues;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.negotiable,
    required this.images,
    required this.videos,
    required this.audios,
    required this.status,
    required this.isHighlighted,
    required this.isPublished,
    required this.views,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
    required this.fieldValues,
    this.price,
    this.priceUnit,
    this.location,
    this.country,
    this.city,
    this.publishedAt,
    this.expiresAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      priceUnit: json['priceUnit'],
      negotiable: json['negotiable'] ?? false,
      location: json['location'],
      country: json['country'],
      city: json['city'],
      images: List<String>.from(json['images'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      audios: List<String>.from(json['audios'] ?? []),
      status: AnnouncementStatus.values.byName(json['status'] ?? 'DRAFT'),
      isPublished: json['isPublished'] ?? false,
      isHighlighted: json['isHighlighted'] ?? false,
      views: json['views'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : null,
      category: Category.fromJson(json['category']),
      owner: Owner.fromJson(json['owner']),
      fieldValues:
          (json['fieldValues'] as List<dynamic>?)
              ?.map((fv) => FieldValue.fromJson(fv as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String? icon;

  Category({
    required this.id,
    this.icon,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      icon: json['icon'],
    );
  }
}

class Owner {
  final int id;
  final String? displayName;
  final String? profileImage;
  final int? totalAnnouncement;
  final String badge;

  Owner({
    required this.id,
    required this.badge,
    this.displayName,
    this.profileImage,
    this.totalAnnouncement,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      displayName: json['displayName'],
      profileImage: json['profileImage'],
      totalAnnouncement: json['totalAnnouncement'],
      badge: json['badge'],
    );
  }
}

class Field {
  final String key;
  final String label;
  final String inputType;

  Field({required this.key, required this.label, required this.inputType});

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      key: json['key'],
      label: json['label'],
      inputType: json['inputType'],
    );
  }
}

class Option {
  final String label;
  final String value;

  Option({required this.label, required this.value});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(label: json['label'], value: json['value']);
  }
}

class FieldValue {
  final Field field;

  final String? valueText;
  final int? valueNumber;
  final bool? valueBoolean;
  final DateTime? valueDate;
  final List<Option>? options;

  FieldValue({
    required this.field,
    this.valueText,
    this.valueNumber,
    this.valueBoolean,
    this.valueDate,
    this.options,
  });

  factory FieldValue.fromJson(Map<String, dynamic> json) {
    return FieldValue(
      field: Field.fromJson(json['field']),
      valueText: json['valueText'],
      valueNumber: json['valueNumber'],
      valueBoolean: json['valueBoolean'],
      valueDate: json['valueDate'],
      options: (json['options'] as List<dynamic>?)
          ?.map((o) => Option.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}
