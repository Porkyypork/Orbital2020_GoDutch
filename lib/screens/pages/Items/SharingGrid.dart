import 'package:app/models/MemberDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SharingGrid extends StatefulWidget {
  final List<MemberDetails> selectedMembers;

  SharingGrid({this.selectedMembers});

  @override
  _SharingGridState createState() =>
      _SharingGridState(selectedMembers: this.selectedMembers);
}

class _SharingGridState extends State<SharingGrid> {
  List<MemberDetails> selectedMembers;

  _SharingGridState({this.selectedMembers});
  @override
  Widget build(BuildContext context) {
    final members = Provider.of<List<MemberDetails>>(context);

    return SizedBox(
      height: 175,
      child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 10),
          children: List.generate(members.length, (index) {
            return CheckboxListTile(
                activeColor: Colors.green,
                checkColor: Colors.white,
                title: Text(
                  members[index].name,
                  style: TextStyle(color: Colors.white),
                ),
                value: selectedMembers.contains(members[index]),
                onChanged: (bool select) {
                  setState(() {
                    _onSelect(select, members[index]);
                  });
                });
          })),
    );
  }

  void _onSelect(bool select, MemberDetails member) {
    if (select) {
      selectedMembers.add(member);
    } else {
      selectedMembers.removeWhere((element) => element.name == member.name);
    }
  }
}
