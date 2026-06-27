import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripmate/core/providers/core_providers.dart';
import 'package:tripmate/features/friends/data/datasources/friends_dao.dart';
import 'package:tripmate/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:tripmate/features/friends/data/repositories/friends_repository_impl.dart';
import 'package:tripmate/features/friends/domain/entities/friend.dart';
import 'package:tripmate/features/friends/domain/repositories/friends_repository.dart';

part 'friends_providers.g.dart';

@Riverpod(keepAlive: true)
FriendsDao friendsDao(Ref ref) =>
    FriendsDao(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
FriendsRemoteDataSource friendsRemoteDataSource(Ref ref) =>
    FriendsRemoteDataSource(ref.watch(supabaseClientProvider));

@Riverpod(keepAlive: true)
FriendsRepository friendsRepository(Ref ref) => FriendsRepositoryImpl(
      dao: ref.watch(friendsDaoProvider),
      remote: ref.watch(friendsRemoteDataSourceProvider),
    );

@riverpod
Stream<List<Friend>> friendsList(Ref ref) =>
    ref.watch(friendsRepositoryProvider).watchFriends();
