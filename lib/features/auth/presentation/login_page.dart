import 'package:chat_supabase/features/chat/state/chat_notifier.dart';
import 'package:chat_supabase/features/chat/state/profile_notifier.dart';
import 'package:chat_supabase/utils/async_value_ui.dart';
import 'package:chat_supabase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common_widget/custom_text_button.dart';
import '../../../common_widget/primary_button.dart';
import '../../../common_widget/responsive_scrollable_card.dart';
import '../../../routing/app_router.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/stringValidator.dart';
import '../state/auth_notifier.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();

  final _email = TextEditingController();
  final _passwordController = TextEditingController();
  String get email => _email.text;
  String get password => _passwordController.text;

  bool _submitted = false;
  bool _loginType = true;

  bool _passwordVisible = true;

  @override
  void dispose() {
    _node.dispose();

    _email.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);

    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authNotifierProvider.notifier);

      final success = _loginType
          ? await authNotifier.login(email: email, password: password)
          : await authNotifier.signUp(email: email, password: password);

      if (success && mounted) {
        ref.read(chatNotifierProvider.notifier).syncMessages();
        ref.read(profileNotifierProvider.notifier).getTypingProfiles();
        context.replaceNamed(AppRoute.chat.name);
      }
    }
  }

  void _passwordEditingComplete() {
    if (!password.isNotEmpty && password.length >= 6) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _changeFormType() {
    setState(() {
      _loginType = !_loginType;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      authNotifierProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(authNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            alignment: Alignment.center,
            margin: 10.horizontalPadding,
            child: Center(
              child: ResponsiveScrollableCard(
                child: FocusScope(
                  node: _node,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        15.height,

                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                              hintText: AppLabels.email,
                              prefixIcon: Icon(Icons.person)),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) => !_submitted
                              ? null
                              : (email!.isEmpty ? AppLabels.emptyEmail : null),
                          inputFormatters: <TextInputFormatter>[
                            ValidatorInputFormatter(
                                editingValidator: EmailEditingRegexValidator()),
                          ],
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          keyboardAppearance: Brightness.light,
                        ),
                        8.height,
                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: AppLabels.password,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                child: _passwordVisible
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                          ),
                          validator: (password) => !_submitted
                              ? null
                              : (password!.isEmpty
                                  ? AppLabels.emptyPassword
                                  : null),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: _passwordVisible ? true : false,
                          autocorrect: false,
                          textInputAction: TextInputAction.done,
                          keyboardAppearance: Brightness.light,
                          onEditingComplete: () => _passwordEditingComplete(),
                        ),

                        8.height,
                        PrimaryButton(
                          text: _loginType ? AppLabels.login : AppLabels.signUp,
                          isLoading: state.isLoading,
                          onPressed:
                              state.isLoading ? () => {} : () => _submit(),
                        ),

                        8.height,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(!_loginType
                                ? 'Already account?'
                                : 'Create an account'),
                            CustomTextButton(
                              text: _loginType
                                  ? AppLabels.signUp
                                  : AppLabels.login,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline),
                              onPressed: _changeFormType,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
