abstract class ChatState {}

class ChatInitialState extends ChatState {}

// class LoginFormErrorState extends LoginState {
//   late String loginFormErrorMessage;
//   LoginFormErrorState(this.loginFormErrorMessage);
// }

class ChatLoadingState extends ChatState {}

// class LoginSuccessState extends LoginState {
//   late String loginSuccessMessage;
//   LoginSuccessState(this.loginSuccessMessage);
// }

// class LoginFormValidState extends LoginState {}

class ChatErrorState extends ChatState {
  late String chatErrorMessage;
  ChatErrorState(this.chatErrorMessage);
}