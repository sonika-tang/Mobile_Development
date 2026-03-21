import 'package:flutter/material.dart';
import 'package:mobile/Week9-Firebase/model/artists/artists.dart';
import 'package:mobile/Week9-Firebase/ui/screens/artist/view_model/artist_view_model.dart';
import 'package:mobile/Week9-Firebase/ui/screens/artist/widgets/artist_tile.dart';
import 'package:mobile/Week9-Firebase/ui/utils/async_value.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';

class ArtistsContent extends StatelessWidget {
  const ArtistsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ArtistViewModel>();
    final AsyncValue<List<Artists>> asyncValue = vm.artistValue;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Error: ${asyncValue.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: vm.fetchArtists,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
        break;
      case AsyncValueState.success:
        final artists = asyncValue.data!;
        content = ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) =>
              ArtistTile(artist: artists[index]),
        );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text('Artists', style: AppTextStyles.heading),
          const SizedBox(height: 50),
          Expanded(child: content),
        ],
      ),
    );
  }
}
