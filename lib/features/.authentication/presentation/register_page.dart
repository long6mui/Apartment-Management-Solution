import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import 'resident_info_page.dart';
import 'guest_info_page.dart';
import '../../../core/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  final AuthenticationService authService;

  const RegisterPage({super.key, required this.authService});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedRole = 'resident'; // Mặc định là 'Cư dân'

  bool isLoading = false;
  String? message;

  Future<void> navigateToInfoPage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
      message = null;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Chuyển hướng tới trang nhập thông tin tương ứng mà không tạo tài khoản
      if (selectedRole == 'resident') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResidentInfoPage(
              authService: widget.authService,
              email: email,
              password: password,
            ),
          ),
        );
      } else if (selectedRole == 'guest') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GuestInfoPage(
              authService: widget.authService,
              email: email,
              password: password,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        message = 'Lỗi: $e';
        isLoading = false;
      });
      print('Lỗi khi chuyển hướng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 500;
        return Scaffold(
          body: Stack(
            children: [
              // Nền gradient toàn màn hình
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.accentColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Decorative circles
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accentColor.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accentColor.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                right: 50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accentColor.withOpacity(0.2),
                  ),
                ),
              ),
              // Nội dung chính
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: isMobile ? double.infinity : 800,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: isMobile
                        ? buildRegisterForm()
                        : IntrinsicHeight(
                            child: Row(
                              children: [
                                // Bên trái: Form đăng ký
                                Expanded(
                                  flex: 1,
                                  child: buildRegisterForm(),
                                ),
                                const SizedBox(width: 32),
                                // Bên phải: Chào mừng
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.center, // Căn lề trái
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Vui lòng',
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'nhập thông tin đăng ký!',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              // Hiển thị thông báo khi có lỗi hoặc thông tin
              if (message != null)
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: message!.contains('thành công') ? AppTheme.successColor : AppTheme.dangerColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              // Hiển thị loading
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Hàm xây dựng form đăng ký
  Widget buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 50),
          const Text(
            'ĐĂNG KÝ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Mật khẩu',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 6) {
                return 'Mật khẩu phải có ít nhất 6 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedRole,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: 'Vai trò',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: <String>['resident', 'guest'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value == 'resident' ? 'Cư Dân' : 'Khách'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedRole = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng chọn vai trò.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Nút Đăng Ký với Gradient
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: navigateToInfoPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Chữ màu trắng
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Nút Quay lại Đăng Nhập với viền gradient và nền trắng
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Quay lại đăng nhập',
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
