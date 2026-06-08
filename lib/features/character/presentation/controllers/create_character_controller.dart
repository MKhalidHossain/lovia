import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/domain/usecases/create_character.dart';

class CreateCharacterController extends GetxController {
  CreateCharacterController(this._createCharacter);
  final CreateCharacter _createCharacter;

  static const List<String> genderOptions = ['Male', 'Female', 'Non-binary'];

  static const List<String> categoryOptions = [
    'Anime',
    'Movie',
    'Cartoon',
    'Waifu',
    'Ultra',
    'Funny',
    'Helper',
    'Pal',
    'V-Day',
    'Realistic',
    'Xmas',
    'WCup',
  ];

  static const List<String> tagOptions = [
    '👥 Multiple',
    '💖 Charming',
    '🕊 Devotion',
    '🛏 Roommate',
    '😳 Shy',
    '🦊 Alluring',
    '🎧 E-girl',
    '📚 Fictional',
    '🧕 Mature',
    '💗 Crush',
    '🐉 Demi-Human',
    '🐍 Snarky',
    '👻 Supernatural',
    '👑 Bossy',
    '🪄 Fantasy',
    '🦸 Hero',
    '🧧 Fluff',
  ];

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController(text: '21');
  final TextEditingController introCtrl = TextEditingController();
  final TextEditingController personalityCtrl = TextEditingController();
  final TextEditingController languageCtrl = TextEditingController();
  final TextEditingController relationshipCtrl = TextEditingController();
  final TextEditingController previewCtrl = TextEditingController();

  final RxString name = ''.obs;
  final RxString gender = 'Female'.obs;
  final RxString category = categoryOptions.first.obs;
  final RxList<String> tags = <String>[].obs;
  final RxBool isSaving = false.obs;

  static const int maxTags = 3;

  @override
  void onClose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    introCtrl.dispose();
    personalityCtrl.dispose();
    languageCtrl.dispose();
    relationshipCtrl.dispose();
    previewCtrl.dispose();
    super.onClose();
  }

  bool get canSubmit {
    final age = int.tryParse(ageCtrl.text.trim()) ?? 0;
    return name.value.trim().length >= 2 && age >= 18 && tags.isNotEmpty;
  }

  void toggleTag(String tag) {
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else if (tags.length < maxTags) {
      tags.add(tag);
    } else {
      Get.snackbar('Tags', 'You can pick up to $maxTags tags.');
    }
  }

  void randomFill() {
    const names = ['Luna', 'Aria', 'Sky', 'Nova', 'Ivy', 'Sora'];
    const intros = [
      'Long auburn hair, warm hazel eyes, always in a cozy sweater.',
      'Silver hair, calm gaze, carries a sketchbook everywhere.',
      'Bright smile, freckles, loves oversized hoodies.',
    ];
    const personalities = [
      'Warm, witty, a little shy until she trusts you.',
      'Bubbly and adventurous, never runs out of ideas.',
      'Calm, thoughtful, an excellent listener.',
    ];
    final seed = name.value.length + tags.length;
    nameCtrl.text = names[seed % names.length];
    name.value = nameCtrl.text;
    introCtrl.text = intros[seed % intros.length];
    personalityCtrl.text = personalities[seed % personalities.length];
    languageCtrl.text = 'Casual, warm, uses the occasional emoji.';
    relationshipCtrl.text = 'Acts like a close friend who quietly cares.';
    previewCtrl.text = 'A cozy companion who always makes time for you.';
    if (tags.isEmpty) tags.addAll(tagOptions.take(2));
  }

  Future<Character?> submit() async {
    if (!canSubmit) {
      Get.snackbar('Almost there', 'Add a name, an age (18+), and a tag.');
      return null;
    }
    isSaving.value = true;
    final ageValue = int.tryParse(ageCtrl.text.trim()) ?? 18;
    final backstory = [
      introCtrl.text.trim(),
      personalityCtrl.text.trim(),
      relationshipCtrl.text.trim(),
    ].where((s) => s.isNotEmpty).join('\n\n');
    final character = Character(
      id: 'mine-${name.value.hashCode.toUnsigned(32)}',
      name: name.value.trim(),
      bio: previewCtrl.text.trim().isEmpty
          ? introCtrl.text.trim()
          : previewCtrl.text.trim(),
      category: category.value,
      traits: tags.map(_stripEmoji).toList(),
      age: ageValue < 18 ? 18 : ageValue,
      backstory: backstory.isEmpty ? 'A brand-new companion.' : backstory,
      tone: languageCtrl.text.trim().isEmpty
          ? 'Warm and friendly'
          : languageCtrl.text.trim(),
      greeting: "Hi, I'm ${name.value.trim()}. Lovely to meet you!",
      accent: name.value.hashCode,
      gender: gender.value,
      isMine: true,
    );
    final result = await _createCharacter(character);
    isSaving.value = false;
    return switch (result) {
      Success(:final value) => value,
      Failed() => null,
    };
  }

  String _stripEmoji(String tag) {
    final parts = tag.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : tag;
  }
}
