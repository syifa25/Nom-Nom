import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nom_nom/features/center_notice.dart';
import 'package:nom_nom/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'meal_plan_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  static const _backgroundColor = Color(0xFFFFF4E5);
  static const _primaryColor = Color(0xFFE66A3C);
  static const _brownColor = Color(0xFF8B3E20);

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: _primaryColor),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: _primaryColor),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (_profileImage != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Hapus Foto Profil',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    setState(() {
                      _profileImage = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Dialog utama Pengaturan Akun: pilih Ubah Nama atau Ganti Password
  void _showAccountSettingsDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Pengaturan Akun',
            style: TextStyle(
              color: _brownColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: _brownColor,
                  ),
                ),
                title: const Text(
                  'Ubah Nama Lengkap',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _brownColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _showEditNameDialog();
                },
              ),
              const Divider(height: 8),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: _brownColor,
                  ),
                ),
                title: const Text(
                  'Ganti Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _brownColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _showChangePasswordDialog();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNameDialog() {
    final nameController = TextEditingController(
      text: AuthService.instance.currentUserName ?? '',
    );
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: !isSaving,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (innerContext, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Ubah Nama Lengkap',
                style: TextStyle(
                  color: _brownColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                  isSaving ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                    final newName = nameController.text.trim();
                    if (newName.isEmpty) {
                      showCenterNotice(
                        context,
                        message: 'Nama tidak boleh kosong',
                        icon: Icons.error_outline_rounded,
                      );
                      return;
                    }

                    setDialogState(() => isSaving = true);

                    try {
                      await AuthService.instance.updateProfileName(newName);
                      if (!mounted) return;
                      Navigator.pop(dialogContext);
                      setState(() {});
                      showCenterNotice(
                        context,
                        message: 'Nama berhasil diperbarui',
                        icon: Icons.check_circle_rounded,
                      );
                    } on AuthException catch (e) {
                      if (!mounted) return;
                      setDialogState(() => isSaving = false);
                      showCenterNotice(
                        context,
                        message: e.message,
                        icon: Icons.error_outline_rounded,
                      );
                    } catch (_) {
                      if (!mounted) return;
                      setDialogState(() => isSaving = false);
                      showCenterNotice(
                        context,
                        message: 'Gagal memperbarui nama',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                  },
                  child: Text(isSaving ? 'Menyimpan...' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: !isSaving,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (innerContext, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Ganti Password',
                style: TextStyle(
                  color: _brownColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: currentPassController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password Lama',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: newPassController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password Baru',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmPassController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                  isSaving ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                    final currentPass = currentPassController.text;
                    final newPass = newPassController.text;
                    final confirmPass = confirmPassController.text;

                    if (currentPass.isEmpty ||
                        newPass.isEmpty ||
                        confirmPass.isEmpty) {
                      showCenterNotice(
                        context,
                        message: 'Semua kolom password wajib diisi',
                        icon: Icons.error_outline_rounded,
                      );
                      return;
                    }

                    if (newPass.length < 6) {
                      showCenterNotice(
                        context,
                        message: 'Password baru minimal 6 karakter',
                        icon: Icons.error_outline_rounded,
                      );
                      return;
                    }

                    if (newPass != confirmPass) {
                      showCenterNotice(
                        context,
                        message: 'Konfirmasi password tidak cocok',
                        icon: Icons.error_outline_rounded,
                      );
                      return;
                    }

                    setDialogState(() => isSaving = true);

                    try {
                      await AuthService.instance.changePassword(
                        currentPassword: currentPass,
                        newPassword: newPass,
                      );
                      if (!mounted) return;
                      Navigator.pop(dialogContext);
                      showCenterNotice(
                        context,
                        message: 'Password berhasil diperbarui',
                        icon: Icons.check_circle_rounded,
                      );
                    } on AuthException catch (e) {
                      if (!mounted) return;
                      setDialogState(() => isSaving = false);
                      showCenterNotice(
                        context,
                        message: e.message,
                        icon: Icons.error_outline_rounded,
                      );
                    } catch (_) {
                      if (!mounted) return;
                      setDialogState(() => isSaving = false);
                      showCenterNotice(
                        context,
                        message: 'Gagal mengubah password',
                        icon: Icons.error_outline_rounded,
                      );
                    }
                  },
                  child: Text(isSaving ? 'Menyimpan...' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AuthService.instance.isLoggedIn,
      builder: (context, _, __) {
        final supabaseUser = AuthService.instance.currentUser;
        final metaName = supabaseUser?.userMetadata?['full_name'] as String?;

        final rawName = (AuthService.instance.currentUserName != null &&
            AuthService.instance.currentUserName!.trim().isNotEmpty)
            ? AuthService.instance.currentUserName!.trim()
            : (metaName != null && metaName.trim().isNotEmpty)
            ? metaName.trim()
            : (supabaseUser?.email != null &&
            supabaseUser!.email!.isNotEmpty)
            ? supabaseUser.email!.split('@').first
            : 'Pengguna';

        final userName = rawName.isNotEmpty
            ? rawName[0].toUpperCase() + rawName.substring(1)
            : 'Pengguna';

        final userEmail = (AuthService.instance.currentUserEmail != null &&
            AuthService.instance.currentUserEmail!.trim().isNotEmpty)
            ? AuthService.instance.currentUserEmail!.trim()
            : (supabaseUser?.email ?? '-');

        final initialLetter =
        userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

        return Scaffold(
          backgroundColor: _backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // --- FOTO PROFIL ---
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: _primaryColor,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!) as ImageProvider
                              : null,
                          child: _profileImage == null
                              ? Text(
                            initialLetter,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImageSourceActionSheet,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: _brownColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- NAMA & EMAIL ---
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _brownColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- LIST MENU PILIHAN ---
                  _buildMenuItem(
                    Icons.calendar_month_rounded,
                    'Rencana Masak (Meal Plan)',
                    const Color(0xFF6C8EBF),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MealPlanPage()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    Icons.settings_outlined,
                    'Pengaturan Akun',
                    _brownColor,
                    onTap: _showAccountSettingsDialog,
                  ),
                  _buildMenuItem(
                    Icons.logout_rounded,
                    'Keluar',
                    _primaryColor,
                    isLogout: true,
                    onTap: () async {
                      await AuthService.instance.logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
      IconData icon,
      String title,
      Color iconColor, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D8C8)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isLogout ? iconColor : _brownColor,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}