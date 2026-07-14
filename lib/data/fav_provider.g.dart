// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FavouritesNotifier)
final favouritesProvider = FavouritesNotifierProvider._();

final class FavouritesNotifierProvider
    extends $AsyncNotifierProvider<FavouritesNotifier, List<WordItem>> {
  FavouritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favouritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favouritesNotifierHash();

  @$internal
  @override
  FavouritesNotifier create() => FavouritesNotifier();
}

String _$favouritesNotifierHash() =>
    r'e60f20a8134f0e8dee63b34692ac18ec6cf5ac1d';

abstract class _$FavouritesNotifier extends $AsyncNotifier<List<WordItem>> {
  FutureOr<List<WordItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<WordItem>>, List<WordItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WordItem>>, List<WordItem>>,
              AsyncValue<List<WordItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
