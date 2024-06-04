import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morty_flutter/app/widgets/app_bar.dart';
import 'package:morty_flutter/app/widgets/empty_screen.dart';
import 'package:morty_flutter/app/widgets/error_screen.dart';
import 'package:morty_flutter/app/widgets/line_view.dart';
import 'package:morty_flutter/app/widgets/loading_screen.dart';
import 'package:morty_flutter/core/view_state.dart';
import 'package:morty_flutter/data/model/dto/character/character_dto.dart';
import 'package:morty_flutter/presentation/characters/detail/character_detail_screen.dart';
import 'package:stacked/stacked.dart';

import 'location_detail_view_model.dart';

class LocationDetailScreen extends StatelessWidget {
  static const route = '/locationDetail/:locationId';

  final String locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LocationDetailViewModel>.reactive(
        viewModelBuilder: () => LocationDetailViewModel(),
        onModelReady: (viewModel) {
          viewModel.loadDetail(int.parse(locationId));
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(viewModel),
          );
        });
  }

  _navigateCharacterDetail(BuildContext context, int? id) {
    context
        .pushNamed(CharacterDetailScreen.route, pathParameters: {'characterId': '$id'});
  }

  RortyAppBarWithBack _buildAppBar() {
    return RortyAppBarWithBack(title: tr("location_detail"));
  }

  Widget _buildBody(LocationDetailViewModel viewModel) {
    switch (viewModel.viewState.state) {
      case ResponseState.LOADING:
        return const LoadingScreen();
      case ResponseState.COMPLETE:
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTitle(tr("information")),
              _buildRowView(
                  tr("name"), viewModel.dto?.name ?? "***", true, false),
              _buildRowView(tr("dimension"), viewModel.dto?.dimension ?? "***",
                  true, false),
              _buildRowView(
                  tr("type"), viewModel.dto?.type ?? "***", false, false),
              if (viewModel.dto != null &&
                  viewModel.dto!.residentDtoList.isNotEmpty)
                _buildTitle(tr("characters")),
              _buildCharacters(viewModel.dto?.residentDtoList ?? List.empty())
            ],
          ),
        );
      case ResponseState.ERROR:
        return const ErrorScreen();
      case ResponseState.EMPTY:
        return const EmptyScreen();
    }
  }

  Widget _buildCharacters(List<CharacterDto> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _navigateCharacterDetail(context, list[index].id),
          child: _buildCharacterRowView(list[index]),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRowView(
      String key, String value, bool showDivider, bool showArrow) {
    return Card(
      shape: const RoundedRectangleBorder(),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      key,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        value,
                        style: TextStyle(fontWeight: FontWeight.w500),
                        softWrap: false,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                      if (showArrow)
                        IconButton(
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.arrow_right,
                          ),
                          onPressed: () {
                            print("ccc");
                          },
                        ),
                    ],
                  )
                ],
              ),
            ),
            if (showDivider) const LineView()
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterRowView(CharacterDto dto) {
    return Card(
      shape: const RoundedRectangleBorder(),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          "${dto.image}",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${dto.name}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_right,
                    ),
                    onPressed: () {
                      print("ccc");
                    },
                  ),
                ],
              ),
              const LineView()
            ],
          )),
    );
  }
}
