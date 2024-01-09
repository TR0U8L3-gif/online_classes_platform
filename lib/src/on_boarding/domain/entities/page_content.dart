import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/assets/assets.dart';

class PageContent extends Equatable {
  const PageContent(
      {required this.imageUrl, required this.title, required this.description,});

  factory PageContent.first() {
    return const PageContent(
      imageUrl: Assets.vectorsCasualReading,
      title: 'Brand new curriculum',
      description: 'First platform designed by top professors',
    );
  }

  factory PageContent.second() {
    return const PageContent(
      imageUrl: Assets.vectorsCasualLife,
      title: 'Fun atmosphere',
      description: 'First platform designed by top professors',
    );
  }

  factory PageContent.third() {
    return const PageContent(
      imageUrl: Assets.vectorsCasualMeditationScience,
      title: 'Easy to join and learn',
      description: 'First platform designed by top professors',
    );
  }
  final String imageUrl;
  final String title;
  final String description;

  @override
  List<Object?> get props => [imageUrl, title, description];
}
