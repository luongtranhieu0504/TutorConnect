import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorconnect/presentation/screens/student/favorite/favorite_state.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';

import '../../../../di/di.dart';
import '../../../../domain/model/tutor.dart';
import 'favorite_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});


  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _bloc = getIt<FavoriteBloc>();

  @override
  void initState() {
    // TODO: implement initState
    _bloc.getFavorites();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is Success) {
            final favoriteTutors = (state).favoriteTutors;
            return _uiContent(context,favoriteTutors);
          } else if (state is Failure) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text("Unknown state"));
        },
        bloc: _bloc,
      ),
    );
  }



  Widget _uiContent(BuildContext context, List<Tutor> favoriteTutors) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Tutors',
          style: AppTextStyles(context).headingMedium,
        ),
        centerTitle: true,
      ),
      body: favoriteTutors.isEmpty
          ? Center(
              child: Text(
                'No favorite tutors yet!',
                style: AppTextStyles(context).bodyText1,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favoriteTutors.length,
              itemBuilder: (context, index) {
                final tutor = favoriteTutors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(tutor.user.photoUrl!)
                    ),
                    title: Text(
                      tutor.user.name ?? 'No name available',
                      style: AppTextStyles(context).bodyText2,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _bloc.removeFavorite(tutor.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}