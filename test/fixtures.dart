import 'package:global_explorer/features/countries/data/models/country_dto.dart';
import 'package:global_explorer/features/countries/domain/entities/country.dart';
import 'package:global_explorer/features/favourites/domain/entities/favorite_country_summary.dart';
import 'package:global_explorer/features/news/data/models/news_article_dto.dart';
import 'package:global_explorer/features/news/domain/entities/news_article.dart';

// ── Country ─────────────────────────────────────────────────────────────────

const tCountry = Country(
  cca3: 'DEU',
  cca2: 'DE',
  nameCommon: 'Germany',
  nameOfficial: 'Federal Republic of Germany',
  region: 'Europe',
  subregion: 'Western Europe',
  flagPng: 'https://flagcdn.com/w320/de.png',
  capital: ['Berlin'],
  population: 83240000,
  area: 357114.0,
  mapsOpenStreetMaps: 'https://www.openstreetmap.org/relation/51477',
);

const tCountry2 = Country(
  cca3: 'FRA',
  cca2: 'FR',
  nameCommon: 'France',
  nameOfficial: 'French Republic',
  region: 'Europe',
  subregion: 'Western Europe',
  flagPng: 'https://flagcdn.com/w320/fr.png',
  capital: ['Paris'],
  population: 67390000,
  area: 551695.0,
  mapsOpenStreetMaps: null,
);

final tCountryList = [tCountry, tCountry2];

final tCountryDto = CountryDto(
  cca3: 'DEU',
  cca2: 'DE',
  nameCommon: 'Germany',
  nameOfficial: 'Federal Republic of Germany',
  region: 'Europe',
  subregion: 'Western Europe',
  flagPng: 'https://flagcdn.com/w320/de.png',
  capital: const ['Berlin'],
  population: 83240000,
  area: 357114.0,
  mapsOpenStreetMaps: 'https://www.openstreetmap.org/relation/51477',
);

// ── News ─────────────────────────────────────────────────────────────────────

const tNewsArticle = NewsArticle(
  title: 'Germany wins the match',
  url: 'https://news.example.com/article/1',
  description: 'A great football match.',
  urlToImage: 'https://news.example.com/img/1.jpg',
  publishedAt: '2026-05-14T00:00:00Z',
  sourceName: 'Example News',
);

final tNewsArticleList = [tNewsArticle];

final tNewsArticleDto = NewsArticleDto(
  title: 'Germany wins the match',
  url: 'https://news.example.com/article/1',
  description: 'A great football match.',
  urlToImage: 'https://news.example.com/img/1.jpg',
  publishedAt: '2026-05-14T00:00:00Z',
  sourceName: 'Example News',
);

final tNewsApiJson = <String, dynamic>{
  'title': 'Germany wins the match',
  'url': 'https://news.example.com/article/1',
  'description': 'A great football match.',
  'urlToImage': 'https://news.example.com/img/1.jpg',
  'publishedAt': '2026-05-14T00:00:00Z',
  'source': {'name': 'Example News'},
};

// ── Favorites ────────────────────────────────────────────────────────────────

const tFavoriteSummary = FavoriteCountrySummary(
  cca3: 'DEU',
  nameCommon: 'Germany',
  flagPng: 'https://flagcdn.com/w320/de.png',
  region: 'Europe',
);

final tFavoriteList = [tFavoriteSummary];

// ── Photo ────────────────────────────────────────────────────────────────────

const tHeroImageUrl = 'https://images.pexels.com/photos/123/photo.jpeg';
