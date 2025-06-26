import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/common/utils/format_utils.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/presentation/animation/animated_divider.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/screens/post/post_bloc.dart';
import 'package:tutorconnect/presentation/screens/post/post_bottom_sheet.dart';
import 'package:tutorconnect/presentation/screens/post/post_state.dart';
import 'package:tutorconnect/presentation/widgets/expandable_text.dart';
import 'package:tutorconnect/theme/text_styles.dart';

import '../../../domain/model/post.dart';
import '../../../domain/model/user.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _bloc = getIt<PostBloc>();
  late bool _favorite = false;
  int likeCount = 0;

  @override
  void initState() {
    _bloc.getPosts();
    super.initState();
  }

  void _showPostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PostBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is PostLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PostSuccessState) {
          final posts = state.posts;
          return _buildContent(posts);
        } else if (state is PostFailureState) {
          return Center(child: Text("Error: ${state.error}"));
        }
        return Container();
      },
    );
  }

  Widget _buildContent(List<Post> posts) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài đăng'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _bloc.getPosts();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(Account.instance.user.photoUrl!),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showPostSheet(context);
                      });
                    },
                    child: Text("Bạn muốn đăng gì ?",
                        style: AppTextStyles(context)
                            .bodyText2
                            .copyWith(fontSize: 18)),
                  ))
                ],
              ),
            ),
            Divider(
              thickness: 3,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _postCard(post);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _postCard(Post post) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Theme.of(context).colorScheme.surface.withOpacity(0.85)
                : Theme.of(context).colorScheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      context.push(
                        Routes.tutorProfilePage,
                      );
                    });
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(post.author!.photoUrl!),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.author!.name!,
                              style: AppTextStyles(context).bodyText1),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: post.author?.typeRole == 'Student'
                                      ? Colors.blue
                                      : Colors.orange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(post.author!.typeRole!,
                                    style: AppTextStyles(context)
                                        .bodyText1
                                        .copyWith(
                                          fontSize: 12,
                                        )),
                              ),
                              SizedBox(width: 8),
                              Text(FormatUtils.formatTimeAgo(post.createdAt),
                                  style: AppTextStyles(context)
                                      .bodyText2
                                      .copyWith(fontSize: 12)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ExpandableText(post.content!,
                    style: AppTextStyles(context).bodyText2),
                SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _favorite = !_favorite;
                          _bloc.likePost(post.id, Account.instance.user.id);
                        });
                      },
                      icon: _favorite
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                    ),
                    SizedBox(width: 4),
                    Text(post.likeCount.toString(),
                        style: AppTextStyles(context).bodyText2),
                    SizedBox(width: 16),
                    IconButton(
                        onPressed: () {
                          context.push(
                            Routes.postCommentPage,
                            extra: post,
                          );
                        },
                        icon: Icon(Icons.comment_outlined)),
                    SizedBox(width: 4),
                    Text(post.commentCount.toString(),
                        style: AppTextStyles(context).bodyText2),
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedDivider()
      ],
    );
  }
}
