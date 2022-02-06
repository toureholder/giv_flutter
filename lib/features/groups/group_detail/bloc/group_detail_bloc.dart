import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group/repository/api/request/add_many_listings_to_group_request.dart';
import 'package:giv_flutter/model/group/repository/group_repository.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/group_membership/repository/group_membership_repository.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:rxdart/rxdart.dart';

class GroupDetailBloc extends BaseBloc {
  final GroupRepository groupRepository;
  final GroupMembershipRepository groupMembershipRepository;
  final PublishSubject<List<Product>> productsSubject;
  final PublishSubject<HttpResponse<GroupMembership>> leaveGroupSubject;
  final PublishSubject<HttpResponse<void>> addListingsSubject;
  final DiskStorageProvider diskStorage;
  final Util util;

  GroupDetailBloc({
    @required this.groupRepository,
    @required this.groupMembershipRepository,
    @required this.productsSubject,
    @required this.leaveGroupSubject,
    @required this.addListingsSubject,
    @required this.diskStorage,
    @required this.util,
  }) : super(diskStorage: diskStorage);

  Stream<HttpResponse<GroupMembership>> get leaveGroupStream =>
      leaveGroupSubject.stream;

  Stream<List<Product>> get productsStream => productsSubject.stream;

  Stream<HttpResponse<void>> get addListingsStream => addListingsSubject.stream;

  Future<void> getGroupListings({
    @required int groupId,
    @required int page,
    bool addLoadingState = false,
  }) async {
    try {
      // TODO: Adding null to represent loading state for now.
      if (addLoadingState) productsSubject.sink.add(null);

      final httpResponse = await groupRepository.getGroupListings(
        groupId: groupId,
        page: page,
      );

      final data = httpResponse.data;
      if (data != null) {
        productsSubject.sink.add(data);
      } else {
        productsSubject.sink.addError(httpResponse.message);
      }
    } catch (error) {
      productsSubject.sink.addError(error);
    }
  }

  Future<void> addManyListings({
    @required AddManyListingsToGroupRequest request,
  }) async {
    try {
      // TODO: Adding null to represent loading state for now.
      productsSubject.sink.add(null);

      final createListingsResponse =
          await groupRepository.addManyListingsToGroup(
        request,
      );

      if (createListingsResponse.status == HttpStatus.created) {
        getGroupListings(
          groupId: request.groupId,
          page: 1,
        );
      } else {
        addListingsSubject.sink.addError(createListingsResponse.message);
      }
    } catch (error) {
      addListingsSubject.sink.addError(error.toString());
    }
  }

  GroupMembership getMembershipById(int id) {
    return groupMembershipRepository.getMembershipById(id);
  }

  Future<void> leaveGroup({int membershipId}) async {
    try {
      leaveGroupSubject.sink.add(HttpResponse.loading());

      final httpResponse = await groupMembershipRepository.leaveGroup(
        membershipId: membershipId,
      );

      leaveGroupSubject.sink.add(httpResponse);
    } catch (error) {
      leaveGroupSubject.sink.addError(error);
    }
  }

  Future<void> shareGroup(BuildContext context, Group group) =>
      util.shareGroup(context, group);
}
