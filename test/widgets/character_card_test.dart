import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lovia/features/character/domain/entities/character.dart';
import 'package:lovia/features/character/presentation/widgets/character_card.dart';

void main() {
  const character = Character(
    id: 'c1',
    name: 'Aria',
    bio: 'A cozy night-owl who loves tea.',
    category: 'Cozy',
    traits: ['Warm'],
    age: 24,
    backstory: 'Runs a bookshop.',
    tone: 'Gentle',
    greeting: 'Hi',
    accent: 0,

  );

  testWidgets('renders the character name and bio and is tappable',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              height: 320,
              child: CharacterCard(
                character: character,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Aria'), findsOneWidget);
    expect(find.text('A cozy night-owl who loves tea.'), findsOneWidget);

    expect(find.text('A'), findsOneWidget);

    await tester.tap(find.byType(CharacterCard));
    expect(tapped, isTrue);
  });
}
