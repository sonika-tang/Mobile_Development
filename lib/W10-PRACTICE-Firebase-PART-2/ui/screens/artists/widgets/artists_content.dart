import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/artist/artist.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/song/artist_tile.dart';
import '../view_model/artists_view_model.dart';

class ArtistsContent extends StatelessWidget {
  const ArtistsContent({super.key});

  @override
  Widget build(BuildContext context) {
    ArtistsViewModel mv = context.watch<ArtistsViewModel>();
    AsyncValue<List<Artist>> asyncValue = mv.artistsValue;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Text(
            'error = ${asyncValue.error!}',
            style: const TextStyle(color: Colors.red),
          ),
        );
        break;
      case AsyncValueState.success:
        List<Artist> artists = asyncValue.data!;
        content = ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) => ArtistTile(artist: artists[index]),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Library", style: AppTextStyles.heading),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                onPressed: () {
                  mv.fetchArtists(forceFetch: true);
                },
              ),
            ],
          ),
          const SizedBox(height: 50),
          Expanded(child: content),
        ],
      ),
    );
  }
}
