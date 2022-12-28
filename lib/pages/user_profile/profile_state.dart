/*import 'package:bloc/bloc.dart';
import 'profile_event.dart';
import 'profile_block.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- Add this line

abstract class ProfileState extends BlocState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;

  ProfileLoaded({this.name, this.email});
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({this.error});
}


// abstract class ProfileState {}

// class ProfileLoading extends ProfileState {}

// class ProfileLoaded extends ProfileState {
//   final String name;
//   final String email;

//   ProfileLoaded({this.firstName, this.email});
// }

// class ProfileError extends ProfileState {
//   final String error;

//   ProfileError(this.error);
// }

// class ProfileState {
//   final String error;

//   ProfileState({this.error});
// }

// class ProfileLoaded extends ProfileState {
//   final String name;
//   final String email;

//   ProfileLoaded({this.name, this.email});
// }

// class ProfileLoading extends ProfileState {}

// BlocBuilder<ProfileBloc, ProfileState>(
//   bloc: _profileBloc,
//   builder: (context, state) {
//     if (state is ProfileLoaded) {
//       _nameController.text = state.name;
//       _emailController.text = state.email;
//       return Column(
//         children: [
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(labelText: 'Name'),
//           ),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//           ),
//         ],
//       );
//     } else if (state is ProfileLoading) {
//       return Center(child: CircularProgressIndicator());
//     } else {
//       return Center(child: Text(state.error));
//     }
//   },
// )
*/

