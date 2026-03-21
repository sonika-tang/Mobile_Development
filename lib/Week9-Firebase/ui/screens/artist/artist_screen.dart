import 'package:flutter/material.dart';
import 'package:mobile/Week9-Firebase/data/repositories/artists/artist_repository.dart';
import 'package:mobile/Week9-Firebase/ui/screens/artist/view_model/artist_view_model.dart';
import 'package:mobile/Week9-Firebase/ui/screens/artist/widgets/artist_content.dart';
import 'package:provider/provider.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ArtistViewModel(artistRepository: context.read<ArtistRepository>()),
      child: const ArtistsContent(),
    );
  }
}
